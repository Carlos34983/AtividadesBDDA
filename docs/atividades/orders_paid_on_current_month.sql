CREATE OR REPLACE VIEW orders_paid_on_current_month AS
SELECT
    id,
    paid_at,
    total
FROM `orders`
WHERE status = 'paid'
  AND MONTH(paid_at) = MONTH(CURRENT_DATE())
  AND YEAR(paid_at) = YEAR(CURRENT_DATE());