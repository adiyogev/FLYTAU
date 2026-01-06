SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `FLYTAU`;
CREATE SCHEMA IF NOT EXISTS `FLYTAU` DEFAULT CHARACTER SET utf8;
USE `FLYTAU`;

CREATE TABLE `Customer` (
  `customer_email` VARCHAR(45) PRIMARY KEY,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `passport` VARCHAR(45) NOT NULL,
  `birth_date` DATE NOT NULL,
  `reg_date` DATE NOT NULL,
  `password` VARCHAR(45) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `Customer_Phone_Numbers` (
  `phone_customer_email` VARCHAR(45) NOT NULL,
  `phone_num` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`phone_customer_email`, `phone_num`),
  CONSTRAINT `fk_phone_customer` FOREIGN KEY (`phone_customer_email`) REFERENCES `Customer` (`customer_email`) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `Guest` (
  `guest_email` VARCHAR(45) PRIMARY KEY
) ENGINE = InnoDB;

CREATE TABLE `Route` (
  `origin_airport` VARCHAR(45) NOT NULL,
  `destination_airport` VARCHAR(45) NOT NULL,
  `duration` TIME NOT NULL,
  `is_long` TINYINT(1) GENERATED ALWAYS AS (duration > '06:00:00') STORED,
  PRIMARY KEY (`origin_airport`, `destination_airport`)
) ENGINE = InnoDB;

CREATE TABLE `Plane` (
  `plane_id` VARCHAR(45) PRIMARY KEY,
  `size` ENUM('small', 'large') NOT NULL,
  `purchase_date` DATE NULL,
  `manufacturer` ENUM('Boeing', 'Airbus', 'Dassault') NULL
) ENGINE = InnoDB;

CREATE TABLE `Flight` (
  `flight_id` VARCHAR(45) PRIMARY KEY,
  `status` ENUM('active', 'full', 'completed', 'cancelled') DEFAULT 'active',
  `origin_airport` VARCHAR(45) NOT NULL,
  `destination_airport` VARCHAR(45) NOT NULL,
  `departure` DATETIME NOT NULL,
  `arrival` DATETIME NULL,
  `plane_id` VARCHAR(45) NOT NULL,
  `economy_seat_price` INT NOT NULL,
  `business_seat_price` INT NULL, -- NULL במטוס קטן
  CONSTRAINT `fk_flight_plane` FOREIGN KEY (`plane_id`) REFERENCES `Plane` (`plane_id`),
  CONSTRAINT `fk_flight_route` FOREIGN KEY (`origin_airport`, `destination_airport`) REFERENCES `Route` (`origin_airport`, `destination_airport`)
) ENGINE = InnoDB;

CREATE TABLE `Class` (
  `plane_id` VARCHAR(45) NOT NULL,
  `seat_row` INT NOT NULL,
  `seat_position` VARCHAR(1) NOT NULL,
  `class_type` ENUM('economy', 'business') NOT NULL,
  PRIMARY KEY (`plane_id`, `seat_row`, `seat_position`),
  CONSTRAINT `fk_class_plane` FOREIGN KEY (`plane_id`) REFERENCES `Plane` (`plane_id`)
) ENGINE = InnoDB;

CREATE TABLE `Orders` (
  `code` VARCHAR(45) PRIMARY KEY,
  `status` ENUM('active', 'completed', 'cancelled by user', 'cancelled by system') DEFAULT 'active',
  `total_price` INT DEFAULT 0,
  `order_date` DATETIME NOT NULL,
  `flight_id` VARCHAR(45) NOT NULL,
  `customer_email` VARCHAR(45) NULL,
  `guest_email` VARCHAR(45) NULL,
  CONSTRAINT `fk_order_flight` FOREIGN KEY (`flight_id`) REFERENCES `Flight` (`flight_id`),
  CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_email`) REFERENCES `Customer` (`customer_email`),
  CONSTRAINT `fk_order_guest` FOREIGN KEY (`guest_email`) REFERENCES `Guest` (`guest_email`)
) ENGINE = InnoDB;

CREATE TABLE `Seats_in_Order` (
  `code` VARCHAR(45) NOT NULL,
  `seats_plane_id` VARCHAR(45) NOT NULL,
  `seat_row` INT NOT NULL,
  `seat_position` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`code`, `seats_plane_id`, `seat_row`, `seat_position`),
  CONSTRAINT `fk_seats_class` FOREIGN KEY (`seats_plane_id`, `seat_row`, `seat_position`) REFERENCES `Class` (`plane_id`, `seat_row`, `seat_position`),
  CONSTRAINT `fk_seats_order` FOREIGN KEY (`code`) REFERENCES `Orders` (`code`)
) ENGINE = InnoDB;

CREATE TABLE `Pilot` (
  `pilot_id` VARCHAR(9) PRIMARY KEY,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone_num` VARCHAR(10) NOT NULL,
  `start_date` DATE NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `st_num` INT NOT NULL,
  `long_flight_qualified` TINYINT(1) DEFAULT 0
) ENGINE = InnoDB;

CREATE TABLE `Flight_Attendant` (
  `fa_id` VARCHAR(9) PRIMARY KEY,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone_num` VARCHAR(10) NOT NULL,
  `start_date` DATE NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `st_num` INT NOT NULL,
  `long_flight_qualified` TINYINT(1) DEFAULT 0
) ENGINE = InnoDB;

CREATE TABLE `Manager` (
  `manager_id` VARCHAR(9) PRIMARY KEY,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone_num` VARCHAR(10) NOT NULL,
  `start_date` DATE NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `st_num` INT NOT NULL,
  `password` VARCHAR(45) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `Pilots_on_Flight` (
  `flight_id` VARCHAR(45) NOT NULL,
  `pilot_id` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`flight_id`, `pilot_id`),
  FOREIGN KEY (`flight_id`) REFERENCES `Flight` (`flight_id`),
  FOREIGN KEY (`pilot_id`) REFERENCES `Pilot` (`pilot_id`)
) ENGINE = InnoDB;

CREATE TABLE `FA_on_Flight` (
  `flight_id` VARCHAR(45) NOT NULL,
  `fa_id` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`flight_id`, `fa_id`),
  FOREIGN KEY (`flight_id`) REFERENCES `Flight` (`flight_id`),
  FOREIGN KEY (`fa_id`) REFERENCES `Flight_Attendant` (`fa_id`)
) ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;