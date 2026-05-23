-- ============================================================
-- SQL E-Commerce Analysis
-- Dataset: Brazilian E-Commerce Public Dataset by Olist
-- Author: Romi Velazquez
-- ============================================================


-- ------------------------------------------------------------
-- 1. ORDERS OVERVIEW
-- Distribution of orders by status
-- ------------------------------------------------------------

SELECT
  order_status,
  COUNT(*) AS total_orders
FROM `sql-e-commerce-analysis.ecommerce_olist.orders`
GROUP BY order_status
ORDER BY total_orders DESC;


-- ------------------------------------------------------------
-- 2. MONTHLY REVENUE TREND
-- Total orders and revenue per month (delivered orders only)
-- ------------------------------------------------------------

SELECT
  FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp)) AS month,
  COUNT(*) AS total_orders,
  ROUND(SUM(oi.price), 2) AS total_revenue
FROM `sql-e-commerce-analysis.ecommerce_olist.orders` o
JOIN `sql-e-commerce-analysis.ecommerce_olist.order_items` oi
  ON o.order_id = oi.order_id
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- 3. TOP 10 SELLERS BY REVENUE
-- Ranking sellers using window function RANK()
-- ------------------------------------------------------------

SELECT
  s.seller_id,
  s.seller_city,
  s.seller_state,
  COUNT(DISTINCT oi.order_id) AS total_orders,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank
FROM `sql-e-commerce-analysis.ecommerce_olist.sellers` s
JOIN `sql-e-commerce-analysis.ecommerce_olist.order_items` oi
  ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY revenue_rank
LIMIT 10;


-- ------------------------------------------------------------
-- 4. AVERAGE DELIVERY TIME BY SELLER STATE
-- Measures logistics performance across Brazilian states
-- ------------------------------------------------------------

SELECT
  s.seller_state,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(AVG(DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_purchase_timestamp), DAY)), 1) AS avg_delivery_days
FROM `sql-e-commerce-analysis.ecommerce_olist.orders` o
JOIN `sql-e-commerce-analysis.ecommerce_olist.order_items` oi
  ON o.order_id = oi.order_id
JOIN `sql-e-commerce-analysis.ecommerce_olist.sellers` s
  ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_state
ORDER BY avg_delivery_days ASC;


-- ------------------------------------------------------------
-- 5. CUSTOMER RETENTION ANALYSIS
-- Note: Olist assigns a unique customer_id per order (anonymized data)
-- Result shows 0 returning customers due to this dataset limitation
-- ------------------------------------------------------------

SELECT
  SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS returning_customers,
  SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) AS one_time_customers,
  COUNT(*) AS total_customers,
  ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS retention_rate_pct
FROM (
  SELECT
    customer_id,
    COUNT(*) AS total_orders
  FROM `sql-e-commerce-analysis.ecommerce_olist.orders`
  WHERE order_status = 'delivered'
  GROUP BY customer_id
);


-- ------------------------------------------------------------
-- 6. PAYMENT METHODS DISTRIBUTION
-- Revenue and transaction count by payment type
-- ------------------------------------------------------------

SELECT
  payment_type,
  COUNT(*) AS total_transactions,
  ROUND(SUM(payment_value), 2) AS total_revenue,
  ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM `sql-e-commerce-analysis.ecommerce_olist.order_payments`
GROUP BY payment_type
ORDER BY total_transactions DESC;


-- ------------------------------------------------------------
-- 7. CREDIT CARD INSTALLMENTS ANALYSIS
-- Relationship between number of installments and order value
-- ------------------------------------------------------------

SELECT
  payment_installments,
  COUNT(*) AS total_orders,
  ROUND(AVG(payment_value), 2) AS avg_order_value
FROM `sql-e-commerce-analysis.ecommerce_olist.order_payments`
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments ASC;
