CREATE VIEW billing_analysis AS
SELECT
    invoice_id,
    property_id,
    billing_period,
    invoice_date,
    due_date,
    CAST(
        REPLACE(REPLACE(TRIM(invoice_amount), '$', ''), ',', '')
        AS REAL
    ) AS invoice_amount,
    CAST(
        REPLACE(REPLACE(TRIM(amount_paid), '$', ''), ',', '')
        AS REAL
    ) AS amount_paid,
    payment_status,
    payment_date,
    dispute_reason,
    Data_Quality_Flag AS data_quality_flag
FROM billing;

CREATE VIEW rate_schedule_analysis AS
SELECT
    billing_period,
    property_type,
    CASE
        WHEN billing_period = 'FY2025-Q1'
            AND property_type = 'Residential' THEN 0.042
        WHEN billing_period = 'FY2025-Q1'
            AND property_type = 'Commercial' THEN 0.057
        WHEN billing_period = 'FY2025-Q1'
            AND property_type = 'Industrial' THEN 0.064
        WHEN billing_period = 'FY2025-Q1'
            AND property_type = 'Municipal' THEN 0.039
        WHEN billing_period = 'FY2025-Q1'
            AND property_type = 'Mixed Use' THEN 0.052
        WHEN billing_period = 'FY2025-Q2'
            AND property_type = 'Residential' THEN 0.043
        WHEN billing_period = 'FY2025-Q2'
            AND property_type = 'Commercial' THEN 0.058
        WHEN billing_period = 'FY2025-Q2'
            AND property_type = 'Industrial' THEN 0.065
        WHEN billing_period = 'FY2025-Q2'
            AND property_type = 'Municipal' THEN 0.040
        WHEN billing_period = 'FY2025-Q2'
            AND property_type = 'Mixed Use' THEN 0.053
    END AS rate_per_sqft,
    CAST(
        REPLACE(REPLACE(TRIM(base_fee), '$', ''), ',', '')
        AS REAL
    ) AS base_fee,
    calculation_rule
FROM rate_schedule;
CREATE VIEW invoice_analysis AS
WITH joined_data AS (
    SELECT
        b.invoice_id,
        b.property_id,
        b.billing_period,
        b.invoice_date,
        b.due_date,
        b.invoice_amount,
        b.amount_paid,
        b.payment_status,
        b.payment_date,
        b.dispute_reason,
        b.data_quality_flag AS billing_flag,
        p.city,
        p.property_type,
        p.impervious_area_sqft,
        p.owner_name,
        p.account_status,
        p.data_quality_flag AS property_flag,
        r.rate_per_sqft,
        r.base_fee
    FROM billing_analysis AS b
    LEFT JOIN properties_analysis AS p
        ON b.property_id = p.property_id
    LEFT JOIN rate_schedule_analysis AS r
        ON b.billing_period = r.billing_period
       AND p.property_type = r.property_type
),
calculated_data AS (
    SELECT
        *,
        CASE
            WHEN property_type IS NULL
              OR impervious_area_sqft <= 0
              OR rate_per_sqft IS NULL
            THEN NULL
            ELSE ROUND(
                impervious_area_sqft * rate_per_sqft + base_fee,
                2
            )
        END AS expected_amount
    FROM joined_data
)
SELECT
    *,
    ROUND(
        invoice_amount - expected_amount,
        2
    ) AS billing_variance,
    ROUND(
        invoice_amount - amount_paid,
        2
    ) AS outstanding_balance,
    CASE
        WHEN billing_flag IS NOT NULL
             AND billing_flag <> ''
            THEN billing_flag
        WHEN property_flag IS NOT NULL
             AND property_flag <> ''
            THEN property_flag
        WHEN ABS(invoice_amount - expected_amount) > 0.01
            THEN 'Invoice amount mismatch'
        ELSE ''
    END AS final_quality_flag
FROM calculated_data;