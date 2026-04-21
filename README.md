# SumUp Payments Analytics Dashboard

**Author:** Viktor Dimitrov  
**Tools:** Tableau Public · SQLite · Python  
**Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/viktor.dimitrov/viz/SampleProject2_17766290008950/Overview)

---

## Project Overview

End-to-end payments analytics project built as part of a **Senior Product Data Analyst** application at SumUp. The project simulates a real-world payments data environment with 200 merchants, ~5,000 transactions, and covers revenue performance, merchant growth, and risk & fraud analysis across three interactive Tableau dashboards.

---

## Dashboards

### 1. Overview
High-level business performance across all merchants and markets.

![Overview Dashboard](screenshots/overview.png)

| KPI | Value |
|-----|-------|
| Total Revenue EUR | €4,893K |
| Total Transactions | 4,977 |
| AVG Chargeback Rate | 26.61% |
| AVG Conversion Rate | 85.5% |

**Visualizations:**
- Revenue by Country Map — bubble map showing net revenue per market
- Monthly Revenue Trend By Year — line chart with average reference line (2023–2026)
- Top 10 Merchants by Total Revenue — horizontal bar chart
- Payment Method Distribution — donut chart (Apple Pay, Card, Contactless, Google Pay, QR Code)

---

### 2. Merchants
Merchant-level performance, onboarding, and plan evolution.

![Merchants Dashboard](screenshots/merchants.png)

**KPI Cards:** Total Merchants · Active Merchants · Avg Revenue per Merchant · Churn Risk Merchants

**Visualizations:**
- Monthly Revenue by Merchant — stacked bar chart (Top 10 merchants)
- Onboarding Funnel — horizontal bar with conversion % per step
- Feature Adoption — treemap by feature usage
- Upgrade vs Downgrade Plan — donut chart (93.63% upgrades)

---

### 3. Risk
Fraud, chargeback, and merchant risk analysis.

![Risk Dashboard](screenshots/risk.png)

| KPI | Value |
|-----|-------|
| Overall CB Rate | 11.66% |
| Open Chargebacks | 101 |
| Refund Amount | €301K |
| Total CB Amount at Risk | €136K |

**Visualizations:**
- Top Merchants by Chargeback Rate — scatter plot (volume vs CB rate, sized by CB count)
- Most Common Chargeback Reasons — horizontal bar chart with AVG resolution time
- Refund Analysis — donut chart by refund reason
- Merchant Risk Profile — heatmap (Risk Category × Business Type)

---

## Data Model

13 CSV source files simulating a payments data warehouse:

| Table | Description |
|-------|-------------|
| `transactions_EUR.csv` | All transactions converted to EUR via monthly exchange rates |
| `merchants.csv` | Merchant profiles — country, plan, onboarding date |
| `customers.csv` | Customer demographics |
| `chargebacks.csv` | Chargeback cases with reason, status, resolution time |
| `refunds.csv` | Refund cases with amount and reason |
| `merchant_risk_scores.csv` | Risk scores, categories and flagged status |
| `feature_adoption.csv` | Feature usage per merchant |
| `onboarding_steps.csv` | Onboarding funnel steps per merchant |
| `subscription_changes.csv` | Plan upgrade/downgrade history |
| `payment_methods.csv` | Payment method reference |
| `exchange_rates.csv` | Monthly EUR exchange rates per currency |
| `merchant_monthly_summary.csv` | Pre-aggregated monthly merchant metrics |
| `product_events.csv` | Product interaction events |

---

## SQL

All analytical queries written in **SQLite**.

### Views

#### `vw_transactions_EUR`
Converts all transaction amounts to EUR using monthly exchange rates for standardized cross-currency analysis.
```sql
CREATE VIEW vw_transactions_EUR AS
SELECT
    t.transaction_id,
    t.merchant_id,
    t.customer_id,
    strftime('%Y-%m', t.transaction_date) AS year_month,
    t.transaction_date,
    UPPER(TRIM(t.currency)) AS original_currency,
    UPPER(TRIM(t.payment_method)) AS payment_method,
    UPPER(TRIM(t.status)) AS status,
    ROUND(CAST(t.amount AS REAL) * CAST(er.rate_to_eur AS REAL), 2) AS amount_EUR,
    ROUND(CAST(t.fee AS REAL) * CAST(er.rate_to_eur AS REAL), 2) AS fee_EUR,
    ROUND(CAST(t.net_amount AS REAL) * CAST(er.rate_to_eur AS REAL), 2) AS net_amount_EUR
FROM transactions t
JOIN exchange_rates er 
    ON UPPER(TRIM(t.currency)) = UPPER(TRIM(er.currency))
    AND strftime('%Y-%m', t.transaction_date) = er.month;
```

#### `vw_merchant_KPIs`
Consolidated merchant KPI view combining revenue, conversion rate, chargeback rate, last activity, payment preferences, subscription plan changes and risk profile for each merchant.

### Analytical Queries

#### Top 10 Merchants by Total Revenue
Ranks merchants by net revenue in EUR to identify top performers and support account management prioritization.

#### Top Merchants by Chargeback Rate
Ranks merchants by chargeback rate to identify high-risk merchants and enable proactive fraud prevention interventions.

#### Upgrade vs Downgrade Rate
Analyzes subscription plan transitions to measure upgrade/downgrade rates and identify revenue churn patterns.

#### Time to First Transaction
Calculates days between merchant onboarding and first completed transaction to measure activation speed and support targeted interventions for slow-activating merchants.

> Full SQL files available in the `/sql` folder.

---

## Key Insights

- **France leads revenue** with €836K, followed by Italy (€719K) and Spain (€668K)
- **2025 was peak revenue year** — significantly higher than 2023 and 2024
- **Payment methods are evenly distributed** — no single method dominates (~20% each), indicating healthy payment mix
- **93.63% of plan changes are upgrades** — strong signal of product-market fit and merchant satisfaction
- **Only 12.42% of merchants complete first transaction** — significant drop-off after terminal activation, opportunity for onboarding intervention
- **Services sector has the only High-risk merchant** — Beauty and Electronics dominate Medium risk category
- **Fraud is the #1 chargeback reason** with ~25h average resolution time across all categories

---

## Repository Structure

```
sumup-payments-analytics/
│
├── README.md
├── data/
│   ├── transactions_EUR.csv
│   ├── merchants.csv
│   ├── chargebacks.csv
│   ├── refunds.csv
│   ├── merchant_risk_scores.csv
│   ├── feature_adoption.csv
│   ├── onboarding_steps.csv
│   ├── subscription_changes.csv
│   ├── payment_methods.csv
│   ├── exchange_rates.csv
│   ├── customers.csv
│   ├── merchant_monthly_summary.csv
│   └── product_events.csv
│
├── sql/
│   ├── vw_transactions_eur.sql
│   ├── vw_merchant_kpis.sql
│   ├── Top_10_Merchants_by_Total_Revenue.sql
│   ├── Top_Merchants_by_Chargeback_Rate.sql
│   ├── Upgrade_vs_Downgrade_Rate.sql
│   └── Time_to_First_Transaction.sql
│
└── screenshots/
    ├── overview.png
    ├── merchants.png
    └── risk.png
```

---

## How to Run

1. Clone the repository
2. Open SQLite and run `vw_transactions_eur.sql` first, then `vw_merchant_kpis.sql`
3. Run individual analytical queries from the `/sql` folder
4. Open Tableau Public and connect to the CSV files in `/data`
5. Or view the live dashboard directly: [Tableau Public](https://public.tableau.com/app/profile/viktor.dimitrov/viz/SampleProject2_17766290008950/Overview)
