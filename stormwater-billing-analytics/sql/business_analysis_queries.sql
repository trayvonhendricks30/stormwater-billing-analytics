-- 1. Flagged invoices
SELECT
    invoice_id,
    property_id,
    property_type,
    invoice_amount,
    expected_amount,
    billing_variance,
    outstanding_balance,
    final_quality_flag
FROM invoice_analysis
WHERE final_quality_flag <> ''
ORDER BY invoice_id;


-- 2. Overall KPIs
SELECT
    COUNT(*) AS total_invoices,
    ROUND(SUM(invoice_amount), 2) AS total_billed,
    ROUND(SUM(amount_paid), 2) AS total_collected,
    ROUND(SUM(outstanding_balance), 2) AS outstanding_balance,
    ROUND(
        100.0 * SUM(amount_paid) / SUM(invoice_amount),
        1
    ) AS collection_rate_pct,
    SUM(
        CASE WHEN final_quality_flag <> '' THEN 1 ELSE 0 END
    ) AS flagged_invoices
FROM invoice_analysis;


-- 3. Quarterly performance
SELECT
    billing_period,
    COUNT(*) AS invoice_count,
    ROUND(SUM(invoice_amount), 2) AS total_billed,
    ROUND(SUM(amount_paid), 2) AS total_collected,
    ROUND(SUM(outstanding_balance), 2) AS outstanding_balance,
    ROUND(
        100.0 * SUM(amount_paid) / SUM(invoice_amount),
        1
    ) AS collection_rate_pct,
    SUM(
        CASE WHEN final_quality_flag <> '' THEN 1 ELSE 0 END
    ) AS flagged_invoices
FROM invoice_analysis
GROUP BY billing_period
ORDER BY billing_period;


-- 4. Performance by property type
SELECT
    COALESCE(property_type, 'Unknown') AS property_type,
    COUNT(*) AS invoice_count,
    ROUND(SUM(invoice_amount), 2) AS total_billed,
    ROUND(SUM(amount_paid), 2) AS total_collected,
    ROUND(SUM(outstanding_balance), 2) AS outstanding_balance,
    ROUND(
        100.0 * SUM(amount_paid) / SUM(invoice_amount),
        1
    ) AS collection_rate_pct
FROM invoice_analysis
GROUP BY COALESCE(property_type, 'Unknown')
ORDER BY outstanding_balance DESC;


-- 5. Top 10 outstanding invoices
SELECT
    invoice_id,
    property_id,
    owner_name,
    city,
    COALESCE(property_type, 'Unknown') AS property_type,
    billing_period,
    invoice_amount,
    amount_paid,
    outstanding_balance,
    payment_status,
    final_quality_flag
FROM invoice_analysis
WHERE outstanding_balance > 0
ORDER BY outstanding_balance DESC
LIMIT 10;