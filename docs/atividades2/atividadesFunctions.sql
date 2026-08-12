-- 1. Calcular o valor de um item do pedido

DROP FUNCTION IF EXISTS calculate_item_total;

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

-- 2. Classificar um cliente pelo total de compras

DROP FUNCTION IF EXISTS customer_level;

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

-- 3. Calcular o desconto de um pedido

DROP FUNCTION IF EXISTS calculate_order_discount;

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

-- 4. Calcular a quantidade de itens de um pedido

DROP FUNCTION IF EXISTS order_items_quantity;

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

-- 5. Calcular o total gasto por um cliente

DROP FUNCTION IF EXISTS customer_total_spent;

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
