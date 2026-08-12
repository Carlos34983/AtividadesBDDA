DELIMITER $$

CREATE FUNCTION customer_level(
    total_spent DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF total_spent < 500 THEN
        RETURN 'Bronze';
    ELSEIF total_spent <= 2000 THEN
        RETURN 'Prata';
    ELSE
        RETURN 'Ouro';
    END IF;
END$$

DELIMITER ;

SELECT
    c.id,
    c.name,
    COALESCE(SUM(o.total), 0.00) AS total_spent,
    customer_level(COALESCE(SUM(o.total), 0.00)) AS classification
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.id
    AND o.paid_at IS NOT NULL
GROUP BY c.id, c.name;