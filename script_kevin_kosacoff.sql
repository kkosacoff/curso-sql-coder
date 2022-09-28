-- ENTREGA PARCIAL TRABAJO FINAL
CREATE SCHEMA `ecommerce` ;
USE `ecommerce`;

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
  `id_products` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `product_family` varchar(45) DEFAULT NULL,
  `price` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_products`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ecommerce`.`order_line_items` (
  `id_order_line_items` int NOT NULL,
  `id_order_ol` int DEFAULT NULL,
  `id_product_ol` int DEFAULT NULL,
  `quantity` INT DEFAULT NULL,
  PRIMARY KEY (`id_order_line_items`),
  KEY `id_order_idx` (`id_order_ol`),
  KEY `id_product_idx` (`id_product_ol`),
  CONSTRAINT `id_order` FOREIGN KEY (`id_order_ol`) REFERENCES `orders` (`id_order`),
  CONSTRAINT `id_product` FOREIGN KEY (`id_product_ol`) REFERENCES `products` (`id_products`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ENTREGA INSERT CON IMPORTACION
INSERT INTO `ecommerce`.`clients` (`id_client`, `document_number`, `first_name`, `last_name`, `email`, `password`) VALUES ('1', '38996551', 'Kevin', 'Kosacoff', 'kikosacoff@gmail.com', '123456');

INSERT INTO `ecommerce`.`addresses` (`id_addresses`, `addresses_id_client`, `street`, `zip_code`, `state_province`, `country`) VALUES ('1', '1', 'Lavalleja 278', '1414', 'CABA', 'Argentina');
INSERT INTO `ecommerce`.`addresses` (`id_addresses`, `addresses_id_client`, `street`, `zip_code`, `state_province`, `country`) VALUES ('2', '1', 'Beruti 2465', '1420', 'CABA', 'Argentina');

INSERT INTO `ecommerce`.`payment_methods` (`id_payment_method`, `id_client_pm`, `type`, `number`, `expiration_date`) VALUES ('1', '1', 'Credit Card', '123456789', '2026-12-01');
INSERT INTO `ecommerce`.`payment_methods` (`id_payment_method`, `id_client_pm`, `type`, `number`, `expiration_date`) VALUES ('2', '1', 'Debit Card', '987654321', '2024-06-30');

INSERT INTO `ecommerce`.`orders` (`id_order`, `order_id_client`, `timestamp`, `total`) VALUES ('1', '1', '2022-09-24 08:00:00', '100');
INSERT INTO `ecommerce`.`orders` (`id_order`, `order_id_client`, `timestamp`, `total`) VALUES ('2', '1', '2022-07-14 13:00:00', '300');

INSERT INTO `ecommerce`.`products` (`id_products`, `name`, `product_family`, `price`, `description`) VALUES ('1', 'Epiphone AJ-200-SCE', 'Guitar', '50', 'Epiphone AJ-200-SCE');
INSERT INTO `ecommerce`.`products` (`id_products`, `name`, `product_family`, `price`, `description`) VALUES ('2', 'Ludwig LCEE-220', 'Drums', '60', 'Ludwig LCEE-220');
INSERT INTO `ecommerce`.`products` (`id_products`, `name`, `product_family`, `price`, `description`) VALUES ('3', 'Fender Jazz Bass', 'Bass', '40', 'Fender Jazz Bass');

INSERT INTO `ecommerce`.`order_line_items` (`id_order_line_items`, `id_order_ol`, `id_product_ol`, `quantity`) VALUES ('1', '1', '2', '1');
INSERT INTO `ecommerce`.`order_line_items` (`id_order_line_items`, `id_order_ol`, `id_product_ol`, `quantity`) VALUES ('2', '1', '3', '1');



-- Orders per client
CREATE OR REPLACE VIEW orders_per_client AS (
	SELECT CONCAT(c.first_name, ' ', c.last_name) full_name, COUNT(1) number_of_orders FROM clients c
	JOIN orders o ON o.order_id_client = c.id_client
GROUP BY(id_client)
);

-- Productos mas vendidos
CREATE OR REPLACE VIEW top_products_sold AS (
SELECT COUNT(1) products_sold, p.name FROM order_line_items ol
JOIN products p ON p.id_products = ol.id_product_ol
GROUP BY(p.name)
ORDER BY COUNT(1) DESC
);

-- Average order amount per client
CREATE OR REPLACE VIEW avg_order_amount_per_client AS (
SELECT CONCAT(c.first_name, ' ', c.last_name) full_name, AVG(o.total) avg_order_amount FROM clients c
JOIN orders o ON o.order_id_client = c.id_client
GROUP BY(id_client)
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
ORDER BY(timestamp));