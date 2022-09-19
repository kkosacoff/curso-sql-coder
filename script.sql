CREATE SCHEMA `ecommerce` ;

CREATE TABLE `ecommerce`.`Clients` (
  `idClient` int NOT NULL,
  `First Name` varchar(45) DEFAULT NULL,
  `Last Name` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ecommerce`.`Payment Methods` (
  `idPaymentMethod` int NOT NULL,
  `idClient_pm` int DEFAULT NULL,
  `Type` varchar(45) DEFAULT NULL,
  `Number` int DEFAULT NULL,
  `Expiration Date` datetime DEFAULT NULL,
  PRIMARY KEY (`idPaymentMethod`),
  KEY `idPaymentMethod_idx` (`idPaymentMethod`),
  KEY `idClient` (`idClient_pm`),
  CONSTRAINT `idClient` FOREIGN KEY (`idClient_pm`) REFERENCES `Clients` (`idClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ecommerce`.`Addresses` (
  `idAddresses` int NOT NULL,
  `Addresses_idClient` int DEFAULT NULL,
  `Street` varchar(45) DEFAULT NULL,
  `ZIP Code` varchar(45) DEFAULT NULL,
  `State/Province` varchar(45) DEFAULT NULL,
  `Country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idAddresses`),
  KEY `idAddresses_idx` (`idAddresses`),
  KEY `Addresses_idClient` (`Addresses_idClient`),
  CONSTRAINT `Addresses_idClient` FOREIGN KEY (`Addresses_idClient`) REFERENCES `Clients` (`idClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ecommerce`.`Orders` (
  `idOrder` int NOT NULL,
  `order_idClient` int DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `Total` float DEFAULT NULL,
  PRIMARY KEY (`idOrder`),
  KEY `order_idClient_idx` (`order_idClient`),
  CONSTRAINT `order_idClient` FOREIGN KEY (`order_idClient`) REFERENCES `Clients` (`idClient`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `ecommerce`.`Products` (
  `idProducts` int NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `ProductFamily` varchar(45) DEFAULT NULL,
  `Price` varchar(45) DEFAULT NULL,
  `Description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idProducts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ecommerce`.`Order Line Items` (
  `idOrder Line Items` int NOT NULL,
  `idOrder_ol` int DEFAULT NULL,
  `idProduct_ol` int DEFAULT NULL,
  PRIMARY KEY (`idOrder Line Items`),
  KEY `idOrder_idx` (`idOrder_ol`),
  KEY `idProduct_idx` (`idProduct_ol`),
  CONSTRAINT `idOrder` FOREIGN KEY (`idOrder_ol`) REFERENCES `Orders` (`idOrder`),
  CONSTRAINT `idProduct` FOREIGN KEY (`idProduct_ol`) REFERENCES `Products` (`idProducts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
