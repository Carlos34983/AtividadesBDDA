CREATE OR REPLACE VIEW products_best_sellers AS
SELECT
    p.id,
    p.name,
    SUM(oi.quantity) AS quantity
FROM `products` p
JOIN `order_items` oi ON p.id = oi.product_id
JOIN `orders` o ON o.id = oi.order_id
WHERE o.status = 'paid'
  AND o.paid_at >= NOW() - INTERVAL 1 DAY
GROUP BY p.id, p.name
HAVING SUM(oi.quantity) > 25;