DELIMITER $$

CREATE FUNCTION customer_total_spent(
    customer_id_param BIGINT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_spent DECIMAL(10,2);

    SELECT COALESCE(SUM(total), 0.00)
    INTO total_spent
    FROM orders
    WHERE customer_id = customer_id_param
      AND paid_at IS NOT NULL;

    RETURN total_spent;
END$$

DELIMITER ;

SELECT
    id,
    name,
    customer_total_spent(id) AS total_spent
FROM customers;