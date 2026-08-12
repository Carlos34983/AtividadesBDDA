DELIMITER $$

CREATE FUNCTION calculate_order_discount(
    order_value DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    IF order_value < 200 THEN
        RETURN 0.00;
    ELSEIF order_value < 500 THEN
        RETURN order_value * 0.05;
    ELSEIF order_value < 1000 THEN
        RETURN order_value * 0.10;
    ELSE
        RETURN order_value * 0.15;
    END IF;
END$$

DELIMITER ;

SELECT
    id,
    total AS order_value,
    calculate_order_discount(total) AS discount
FROM orders
WHERE paid_at IS NOT NULL;