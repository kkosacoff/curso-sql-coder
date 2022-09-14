CREATE SCHEMA `ecommerce` ;

CREATE TABLE `ecommerce`.`Clients` (
  `idClient` INT NOT NULL,
  `First Name` VARCHAR(45) NULL,
  `Last Name` VARCHAR(45) NULL,
  PRIMARY KEY (`idClient`));


CREATE TABLE `ecommerce`.`Payment Methods` (
  `idPaymentMethod` INT NOT NULL,
  `idClient_pm` INT NULL,
  `Type` VARCHAR(45) NULL,
  `Number` INT NULL,
  `Expiration Date` DATETIME NULL,
  PRIMARY KEY (`idPaymentMethod`),
  INDEX `idPaymentMethod_idx` (`idPaymentMethod` ASC) VISIBLE,
  CONSTRAINT `idClient`
    FOREIGN KEY (`idClient_pm`)
    REFERENCES `ecommerce`.`Clients` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `ecommerce`.`Addresses` (
  `idAddresses` INT NOT NULL,
  `Addresses_idClient` INT NULL,
  `Street` VARCHAR(45) NULL,
  `ZIP Code` VARCHAR(45) NULL,
  `State/Province` VARCHAR(45) NULL,
  `Country` VARCHAR(45) NULL,
  PRIMARY KEY (`idAddresses`),
  INDEX `idAddresses_idx` (`idAddresses` ASC) VISIBLE,
  CONSTRAINT `Addresses_idClient`
    FOREIGN KEY (`Addresses_idClient`)
    REFERENCES `ecommerce`.`Clients` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `ecommerce`.`Orders` (
  `idOrder` INT NOT NULL,
  `order_idClient` INT NULL,
  `Timestamp` DATETIME NULL,
  `Total` FLOAT NULL,
  PRIMARY KEY (`idOrder`),
  INDEX `order_idClient_idx` (`order_idClient` ASC) VISIBLE,
  CONSTRAINT `order_idClient`
    FOREIGN KEY (`order_idClient`)
    REFERENCES `ecommerce`.`Clients` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `ecommerce`.`Products` (
  `idProducts` INT NOT NULL,
  `ProductFamily` VARCHAR(45) NULL,
  `Price` VARCHAR(45) NULL,
  `Description` VARCHAR(45) NULL,
  PRIMARY KEY (`idProducts`));

  CREATE TABLE `ecommerce`.`Order Line Items` (
  `idOrder Line Items` INT NOT NULL,
  `idOrder_ol` INT NULL,
  `idProduct_ol` INT NULL,
  PRIMARY KEY (`idOrder Line Items`),
  INDEX `idOrder_idx` (`idOrder_ol` ASC) VISIBLE,
  INDEX `idProduct_idx` (`idProduct_ol` ASC) VISIBLE,
  CONSTRAINT `idOrder`
    FOREIGN KEY (`idOrder_ol`)
    REFERENCES `ecommerce`.`Orders` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idProduct`
    FOREIGN KEY (`idProduct_ol`)
    REFERENCES `ecommerce`.`Products` (`idProducts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

