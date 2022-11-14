-- -------------------------------------------------------- 1ER ENTREGA PARCIAL TRABAJO FINAL --------------------------------------------------------
CREATE SCHEMA `ecommerce` ;
USE `ecommerce`;

-- -------------------------------------------------------- ERD CREATION --------------------------------------------------------

CREATE TABLE `ecommerce`.`clients` (
  `id_client` int NOT NULL,
  `document_number` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ecommerce`.`payment_methods` (
  `id_payment_method` int NOT NULL,
  `id_client_pm` int DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  `number` int DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  PRIMARY KEY (`id_payment_method`),
  KEY `id_payment_method_idx` (`id_payment_method`),
  KEY `id_client` (`id_client_pm`),
  CONSTRAINT `id_client` FOREIGN KEY (`id_client_pm`) REFERENCES `clients` (`id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ecommerce`.`addresses` (
  `id_addresses` int NOT NULL,
  `addresses_id_client` int DEFAULT NULL,
  `street` varchar(45) DEFAULT NULL,
  `zip_code` varchar(45) DEFAULT NULL,
  `state_province` varchar(45) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_addresses`),
  KEY `id_addresses_idx` (`id_addresses`),
  KEY `addresses_id_client` (`addresses_id_client`),
  CONSTRAINT `addresses_id_client` FOREIGN KEY (`addresses_id_client`) REFERENCES `clients` (`id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ecommerce`.`orders` (
  `id_order` int NOT NULL,
  `order_id_client` int DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `total` float DEFAULT NULL,
  PRIMARY KEY (`id_order`),
  KEY `order_id_client_idx` (`order_id_client`),
  CONSTRAINT `order_id_client` FOREIGN KEY (`order_id_client`) REFERENCES `clients` (`id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ecommerce`.`products` (
  `id_product` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `product_family` varchar(45) DEFAULT NULL,
  `price` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `stock` INT DEFAULT NULL,
  PRIMARY KEY (`id_product`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ecommerce`.`order_line_items` (
  `id_order_line_items` int NOT NULL,
  `id_order_ol` int DEFAULT NULL,
  `id_product_ol` int DEFAULT NULL,
  `quantity` INT DEFAULT NULL,
  PRIMARY KEY (`id_order_line_items`),
  KEY `id_order_idx` (`id_order_ol`),
  KEY `id_product_idx` (`id_product_ol`),
  CONSTRAINT `id_order` FOREIGN KEY (`id_order_ol`) REFERENCES `orders` (`id_order`) ON DELETE CASCADE;,
  CONSTRAINT `id_product` FOREIGN KEY (`id_product_ol`) REFERENCES `products` (`id_product`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -------------------------------------------------------- INSERTS --------------------------------------------------------

INSERT INTO `ecommerce`.`clients` (`id_client`, `document_number`, `first_name`, `last_name`, `email`, `password`) VALUES ('1', '38996551', 'Kevin', 'Kosacoff', 'kikosacoff@gmail.com', '123456');

INSERT INTO `ecommerce`.`addresses` (`id_addresses`, `addresses_id_client`, `street`, `zip_code`, `state_province`, `country`) VALUES ('1', '1', 'Lavalleja 278', '1414', 'CABA', 'Argentina');
INSERT INTO `ecommerce`.`addresses` (`id_addresses`, `addresses_id_client`, `street`, `zip_code`, `state_province`, `country`) VALUES ('2', '1', 'Beruti 2465', '1420', 'CABA', 'Argentina');

INSERT INTO `ecommerce`.`payment_methods` (`id_payment_method`, `id_client_pm`, `type`, `number`, `expiration_date`) VALUES ('1', '1', 'Credit Card', '123456789', '2026-12-01');
INSERT INTO `ecommerce`.`payment_methods` (`id_payment_method`, `id_client_pm`, `type`, `number`, `expiration_date`) VALUES ('2', '1', 'Debit Card', '987654321', '2024-06-30');

INSERT INTO `ecommerce`.`orders` (`id_order`, `order_id_client`, `timestamp`, `total`) VALUES ('1', '1', '2022-09-24 08:00:00', '100');
INSERT INTO `ecommerce`.`orders` (`id_order`, `order_id_client`, `timestamp`, `total`) VALUES ('2', '1', '2022-07-14 13:00:00', '300');

INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('1', 'Epiphone AJ-200-SCE', 'Guitar', '50', 'Epiphone AJ-200-SCE', '30');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('2', 'Ludwig LCEE-220', 'Drums', '60', 'Ludwig LCEE-220', '50');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('3', 'Fender Jazz Bass', 'Bass', '40', 'Fender Jazz Bass', '100');

INSERT INTO `ecommerce`.`order_line_items` (`id_order_line_items`, `id_order_ol`, `id_product_ol`, `quantity`) VALUES ('1', '1', '2', '5');
INSERT INTO `ecommerce`.`order_line_items` (`id_order_line_items`, `id_order_ol`, `id_product_ol`, `quantity`) VALUES ('2', '1', '3', '10');

-- -------------------------------------------------------- VIEWS --------------------------------------------------------

-- Orders per client
CREATE OR REPLACE VIEW orders_per_client AS (
	SELECT CONCAT(c.first_name, ' ', c.last_name) full_name, COUNT(1) number_of_orders FROM clients c
	JOIN orders o ON o.order_id_client = c.id_client
GROUP BY(full_name)
);

-- Productos mas vendidos
CREATE OR REPLACE VIEW top_products_sold AS (
SELECT COUNT(1) products_sold, p.name FROM order_line_items ol
JOIN products p ON p.id_product = ol.id_product_ol
GROUP BY(p.name)
ORDER BY COUNT(1) DESC
);

-- Average order amount per client
CREATE OR REPLACE VIEW avg_order_amount_per_client AS (
SELECT CONCAT(c.first_name, ' ', c.last_name) full_name, AVG(o.total) avg_order_amount FROM clients c
JOIN orders o ON o.order_id_client = c.id_client
GROUP BY(full_name)
);

-- Number of clients by country
CREATE OR REPLACE VIEW clients_per_country AS (
SELECT country, COUNT(DISTINCT addresses_id_client) number_of_clients FROM addresses
GROUP BY country
);

-- Sales by date
CREATE OR REPLACE VIEW sales_by_month AS
(SELECT MONTH(timestamp) 'Month', SUM(total) Sales FROM orders o
GROUP BY (timestamp)
ORDER BY(MONTH(timestamp)));

-- -------------------------------------------------------- FUNCTIONS --------------------------------------------------------

USE `ecommerce`;
DROP function IF EXISTS `orders_per_client`;

DELIMITER $$
USE `ecommerce`$$
CREATE FUNCTION `orders_per_client` (p_id_client INT)
RETURNS INTEGER(11) DETERMINISTIC
BEGIN
	DECLARE v_orders INT;
    
    SELECT COUNT(1)
    INTO v_orders
    FROM clients AS c
    JOIN orders o ON o.order_id_client = c.id_client
    WHERE c.id_client = p_id_client;
RETURN v_orders;
END$$

DELIMITER ;


USE `ecommerce`;
DROP function IF EXISTS `revenue_per_client`;

DELIMITER $$
USE `ecommerce`$$
CREATE FUNCTION `revenue_per_client` (p_id_client INT)
RETURNS FLOAT(11) DETERMINISTIC
BEGIN
	DECLARE v_total FLOAT;
    
    SELECT SUM(o.total)
    INTO v_total
    FROM orders AS o
    JOIN clients c ON o.order_id_client = c.id_client
    WHERE c.id_client = p_id_client;
RETURN v_total;
END$$

DELIMITER ;


USE `ecommerce`;
DROP function IF EXISTS `avg_order_size_per_client`;

DELIMITER $$
USE `ecommerce`$$
CREATE FUNCTION `avg_order_size_per_client` (p_id_client INT)
RETURNS FLOAT(11) DETERMINISTIC
BEGIN
	DECLARE v_avg_order_size FLOAT;
    
    SELECT revenue_per_client(c.id_client) / orders_per_client(c.id_client)
    INTO v_avg_order_size
    FROM clients c
    WHERE p_id_client = c.id_client;
    
RETURN v_avg_order_size;
END$$

DELIMITER ;

-- -------------------------------------------------------- STORED PROCEDURES --------------------------------------------------------

-- SP para reducir el stock luego de una compra

USE `ecommerce`;
DROP procedure IF EXISTS `update_stock`;

DELIMITER $$
USE `ecommerce`$$
CREATE PROCEDURE `sp_update_stock` (IN p_ol_item INT)
BEGIN
	DECLARE v_product_id INT;
    DECLARE v_ol_quantity INT;
    DECLARE v_stock INT;

	-- Selecciono el product ID correspondiente al order line item
    SELECT id_product_ol
    INTO v_product_id
    FROM order_line_items
    WHERE id_order_line_items = p_ol_item;
    
    -- Selecciono la cantidad comprada de ese producto
    SELECT quantity
    INTO v_ol_quantity
    FROM order_line_items
    WHERE id_order_line_items = p_ol_item;
    
    -- Selecciono el stock disponible de ese producto
    SELECT stock
    INTO v_stock
    FROM products
    WHERE id_product = v_product_id;

    -- Chequeo que la cantidad a comprar sea mayor que el stock disponible
    IF v_ol_quantity <= v_stock THEN
      UPDATE products
      SET stock = stock - v_ol_quantity
      WHERE id_product = v_product_id;
	  ELSE
		  SELECT 'La cantidad a comprar es mayor que el stock disponible' AS error_msg;
	END IF;
END$$

DELIMITER ;

-- SP para mostrar datos de la tabla producto, permitiendo ordenar por una columna en particluar

USE `ecommerce`;
DROP procedure IF EXISTS `order_table_products`;

DELIMITER $$
USE `ecommerce`$$
CREATE PROCEDURE `sp_order_table_products` (IN p_order_column VARCHAR(100), IN p_order_type VARCHAR(4))
BEGIN

-- Defino la variables a utilizar, concatenando los inputs p_order_type y p_order_column

  SET @ordenar = CONCAT(' ORDER BY ', p_order_column, ' ', p_order_type);
  SET @clausula = CONCAT('SELECT * FROM products', @ordenar);

-- Sentencias utilizadas para ejecutar el script contenido en la variable @clausula
  
  PREPARE mi_clausula FROM @clausula;
  EXECUTE mi_clausula;
  DEALLOCATE PREPARE mi_clausula;
    
END$$

DELIMITER ;

-- -------------------------------------------------------- TRIGGERS --------------------------------------------------------

-- Creo tabla para logs de products
CREATE TABLE `ecommerce`.`log_products` (
  `idlog_products` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `log_p_timestamp` DATETIME NULL,
  `action_type` VARCHAR(45) NULL,
  `detail` VARCHAR(200) NULL,
  `log_product_id` INT NULL,
  `old_price` FLOAT NULL,
  `new_price` FLOAT NULL,
  PRIMARY KEY (`idlog_products`))
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Triggers para tabla producto
DROP TRIGGER IF EXISTS `ecommerce`.`product_after_insert_trigger_logger`;

DELIMITER $$
USE `ecommerce`$$
CREATE TRIGGER `ecommerce`.`product_after_insert_trigger_logger`
AFTER INSERT ON `products`
FOR EACH ROW
BEGIN

  -- Inserto variables del nuevo registro en el log, agregando metadata como la fecha y hora, el usuario y el tipo de accion
	INSERT INTO log_products
    VALUES(NULL,
          NOW(),
          'Insert',
          CONCAT(
              'El usuario ',
              USER(), 
              ' inserto el producto ',
              NEW.id_product,
              ' por un valor de $',
              NEW.price),
          NEW.id_product,
          0,
          NEW.price
            );
END$$
DELIMITER ;

DELIMITER $$

USE `ecommerce`$$

DROP TRIGGER IF EXISTS `ecommerce`.`product_before_update_trigger_logger`;

DELIMITER $$
USE `ecommerce`$$
CREATE TRIGGER `product_before_update_trigger_logger`
BEFORE UPDATE ON `products`
FOR EACH ROW
BEGIN

-- Inserto variables del nuevo registro en el log, agregando metadata como la fecha y hora, el usuario,  el tipo de accion, el precio anterior y el precio actual
	INSERT INTO log_products
    VALUES(NULL,
          NOW(),
          'Update',
          CONCAT(
              'El usuario ',
              USER(), 
              ' modifico el producto ',
              NEW.id_product,
              ' con precio actual de $',
              OLD.price,
              ', por un nuevo valor de $',
            NEW.price),
          NEW.id_product,
          OLD.price,
          NEW.price
            );
END$$
DELIMITER ;

-- ---------------------------------------------

-- Triggers Orders

-- Creo tabla logs de orders

CREATE TABLE `ecommerce`.`log_orders` (
  `id_log_orders` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `log_o_timestamp` DATETIME NULL,
  `action_type` VARCHAR(45) NULL,
  `detail` VARCHAR(200) NULL,
  `log_order_id` INT NULL,
  PRIMARY KEY (`id_log_orders`))
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Trigger after insert orders
DROP TRIGGER IF EXISTS `ecommerce`.`order_after_insert_trigger_logger`;

DELIMITER $$
USE `ecommerce`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ecommerce`.`order_after_insert_trigger_logger`
AFTER INSERT ON `orders`
FOR EACH ROW
BEGIN

-- Inserto variables en el log de ordenes luego del insert
	INSERT INTO log_orders
    VALUES(NULL,
          NOW(),
          'Insert',
          CONCAT(
              'El usuario ',
              USER(), 
              ' inserto la orden ',
              NEW.id_order,
              ' por un valor de $',
              NEW.total),
          NEW.id_order
            );
END$$
DELIMITER ;


-- Trigger before update orders

DROP TRIGGER IF EXISTS `ecommerce`.`orders_before_update_trigger_logger`;

DELIMITER $$
USE `ecommerce`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ecommerce`.`orders_before_update_trigger_logger`
BEFORE UPDATE ON `orders`
FOR EACH ROW
BEGIN
-- Inserto variables en el log de ordenes antes del update
	INSERT INTO log_orders
    VALUES(NULL,
          NOW(),
          'Update',
          CONCAT(
              'El usuario ',
              USER(), 
              ' modifico la orden',
              NEW.id_order),
          NEW.id_order
            );
END$$
DELIMITER ;


-- -------------------------------------------------------- SENTENCIAS DCL --------------------------------------------------------

-- Creo usuarios User1 y User 2, con sus respectivas contraseñas, en el dominio 'localhost'
CREATE USER 'User1'@'localhost' IDENTIFIED BY 'user11234';
CREATE USER 'User2'@'localhost' IDENTIFIED BY 'user21234';

-- Le doy al User1 permiso de solo lectura en todas las tablas de la base de dato ecommerce
GRANT SELECT ON ecommerce.* TO User1@localhost;
SHOW GRANTS FOR User1@localhost;

-- Le doy al User2 permiso de lectura, insercion y modificacion en todas las tablas de la base de dato ecommerce
GRANT SELECT, INSERT, UPDATE ON ecommerce.* TO User2@localhost;
SHOW GRANTS FOR User2@localhost;


-- -------------------------------------------------------- SENTENCIAS TCL --------------------------------------------------------

-- Desactivo el autocommit en MySQL
SET AUTOCOMMIT = 0;

-- Empiezo Transaccion
START TRANSACTION;
-- Empiezo eliminacion de registros
DELETE FROM orders
WHERE id_order = 1;
DELETE FROM orders
WHERE id_order = 2;

-- ROLLBACK;
COMMIT;

START TRANSACTION;
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('4', 'Epiphone AJ-200-SCE', 'Guitar', '50', 'Epiphone AJ-200-SCE', '30');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('5', 'Ludwig LCEE-220', 'Drums', '60', 'Ludwig LCEE-220', '50');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('6', 'Fender Jazz Bass', 'Bass', '40', 'Fender Jazz Bass', '100');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('7', 'Squier 123', 'Guitar', '40', 'Fender Jazz Bass', '100');
SAVEPOINT batch_1;
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('8', 'Epiphone AJ-200-SCE', 'Drums', '50', 'Epiphone AJ-200-SCE', '30');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('9', 'Ludwig LCEE-220', 'Bass', '60', 'Ludwig LCEE-220', '50');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('10', 'Fender Jazz Bass', 'Guitar', '40', 'Fender Jazz Bass', '100');
INSERT INTO `ecommerce`.`products` (`id_product`, `name`, `product_family`, `price`, `description`, `stock`) VALUES ('11', 'Fender Jazz Bass', 'Drums', '40', 'Fender Jazz Bass', '100');
SAVEPOINT batch_2;

RELEASE SAVEPOINT batch_1;