-- ביטול בדיקות זמני כדי לאפשר יצירה חלקה של טבלאות עם מפתחות זרים
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- יצירת הסכימה (Schema)
DROP SCHEMA IF EXISTS `FLYTAU`;
CREATE SCHEMA IF NOT EXISTS `FLYTAU` DEFAULT CHARACTER SET utf8mb4;
USE `FLYTAU`;

-- ==========================================================
-- 1. יצירת טבלאות עצמאיות (Parent Tables)
-- ==========================================================

CREATE TABLE `customer` (
  `customer_email` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `passport` varchar(45) NOT NULL,
  `birth_date` date NOT NULL,
  `reg_date` date NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`customer_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `guest` (
  `guest_email` varchar(45) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`guest_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `manager` (
  `manager_id` varchar(9) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `st_num` int NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`manager_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pilot` (
  `pilot_id` varchar(9) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `st_num` int NOT NULL,
  `long_flight_qualified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`pilot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `flight_attendant` (
  `fa_id` varchar(9) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `st_num` int NOT NULL,
  `long_flight_qualified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`fa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `plane` (
  `plane_id` varchar(45) NOT NULL,
  `size` enum('small','large') NOT NULL,
  `purchase_date` date DEFAULT NULL,
  `manufacturer` enum('Boeing','Airbus','Dassault') DEFAULT NULL,
  PRIMARY KEY (`plane_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `route` (
  `origin_airport` varchar(45) NOT NULL,
  `destination_airport` varchar(45) NOT NULL,
  `duration` time NOT NULL,
  `is_long` tinyint(1) GENERATED ALWAYS AS ((`duration` > '06:00:00')) STORED,
  PRIMARY KEY (`origin_airport`,`destination_airport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================================
-- 2. יצירת טבלאות תלויות (Dependent Tables)
-- ==========================================================

CREATE TABLE `customer_phone_numbers` (
  `phone_customer_email` varchar(45) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  PRIMARY KEY (`phone_customer_email`,`phone_num`),
  CONSTRAINT `fk_phone_customer` FOREIGN KEY (`phone_customer_email`) REFERENCES `customer` (`customer_email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `guest_phone_numbers` (
  `phone_guest_email` varchar(255) NOT NULL,
  `phone_num` varchar(15) NOT NULL,
  PRIMARY KEY (`phone_guest_email`,`phone_num`),
  CONSTRAINT `guest_phone_numbers_ibfk_1` FOREIGN KEY (`phone_guest_email`) REFERENCES `guest` (`guest_email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `class` (
  `plane_id` varchar(45) NOT NULL,
  `seat_row` int NOT NULL,
  `seat_position` varchar(1) NOT NULL,
  `class_type` enum('economy','business') NOT NULL,
  PRIMARY KEY (`plane_id`,`seat_row`,`seat_position`),
  CONSTRAINT `fk_class_plane` FOREIGN KEY (`plane_id`) REFERENCES `plane` (`plane_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `flight` (
  `flight_id` varchar(45) NOT NULL,
  `status` enum('active','full','completed','cancelled') DEFAULT 'active',
  `origin_airport` varchar(45) NOT NULL,
  `destination_airport` varchar(45) NOT NULL,
  `departure` datetime NOT NULL,
  `arrival` datetime NOT NULL,
  `plane_id` varchar(45) NOT NULL,
  `economy_seat_price` int NOT NULL,
  `business_seat_price` int DEFAULT NULL,
  PRIMARY KEY (`flight_id`),
  CONSTRAINT `fk_flight_plane` FOREIGN KEY (`plane_id`) REFERENCES `plane` (`plane_id`),
  CONSTRAINT `fk_flight_route` FOREIGN KEY (`origin_airport`, `destination_airport`) REFERENCES `route` (`origin_airport`, `destination_airport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `orders` (
  `code` varchar(45) NOT NULL,
  `status` enum('active','completed','cancelled by user','cancelled by system') DEFAULT 'active',
  `total_price` int DEFAULT NULL,
  `order_date` datetime NOT NULL,
  `flight_id` varchar(45) NOT NULL,
  `customer_email` varchar(45) DEFAULT NULL,
  `guest_email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`code`),
  CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_email`) REFERENCES `customer` (`customer_email`) ON DELETE SET NULL,
  CONSTRAINT `fk_order_flight` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `fk_order_guest` FOREIGN KEY (`guest_email`) REFERENCES `guest` (`guest_email`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `seats_in_order` (
  `code` varchar(45) NOT NULL,
  `seats_plane_id` varchar(45) NOT NULL,
  `seat_row` int NOT NULL,
  `seat_position` varchar(1) NOT NULL,
  PRIMARY KEY (`code`,`seats_plane_id`,`seat_row`,`seat_position`),
  CONSTRAINT `fk_seats_class` FOREIGN KEY (`seats_plane_id`, `seat_row`, `seat_position`) REFERENCES `class` (`plane_id`, `seat_row`, `seat_position`),
  CONSTRAINT `fk_seats_order` FOREIGN KEY (`code`) REFERENCES `orders` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pilots_on_flight` (
  `flight_id` varchar(45) NOT NULL,
  `pilot_id` varchar(9) NOT NULL,
  PRIMARY KEY (`flight_id`,`pilot_id`),
  CONSTRAINT `pilots_on_flight_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `pilots_on_flight_ibfk_2` FOREIGN KEY (`pilot_id`) REFERENCES `pilot` (`pilot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `flight_attendants_on_flight` (
  `flight_id` varchar(45) NOT NULL,
  `fa_id` varchar(9) NOT NULL,
  PRIMARY KEY (`flight_id`,`fa_id`),
  CONSTRAINT `flight_attendants_on_flight_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `flight_attendants_on_flight_ibfk_2` FOREIGN KEY (`fa_id`) REFERENCES `flight_attendant` (`fa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `flight_created_by` (
  `flight_id` varchar(45) NOT NULL,
  `manager_id` varchar(9) NOT NULL,
  PRIMARY KEY (`flight_id`,`manager_id`),
  CONSTRAINT `fk_fcb_flight` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `fk_fcb_manager` FOREIGN KEY (`manager_id`) REFERENCES `manager` (`manager_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;