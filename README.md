Stormwater Billing Analytics



Project Summary

I analyzed a simulated stormwater billing dataset to answer three questions:

  1. How much money was billed, collected, and still unpaid?

  2. Which property types had the largest outstanding balances?

  3. Which invoices contained possible data-quality problems?

Interactive dashboard: View on Tableau Public

This project uses fictional data created for portfolio purposes. It does not contain real company or customer information.

Tools

  -Excel: cleaned and reviewed the data

  -SQLite: joined tables and calculated business metrics

  -Tableau: created the dashboard

What I Did

  1. Cleaned property and billing records in Excel.
  
  2. Removed duplicates and standardized inconsistent values.
  
  3. Flagged missing, invalid, or contradictory records instead of guessing corrections.
  
  4. Used SQL to join property, invoice, and rate data.
  
  5. Calculated expected charges, outstanding balances, collection rates, and billing differences.
  
  6. Built a Tableau dashboard to present the results.

Key Results

Total invoices - 120

Total billed - $58,902.01

Total collected - $38,633.21

Outstanding balance - $20,268.80

Collection rate - 65.6%

Flagged invoices - 8

Main Findings

The collection rate improved from 60.4% in Q1 to 70.7% in Q2.

Industrial properties accounted for $11,095.72, about 55% of all outstanding balances.

Eight invoices required review because of missing, invalid, or inconsistent information.

Operations should prioritize Industrial accounts and review flagged invoices before collection activity.

Project Files

data/     Cleaned data and final analysis dataset
sql/      Data preparation and business-analysis queries
images/   Tableau dashboard image

How I Would Explain This Project

I created a simulated stormwater billing project to practice an end-to-end analyst workflow. I cleaned the data in Excel, joined three tables in SQLite, checked invoice accuracy, and calculated billing and collection metrics. Then I built a Tableau dashboard. The main finding was that Industrial properties accounted for about 55% of outstanding balances, while the overall collection rate improved by about 10 percentage points from Q1 to Q2.
