DELIMITER $$

CREATE FUNCTION order_items_quantity(
    order_id_param BIGINT
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE total_quantity BIGINT;

    SELECT COALESCE(SUM(quantity), 0)
    INTO total_quantity
    FROM order_items
    WHERE order_id = order_id_param;

    RETURN total_quantity;
END$$

DELIMITER ;

SELECT
    id,
    total,
    order_items_quantity(id) AS items_quantity
FROM orders;