# SQL E-Commerce Analysis

SQL analysis of a real e-commerce marketplace using the Brazilian E-Commerce Public Dataset by Olist (100k orders, 2016–2018).

This project focuses on core business metrics relevant to marketplace platforms: revenue trends, seller performance, logistics efficiency, and payment behavior.

---

## Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data) — Kaggle  
**Size:** ~100,000 orders | 2016–2018  
**Tables used:** `orders`, `order_items`, `order_payments`, `sellers`, `customers`  
**Tool:** Google BigQuery

---

## Schema

```
orders ──────────── order_items ──────────── sellers
   │                     │
   │                     └──────────────── products
   │
order_payments
customers
```

---

## Analysis & Key Findings

### 1. Orders Overview
96% of all orders were successfully delivered. 625 orders were canceled — a low cancellation rate indicating a reliable platform.

### 2. Monthly Revenue Trend
The platform grew from 3 orders in September 2016 to over 8,000 orders per month by early 2018. November 2017 showed a significant spike (8,475 orders / R$987k revenue), likely driven by Black Friday.

### 3. Top 10 Sellers by Revenue
São Paulo (SP) dominates — 6 of the top 10 sellers by revenue are based in SP. The top seller generated R$229k from 1,132 orders, while the #3 seller processed 1,806 orders but lower revenue, reflecting a lower average ticket price.

Window function used: `RANK() OVER (ORDER BY SUM(price) DESC)`

### 4. Average Delivery Time by State
Delivery performance varies significantly by geography. São Paulo (SP), Rio de Janeiro (RJ) and Rio Grande do Sul (RS) deliver in ~12 days. Remote states like Amazonas (AM) average 48 days due to logistical challenges. This analysis could support decisions on regional warehouse placement or seller incentives.

| State Code | State Name |
|------------|------------|
| SP | São Paulo |
| RJ | Rio de Janeiro |
| RS | Rio Grande do Sul |
| MG | Minas Gerais |
| PR | Paraná |
| SC | Santa Catarina |
| BA | Bahia |
| GO | Goiás |
| DF | Distrito Federal |
| ES | Espírito Santo |
| MS | Mato Grosso do Sul |
| MT | Mato Grosso |
| PE | Pernambuco |
| CE | Ceará |
| MA | Maranhão |
| RO | Rondônia |
| AM | Amazonas |
| PA | Pará |
| RN | Rio Grande do Norte |
| PB | Paraíba |
| PI | Piauí |
| SE | Sergipe |

### 5. Customer Retention
**Dataset limitation identified:** Olist assigns a unique `customer_id` per order rather than per customer for anonymization purposes. This makes traditional cohort retention analysis impossible with this dataset. A real-world platform like Rover or eDreams would track returning users via a persistent user ID, enabling LTV and cohort analysis.

### 6. Payment Methods Distribution
Credit card is the dominant payment method (76% of transactions, R$12.5M revenue). Boleto (cash payment slip) accounts for 19% — reflecting a segment of the Brazilian population without access to credit. Vouchers and debit cards are marginal.

### 7. Credit Card Installments
Single-installment purchases are the most common (25k orders, avg R$95). As installments increase, average order value rises — up to R$615 for 20-installment purchases. This suggests a clear relationship between financing options and purchase size, relevant for pricing and credit risk strategy.

---

## Conclusions

This analysis reveals three consistent patterns across the dataset that reflect real marketplace dynamics:

**Logistics follows geography.** The states with the highest order volume — São Paulo, Rio de Janeiro, Minas Gerais — are also the fastest at delivering. This is not a coincidence: high-volume regions attract more sellers and distribution infrastructure, creating a self-reinforcing advantage. States like Amazonas (48 days average) face structural challenges that no operational improvement alone can solve without investment in regional logistics.

**Payment behavior reflects order size.** Customers tend to pay small orders in a single installment, while larger purchases are financed across multiple payments — sometimes up to 24 installments. This suggests that installment financing in Brazil is not just a cultural preference but a functional enabler of higher-value purchases. For a marketplace, offering flexible payment options is directly linked to increasing average order value.

**Growth was real and sustained.** Revenue grew from near zero in late 2016 to over R$970k per month by mid-2018, with no signs of plateau. The November 2017 spike (likely Black Friday) shows the platform was already mature enough to capture seasonal demand. This kind of trend — consistent month-over-month growth with identifiable peaks — is the foundation for reliable forecasting and inventory planning.

---

## SQL Concepts Used

- `JOIN` across multiple tables (2 and 3-table joins)
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `ROUND`
- Window function: `RANK() OVER (...)`
- Date functions: `FORMAT_DATE`, `DATE_DIFF`
- Conditional aggregation: `CASE WHEN`
- Subqueries
- `GROUP BY`, `ORDER BY`, `WHERE` filtering

---

## Files

| File | Description |
|------|-------------|
| `olist_analysis.sql` | All queries with comments |
| `README.md` | Project documentation and findings |

---

## Author

**Romina Velazquez**  
Data Analyst  
[LinkedIn](https://www.linkedin.com/in/romivelazquez21/) · [GitHub](https://github.com/RMVelazquez)
