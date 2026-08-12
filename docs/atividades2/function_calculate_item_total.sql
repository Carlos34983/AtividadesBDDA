DELIMITER $$

CREATE FUNCTION calculate_item_total(
    product_price DECIMAL(10,2),
    quantity BIGINT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN product_price * quantity;
END$$

DELIMITER ;

SELECT
    id,
    product_name,
    product_price,
    quantity,
    calculate_item_total(product_price, quantity) AS item_total
FROM order_items;