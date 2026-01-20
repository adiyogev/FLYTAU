CREATE DATABASE  IF NOT EXISTS `flytau` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `flytau`;
-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: flytau
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `plane_id` varchar(45) NOT NULL,
  `seat_row` int NOT NULL,
  `seat_position` varchar(1) NOT NULL,
  `class_type` enum('economy','business') NOT NULL,
  PRIMARY KEY (`plane_id`,`seat_row`,`seat_position`),
  CONSTRAINT `fk_class_plane` FOREIGN KEY (`plane_id`) REFERENCES `plane` (`plane_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES ('P-LG1',1,'A','business'),('P-LG1',1,'B','business'),('P-LG1',1,'C','business'),('P-LG1',1,'D','business'),('P-LG1',2,'A','business'),('P-LG1',2,'B','business'),('P-LG1',2,'C','business'),('P-LG1',2,'D','business'),('P-LG1',3,'A','business'),('P-LG1',3,'B','business'),('P-LG1',3,'C','business'),('P-LG1',3,'D','business'),('P-LG1',4,'A','economy'),('P-LG1',4,'B','economy'),('P-LG1',4,'C','economy'),('P-LG1',4,'D','economy'),('P-LG1',4,'E','economy'),('P-LG1',4,'F','economy'),('P-LG1',5,'A','economy'),('P-LG1',5,'B','economy'),('P-LG1',5,'C','economy'),('P-LG1',5,'D','economy'),('P-LG1',5,'E','economy'),('P-LG1',5,'F','economy'),('P-LG1',6,'A','economy'),('P-LG1',6,'B','economy'),('P-LG1',6,'C','economy'),('P-LG1',6,'D','economy'),('P-LG1',6,'E','economy'),('P-LG1',6,'F','economy'),('P-LG1',7,'A','economy'),('P-LG1',7,'B','economy'),('P-LG1',7,'C','economy'),('P-LG1',7,'D','economy'),('P-LG1',7,'E','economy'),('P-LG1',7,'F','economy'),('P-LG1',8,'A','economy'),('P-LG1',8,'B','economy'),('P-LG1',8,'C','economy'),('P-LG1',8,'D','economy'),('P-LG1',8,'E','economy'),('P-LG1',8,'F','economy'),('P-LG1',9,'A','economy'),('P-LG1',9,'B','economy'),('P-LG1',9,'C','economy'),('P-LG1',9,'D','economy'),('P-LG1',9,'E','economy'),('P-LG1',9,'F','economy'),('P-LG1',10,'A','economy'),('P-LG1',10,'B','economy'),('P-LG1',10,'C','economy'),('P-LG1',10,'D','economy'),('P-LG1',10,'E','economy'),('P-LG1',10,'F','economy'),('P-LG2',1,'A','business'),('P-LG2',1,'B','business'),('P-LG2',1,'C','business'),('P-LG2',1,'D','business'),('P-LG2',2,'A','business'),('P-LG2',2,'B','business'),('P-LG2',2,'C','business'),('P-LG2',2,'D','business'),('P-LG2',3,'A','business'),('P-LG2',3,'B','business'),('P-LG2',3,'C','business'),('P-LG2',3,'D','business'),('P-LG2',4,'A','economy'),('P-LG2',4,'B','economy'),('P-LG2',4,'C','economy'),('P-LG2',4,'D','economy'),('P-LG2',4,'E','economy'),('P-LG2',4,'F','economy'),('P-LG2',5,'A','economy'),('P-LG2',5,'B','economy'),('P-LG2',5,'C','economy'),('P-LG2',5,'D','economy'),('P-LG2',5,'E','economy'),('P-LG2',5,'F','economy'),('P-LG2',6,'A','economy'),('P-LG2',6,'B','economy'),('P-LG2',6,'C','economy'),('P-LG2',6,'D','economy'),('P-LG2',6,'E','economy'),('P-LG2',6,'F','economy'),('P-LG2',7,'A','economy'),('P-LG2',7,'B','economy'),('P-LG2',7,'C','economy'),('P-LG2',7,'D','economy'),('P-LG2',7,'E','economy'),('P-LG2',7,'F','economy'),('P-LG2',8,'A','economy'),('P-LG2',8,'B','economy'),('P-LG2',8,'C','economy'),('P-LG2',8,'D','economy'),('P-LG2',8,'E','economy'),('P-LG2',8,'F','economy'),('P-LG2',9,'A','economy'),('P-LG2',9,'B','economy'),('P-LG2',9,'C','economy'),('P-LG2',9,'D','economy'),('P-LG2',9,'E','economy'),('P-LG2',9,'F','economy'),('P-LG2',10,'A','economy'),('P-LG2',10,'B','economy'),('P-LG2',10,'C','economy'),('P-LG2',10,'D','economy'),('P-LG2',10,'E','economy'),('P-LG2',10,'F','economy'),('P-LG3',1,'A','business'),('P-LG3',1,'B','business'),('P-LG3',1,'C','business'),('P-LG3',1,'D','business'),('P-LG3',2,'A','business'),('P-LG3',2,'B','business'),('P-LG3',2,'C','business'),('P-LG3',2,'D','business'),('P-LG3',3,'A','business'),('P-LG3',3,'B','business'),('P-LG3',3,'C','business'),('P-LG3',3,'D','business'),('P-LG3',4,'A','economy'),('P-LG3',4,'B','economy'),('P-LG3',4,'C','economy'),('P-LG3',4,'D','economy'),('P-LG3',4,'E','economy'),('P-LG3',4,'F','economy'),('P-LG3',5,'A','economy'),('P-LG3',5,'B','economy'),('P-LG3',5,'C','economy'),('P-LG3',5,'D','economy'),('P-LG3',5,'E','economy'),('P-LG3',5,'F','economy'),('P-LG3',6,'A','economy'),('P-LG3',6,'B','economy'),('P-LG3',6,'C','economy'),('P-LG3',6,'D','economy'),('P-LG3',6,'E','economy'),('P-LG3',6,'F','economy'),('P-LG3',7,'A','economy'),('P-LG3',7,'B','economy'),('P-LG3',7,'C','economy'),('P-LG3',7,'D','economy'),('P-LG3',7,'E','economy'),('P-LG3',7,'F','economy'),('P-LG3',8,'A','economy'),('P-LG3',8,'B','economy'),('P-LG3',8,'C','economy'),('P-LG3',8,'D','economy'),('P-LG3',8,'E','economy'),('P-LG3',8,'F','economy'),('P-LG3',9,'A','economy'),('P-LG3',9,'B','economy'),('P-LG3',9,'C','economy'),('P-LG3',9,'D','economy'),('P-LG3',9,'E','economy'),('P-LG3',9,'F','economy'),('P-LG3',10,'A','economy'),('P-LG3',10,'B','economy'),('P-LG3',10,'C','economy'),('P-LG3',10,'D','economy'),('P-LG3',10,'E','economy'),('P-LG3',10,'F','economy'),('P-SM1',1,'A','economy'),('P-SM1',1,'B','economy'),('P-SM1',1,'C','economy'),('P-SM1',1,'D','economy'),('P-SM1',2,'A','economy'),('P-SM1',2,'B','economy'),('P-SM1',2,'C','economy'),('P-SM1',2,'D','economy'),('P-SM1',3,'A','economy'),('P-SM1',3,'B','economy'),('P-SM1',3,'C','economy'),('P-SM1',3,'D','economy'),('P-SM1',4,'A','economy'),('P-SM1',4,'B','economy'),('P-SM1',4,'C','economy'),('P-SM1',4,'D','economy'),('P-SM1',5,'A','economy'),('P-SM1',5,'B','economy'),('P-SM1',5,'C','economy'),('P-SM1',5,'D','economy'),('P-SM1',6,'A','economy'),('P-SM1',6,'B','economy'),('P-SM1',6,'C','economy'),('P-SM1',6,'D','economy'),('P-SM1',7,'A','economy'),('P-SM1',7,'B','economy'),('P-SM1',7,'C','economy'),('P-SM1',7,'D','economy'),('P-SM1',8,'A','economy'),('P-SM1',8,'B','economy'),('P-SM1',8,'C','economy'),('P-SM1',8,'D','economy'),('P-SM1',9,'A','economy'),('P-SM1',9,'B','economy'),('P-SM1',9,'C','economy'),('P-SM1',9,'D','economy'),('P-SM1',10,'A','economy'),('P-SM1',10,'B','economy'),('P-SM1',10,'C','economy'),('P-SM1',10,'D','economy'),('P-SM2',1,'A','economy'),('P-SM2',1,'B','economy'),('P-SM2',1,'C','economy'),('P-SM2',1,'D','economy'),('P-SM2',2,'A','economy'),('P-SM2',2,'B','economy'),('P-SM2',2,'C','economy'),('P-SM2',2,'D','economy'),('P-SM2',3,'A','economy'),('P-SM2',3,'B','economy'),('P-SM2',3,'C','economy'),('P-SM2',3,'D','economy'),('P-SM2',4,'A','economy'),('P-SM2',4,'B','economy'),('P-SM2',4,'C','economy'),('P-SM2',4,'D','economy'),('P-SM2',5,'A','economy'),('P-SM2',5,'B','economy'),('P-SM2',5,'C','economy'),('P-SM2',5,'D','economy'),('P-SM2',6,'A','economy'),('P-SM2',6,'B','economy'),('P-SM2',6,'C','economy'),('P-SM2',6,'D','economy'),('P-SM2',7,'A','economy'),('P-SM2',7,'B','economy'),('P-SM2',7,'C','economy'),('P-SM2',7,'D','economy'),('P-SM2',8,'A','economy'),('P-SM2',8,'B','economy'),('P-SM2',8,'C','economy'),('P-SM2',8,'D','economy'),('P-SM2',9,'A','economy'),('P-SM2',9,'B','economy'),('P-SM2',9,'C','economy'),('P-SM2',9,'D','economy'),('P-SM2',10,'A','economy'),('P-SM2',10,'B','economy'),('P-SM2',10,'C','economy'),('P-SM2',10,'D','economy'),('P-SM3',1,'A','economy'),('P-SM3',1,'B','economy'),('P-SM3',1,'C','economy'),('P-SM3',1,'D','economy'),('P-SM3',2,'A','economy'),('P-SM3',2,'B','economy'),('P-SM3',2,'C','economy'),('P-SM3',2,'D','economy'),('P-SM3',3,'A','economy'),('P-SM3',3,'B','economy'),('P-SM3',3,'C','economy'),('P-SM3',3,'D','economy'),('P-SM3',4,'A','economy'),('P-SM3',4,'B','economy'),('P-SM3',4,'C','economy'),('P-SM3',4,'D','economy'),('P-SM3',5,'A','economy'),('P-SM3',5,'B','economy'),('P-SM3',5,'C','economy'),('P-SM3',5,'D','economy'),('P-SM3',6,'A','economy'),('P-SM3',6,'B','economy'),('P-SM3',6,'C','economy'),('P-SM3',6,'D','economy'),('P-SM3',7,'A','economy'),('P-SM3',7,'B','economy'),('P-SM3',7,'C','economy'),('P-SM3',7,'D','economy'),('P-SM3',8,'A','economy'),('P-SM3',8,'B','economy'),('P-SM3',8,'C','economy'),('P-SM3',8,'D','economy'),('P-SM3',9,'A','economy'),('P-SM3',9,'B','economy'),('P-SM3',9,'C','economy'),('P-SM3',9,'D','economy'),('P-SM3',10,'A','economy'),('P-SM3',10,'B','economy'),('P-SM3',10,'C','economy'),('P-SM3',10,'D','economy');
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_email` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `passport` varchar(45) NOT NULL,
  `birth_date` date NOT NULL,
  `reg_date` date NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`customer_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('adicohen@gmail.com','Adi','Cohen','22222222','2000-02-02','2026-01-14','adi22222'),('dana@gmail.com','Dana','Israeli','87654321','1995-10-20','2025-06-01','dana456'),('moshe@gmail.com','Moshe','Peretz','12345678','1990-05-15','2025-01-01','pass123'),('noalevi@gmail.com','Noa','Levi','8449513','2000-01-20','2026-01-20','noa12345');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_phone_numbers`
--

DROP TABLE IF EXISTS `customer_phone_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_phone_numbers` (
  `phone_customer_email` varchar(45) NOT NULL,
  `phone_num` varchar(45) NOT NULL,
  PRIMARY KEY (`phone_customer_email`,`phone_num`),
  CONSTRAINT `fk_phone_customer` FOREIGN KEY (`phone_customer_email`) REFERENCES `customer` (`customer_email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_phone_numbers`
--

LOCK TABLES `customer_phone_numbers` WRITE;
/*!40000 ALTER TABLE `customer_phone_numbers` DISABLE KEYS */;
INSERT INTO `customer_phone_numbers` VALUES ('adicohen@gmail.com','0522222222'),('dana@gmail.com','0525556666'),('moshe@gmail.com','0501112222'),('moshe@gmail.com','0543334444'),('noalevi@gmail.com','0547777777');
/*!40000 ALTER TABLE `customer_phone_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  KEY `fk_flight_plane` (`plane_id`),
  KEY `fk_flight_route` (`origin_airport`,`destination_airport`),
  CONSTRAINT `fk_flight_plane` FOREIGN KEY (`plane_id`) REFERENCES `plane` (`plane_id`),
  CONSTRAINT `fk_flight_route` FOREIGN KEY (`origin_airport`, `destination_airport`) REFERENCES `route` (`origin_airport`, `destination_airport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES ('FT101','completed','TLV','JFK','2026-01-10 10:00:00','2026-01-10 22:00:00','P-LG1',850,1600),('FT102','cancelled','TLV','ATH','2026-02-20 11:00:00','2026-02-20 13:00:00','P-SM1',350,NULL),('FT103','completed','JFK','TLV','2026-01-12 20:00:00','2026-01-13 07:00:00','P-LG1',850,1600),('FT104','active','TLV','CDG','2026-03-04 04:30:00','2026-03-04 09:20:00','P-LG3',500,1100),('FT105','active','CDG','TLV','2026-03-10 12:00:00','2026-03-10 16:30:00','P-LG3',500,1000),('FT106','completed','TLV','BKK','2026-01-19 21:30:00','2026-01-20 08:10:00','P-LG2',700,1300),('FT107','active','TLV','ATH','2026-05-01 11:00:00','2026-05-01 13:00:00','P-SM2',350,NULL),('FT108','active','ATH','TLV','2026-06-01 03:00:00','2026-06-01 05:00:00','P-SM2',350,NULL);
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight_attendant`
--

DROP TABLE IF EXISTS `flight_attendant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight_attendant` (
  `fa_id` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone_num` varchar(45) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `st_num` int NOT NULL,
  `long_flight_qualified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`fa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight_attendant`
--

LOCK TABLES `flight_attendant` WRITE;
/*!40000 ALTER TABLE `flight_attendant` DISABLE KEYS */;
INSERT INTO `flight_attendant` VALUES ('411000001','Maya','Sela','0541110001','2022-01-01','Herzliya','Sokolov',4,1),('411000002','Tamar','Agam','0541110002','2022-05-01','Jerusalem','Jaffa',15,0),('411000003','Roni','Shaked','0541110003','2021-11-01','Petah Tikva','Struma',2,1),('411000004','Noam','Dror','0541110004','2023-02-01','Rehovot','Herzl',88,0),('411000005','Gali','Aviv','0541110005','2020-01-01','Ashkelon','Barnea',1,1),('411000006','Shira','Lev','0541110006','2022-08-15','Kfar Saba','Weizmann',10,0),('411000007','Michal','Or','0541110007','2021-03-20','Hadera','Hanassi',5,0),('411000008','Hila','Zohar','0541110008','2023-06-01','Modiin','Valley',3,1),('411000009','Noga','Erez','0541110009','2019-10-10','Yavne','Dufna',12,0),('411000010','Dana','Berg','0541110010','2022-12-01','Lod','Zahal',20,1),('411000011','Tali','Farkash','0541110011','2021-07-07','Ramla','Bialik',9,0),('411000012','Keren','Peles','0541110012','2020-04-04','Nes Ziona','Rotem',2,1),('411000013','Gaya','Tavor','0541110013','2023-09-12','Afula','Sharet',14,0),('411000014','Zohar','Argov','0541110014','2021-12-25','Tiberias','Galil',6,1),('411000015','Eden','Ben','0541110015','2022-02-02','Nahariya','Gaaton',40,0),('411000016','Sarai','Givaty','0541110016','2020-11-11','Safed','Alon',11,1),('411000017','Lihi','Korn','0541110017','2023-01-10','Kiryat Shmona','Erez',8,0),('411000018','Moran','Atias','0541110018','2021-05-30','Raanana','Ahuza',19,1),('411000019','Yam','Kaspers','0541110019','2022-04-12','Shoham','Tamar',7,0),('411222333','Adi','Yogev','0545554444','2023-01-01','Tel Aviv','Ben Gurion',51,1);
/*!40000 ALTER TABLE `flight_attendant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight_attendants_on_flight`
--

DROP TABLE IF EXISTS `flight_attendants_on_flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight_attendants_on_flight` (
  `flight_id` varchar(45) NOT NULL,
  `fa_id` varchar(45) NOT NULL,
  PRIMARY KEY (`flight_id`,`fa_id`),
  KEY `flight_attendants_on_flight_ibfk_2` (`fa_id`),
  CONSTRAINT `flight_attendants_on_flight_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `flight_attendants_on_flight_ibfk_2` FOREIGN KEY (`fa_id`) REFERENCES `flight_attendant` (`fa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight_attendants_on_flight`
--

LOCK TABLES `flight_attendants_on_flight` WRITE;
/*!40000 ALTER TABLE `flight_attendants_on_flight` DISABLE KEYS */;
INSERT INTO `flight_attendants_on_flight` VALUES ('FT101','411000001'),('FT103','411000001'),('FT107','411000001'),('FT108','411000001'),('FT102','411000002'),('FT101','411000003'),('FT102','411000004'),('FT101','411000005'),('FT102','411000006'),('FT104','411000007'),('FT105','411000007'),('FT107','411000007'),('FT108','411000007'),('FT101','411000008'),('FT104','411000009'),('FT105','411000009'),('FT107','411000009'),('FT108','411000009'),('FT101','411000010'),('FT103','411000010'),('FT106','411000010'),('FT104','411000011'),('FT105','411000011'),('FT103','411000012'),('FT106','411000012'),('FT103','411000014'),('FT106','411000014'),('FT104','411000015'),('FT105','411000015'),('FT104','411000016'),('FT105','411000016'),('FT106','411000016'),('FT104','411000017'),('FT105','411000017'),('FT103','411000018'),('FT106','411000018'),('FT101','411222333'),('FT103','411222333'),('FT106','411222333');
/*!40000 ALTER TABLE `flight_attendants_on_flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight_created_by`
--

DROP TABLE IF EXISTS `flight_created_by`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight_created_by` (
  `flight_id` varchar(45) NOT NULL,
  `manager_id` varchar(45) NOT NULL,
  PRIMARY KEY (`flight_id`,`manager_id`),
  KEY `manager_id_idx` (`manager_id`),
  CONSTRAINT `flight_id` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `manager_id` FOREIGN KEY (`manager_id`) REFERENCES `manager` (`manager_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight_created_by`
--

LOCK TABLES `flight_created_by` WRITE;
/*!40000 ALTER TABLE `flight_created_by` DISABLE KEYS */;
INSERT INTO `flight_created_by` VALUES ('FT101','211555666'),('FT102','211555666'),('FT103','211555666'),('FT104','211555666'),('FT105','222333555'),('FT106','222333555'),('FT107','222333555'),('FT108','222333555');
/*!40000 ALTER TABLE `flight_created_by` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `guest_email` varchar(45) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`guest_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES ('adi.yogev100@gmail.com','Adi','Yogev'),('guest1@gmail.com','David','Cohen'),('guest2@gmail.com','Eli','Levi'),('noakirel@gmail.com','Noa','Kirel');
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest_phone_numbers`
--

DROP TABLE IF EXISTS `guest_phone_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest_phone_numbers` (
  `phone_guest_email` varchar(45) NOT NULL,
  `phone_num` varchar(45) NOT NULL,
  PRIMARY KEY (`phone_guest_email`,`phone_num`),
  CONSTRAINT `guest_phone_numbers_ibfk_1` FOREIGN KEY (`phone_guest_email`) REFERENCES `guest` (`guest_email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest_phone_numbers`
--

LOCK TABLES `guest_phone_numbers` WRITE;
/*!40000 ALTER TABLE `guest_phone_numbers` DISABLE KEYS */;
INSERT INTO `guest_phone_numbers` VALUES ('adi.yogev100@gmail.com','0542090260'),('guest1@gmail.com','0523480647'),('guest2@gmail.com','0584132955'),('noakirel@gmail.com','0523333999'),('noakirel@gmail.com','0551029384');
/*!40000 ALTER TABLE `guest_phone_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manager`
--

DROP TABLE IF EXISTS `manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manager` (
  `manager_id` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone_num` varchar(45) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `st_num` int NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`manager_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
/*!40000 ALTER TABLE `manager` DISABLE KEYS */;
INSERT INTO `manager` VALUES ('211555666','Noa','Nitzan','0501234567','2024-01-01','Tel Aviv','Herzl',10,'noa123'),('222333444','Eitan','Levi','0529876543','2024-05-01','Haifa','Hanassi',22,'eitan456'),('222333555','Eran','Tascesme','0543597620','2026-01-01','Tel Aviv','Hahashmonaim',41,'eran100');
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `code` varchar(45) NOT NULL,
  `status` enum('active','completed','cancelled by user','cancelled by system') DEFAULT 'active',
  `total_price` int DEFAULT NULL,
  `order_date` datetime NOT NULL,
  `flight_id` varchar(45) NOT NULL,
  `customer_email` varchar(45) DEFAULT NULL,
  `guest_email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `fk_order_flight` (`flight_id`),
  KEY `fk_orders_guest` (`guest_email`),
  KEY `fk_order_customer` (`customer_email`),
  CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_email`) REFERENCES `customer` (`customer_email`) ON DELETE SET NULL,
  CONSTRAINT `fk_order_flight` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `fk_order_guest` FOREIGN KEY (`guest_email`) REFERENCES `guest` (`guest_email`),
  CONSTRAINT `fk_orders_guest` FOREIGN KEY (`guest_email`) REFERENCES `guest` (`guest_email`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('6FF73M','active',1750,'2026-01-20 14:29:10','FT107','noalevi@gmail.com',NULL),('8AALFX','active',2500,'2026-01-20 09:43:56','FT104','moshe@gmail.com',NULL),('AD101F','completed',12450,'2026-01-05 10:00:00','FT101','adicohen@gmail.com',NULL),('AUG25A','completed',850,'2025-08-10 10:00:00','FT101','adicohen@gmail.com',NULL),('AUG25B','cancelled by user',50,'2025-08-15 14:20:00','FT101','dana@gmail.com',NULL),('B6N4H1','completed',850,'2026-01-05 14:30:00','FT101','dana@gmail.com',NULL),('CDPFWE','cancelled by system',0,'2026-01-14 11:28:25','FT102','moshe@gmail.com',NULL),('D2P4AE','completed',18800,'2026-01-19 21:14:27','FT106','adicohen@gmail.com',NULL),('DA103F','completed',10850,'2026-01-08 12:00:00','FT103','dana@gmail.com',NULL),('DEC25A','completed',850,'2025-12-08 15:30:00','FT101','adicohen@gmail.com',NULL),('DEC25B','cancelled by user',50,'2025-12-22 09:00:00','FT101','dana@gmail.com',NULL),('DEJ368','completed',4700,'2026-01-19 21:28:26','FT106','dana@gmail.com',NULL),('E6GERF','completed',850,'2026-01-03 15:55:15','FT101',NULL,'adi.yogev100@gmail.com'),('EV9Z9Z','active',500,'2026-01-14 10:56:27','FT105',NULL,'noakirel@gmail.com'),('EZ3CEK','completed',6100,'2026-01-19 21:29:23','FT106','moshe@gmail.com',NULL),('L8MN1J','active',3500,'2026-01-20 14:30:47','FT108','adicohen@gmail.com',NULL),('MO105F','active',4000,'2026-01-19 15:30:00','FT105','moshe@gmail.com',NULL),('MUZ7BP','cancelled by system',0,'2026-01-14 11:42:00','FT102','adicohen@gmail.com',NULL),('N2GLZ7','completed',3300,'2026-01-06 11:11:13','FT101','moshe@gmail.com',NULL),('ND2JV8','active',3500,'2026-01-20 14:30:16','FT107','adicohen@gmail.com',NULL),('NOV25A','completed',850,'2025-11-02 12:00:00','FT103','moshe@gmail.com',NULL),('NOV25B','cancelled by user',50,'2025-11-18 20:10:00','FT103',NULL,'guest2@gmail.com'),('OCT25A','completed',850,'2025-10-12 11:00:00','FT101','adicohen@gmail.com',NULL),('OCT25B','cancelled by user',50,'2025-10-25 16:45:00','FT101','dana@gmail.com',NULL),('PAU428','active',1750,'2026-01-20 14:31:29','FT108','noalevi@gmail.com',NULL),('R3M8Q2','completed',850,'2026-01-08 10:20:00','FT103','adicohen@gmail.com',NULL),('SEP25A','completed',850,'2025-09-05 09:15:00','FT103','moshe@gmail.com',NULL),('SEP25B','cancelled by user',50,'2025-09-20 18:30:00','FT103',NULL,'guest1@gmail.com'),('T5Y1X4','completed',1600,'2026-01-09 16:45:00','FT103','moshe@gmail.com',NULL),('UE7X5D','active',1100,'2026-01-13 17:28:15','FT104','dana@gmail.com',NULL),('W9K2L7','completed',850,'2026-01-10 21:00:00','FT103',NULL,'guest1@gmail.com'),('WPKX7F','cancelled by system',0,'2026-01-14 11:33:18','FT102','dana@gmail.com',NULL),('XMRT0L','cancelled by user',50,'2026-01-13 17:22:30','FT104','moshe@gmail.com',NULL),('Z1V5M9','completed',700,'2026-01-15 08:15:00','FT106',NULL,'guest2@gmail.com');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pilot`
--

DROP TABLE IF EXISTS `pilot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pilot` (
  `pilot_id` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone_num` varchar(45) NOT NULL,
  `start_date` date NOT NULL,
  `city` varchar(45) NOT NULL,
  `street` varchar(45) NOT NULL,
  `st_num` int NOT NULL,
  `long_flight_qualified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`pilot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pilot`
--

LOCK TABLES `pilot` WRITE;
/*!40000 ALTER TABLE `pilot` DISABLE KEYS */;
INSERT INTO `pilot` VALUES ('311111111','David','Cohen','0501112222','2020-01-01','Jaffa','Yefet',5,1),('311111112','Yossi','Barak','0503334444','2021-06-15','Ramat Gan','Bialik',12,1),('311111113','Ariel','Ziv','0505556666','2022-03-10','Netanya','Herzl',3,0),('311111114','Omer','Golan','0507778888','2022-11-20','Haifa','Allenby',8,0),('311111115','Itay','Halevi','0509990000','2019-12-01','Eilat','Hatmarim',1,1),('311111116','Nir','Shani','0521113333','2023-05-01','Holon','Kugel',90,0),('311111117','Guy','Sasson','0524445555','2021-01-01','Bat Yam','Nissenbaum',7,0),('311111118','Erez','Tal','0526667777','2020-08-12','Ashdod','Rogozin',14,1),('311111119','Lior','Raz','0528889999','2022-02-28','Givatayim','Katznelson',33,1),('311111120','Yoav','Levinson','0549876543','2026-01-10','Kfar Saba','Haeshel',5,1),('311444555','Kerem','Samulelov','0504445555','2023-01-01','Tel Aviv','Dizengoff',45,1);
/*!40000 ALTER TABLE `pilot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pilots_on_flight`
--

DROP TABLE IF EXISTS `pilots_on_flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pilots_on_flight` (
  `flight_id` varchar(45) NOT NULL,
  `pilot_id` varchar(45) NOT NULL,
  PRIMARY KEY (`flight_id`,`pilot_id`),
  KEY `pilots_on_flight_ibfk_2` (`pilot_id`),
  CONSTRAINT `pilots_on_flight_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `pilots_on_flight_ibfk_2` FOREIGN KEY (`pilot_id`) REFERENCES `pilot` (`pilot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pilots_on_flight`
--

LOCK TABLES `pilots_on_flight` WRITE;
/*!40000 ALTER TABLE `pilots_on_flight` DISABLE KEYS */;
INSERT INTO `pilots_on_flight` VALUES ('FT101','311111111'),('FT101','311111112'),('FT102','311111113'),('FT102','311111114'),('FT104','311111115'),('FT105','311111115'),('FT106','311111115'),('FT104','311111116'),('FT105','311111116'),('FT107','311111116'),('FT108','311111116'),('FT104','311111117'),('FT105','311111117'),('FT103','311111118'),('FT106','311111118'),('FT103','311111119'),('FT106','311111119'),('FT107','311111120'),('FT108','311111120'),('FT101','311444555'),('FT103','311444555');
/*!40000 ALTER TABLE `pilots_on_flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plane`
--

DROP TABLE IF EXISTS `plane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plane` (
  `plane_id` varchar(45) NOT NULL,
  `size` enum('small','large') NOT NULL,
  `purchase_date` date DEFAULT NULL,
  `manufacturer` enum('Boeing','Airbus','Dassault') DEFAULT NULL,
  PRIMARY KEY (`plane_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plane`
--

LOCK TABLES `plane` WRITE;
/*!40000 ALTER TABLE `plane` DISABLE KEYS */;
INSERT INTO `plane` VALUES ('P-LG1','large','2020-01-01','Boeing'),('P-LG2','large','2021-02-01','Boeing'),('P-LG3','large','2022-03-01','Airbus'),('P-SM1','small','2020-01-01','Dassault'),('P-SM2','small','2021-02-01','Dassault'),('P-SM3','small','2022-03-01','Airbus');
/*!40000 ALTER TABLE `plane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route` (
  `origin_airport` varchar(45) NOT NULL,
  `destination_airport` varchar(45) NOT NULL,
  `duration` time NOT NULL,
  `is_long` tinyint(1) GENERATED ALWAYS AS ((`duration` > '06:00:00')) STORED,
  PRIMARY KEY (`origin_airport`,`destination_airport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` (`origin_airport`, `destination_airport`, `duration`) VALUES ('AMS','LHR','01:10:00'),('AMS','TLV','05:15:00'),('ATH','TLV','02:00:00'),('BCN','MAD','01:15:00'),('BCN','TLV','04:45:00'),('BKK','TLV','10:40:00'),('CDG','TLV','04:30:00'),('FCO','TLV','03:45:00'),('HND','JFK','14:30:00'),('JFK','HND','14:30:00'),('JFK','LHR','07:30:00'),('JFK','TLV','11:00:00'),('LHR','AMS','01:10:00'),('LHR','JFK','03:45:00'),('LHR','TLV','05:00:00'),('MAD','BCN','01:15:00'),('MAD','TLV','05:30:00'),('TLV','AMS','05:15:00'),('TLV','ATH','02:00:00'),('TLV','BCN','04:45:00'),('TLV','BKK','10:40:00'),('TLV','CDG','04:50:00'),('TLV','FCO','03:45:00'),('TLV','JFK','12:00:00'),('TLV','LHR','05:30:00'),('TLV','MAD','05:30:00');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seats_in_order`
--

DROP TABLE IF EXISTS `seats_in_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seats_in_order` (
  `code` varchar(45) NOT NULL,
  `seats_plane_id` varchar(45) NOT NULL,
  `seat_row` int NOT NULL,
  `seat_position` varchar(1) NOT NULL,
  PRIMARY KEY (`code`,`seats_plane_id`,`seat_row`,`seat_position`),
  KEY `fk_seats_class` (`seats_plane_id`,`seat_row`,`seat_position`),
  CONSTRAINT `fk_seats_class` FOREIGN KEY (`seats_plane_id`, `seat_row`, `seat_position`) REFERENCES `class` (`plane_id`, `seat_row`, `seat_position`),
  CONSTRAINT `fk_seats_order` FOREIGN KEY (`code`) REFERENCES `orders` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seats_in_order`
--

LOCK TABLES `seats_in_order` WRITE;
/*!40000 ALTER TABLE `seats_in_order` DISABLE KEYS */;
INSERT INTO `seats_in_order` VALUES ('AD101F','P-LG1',1,'A'),('AD101F','P-LG1',1,'B'),('AD101F','P-LG1',1,'C'),('DEC25B','P-LG1',1,'D'),('DA103F','P-LG1',2,'A'),('T5Y1X4','P-LG1',2,'A'),('DA103F','P-LG1',2,'B'),('NOV25B','P-LG1',2,'C'),('DEC25A','P-LG1',2,'D'),('AUG25A','P-LG1',3,'A'),('N2GLZ7','P-LG1',3,'B'),('AUG25B','P-LG1',3,'C'),('SEP25A','P-LG1',3,'D'),('E6GERF','P-LG1',4,'B'),('SEP25B','P-LG1',4,'C'),('OCT25A','P-LG1',4,'D'),('OCT25B','P-LG1',4,'E'),('NOV25A','P-LG1',4,'F'),('AD101F','P-LG1',5,'A'),('AD101F','P-LG1',5,'B'),('AD101F','P-LG1',5,'C'),('N2GLZ7','P-LG1',6,'A'),('N2GLZ7','P-LG1',6,'B'),('R3M8Q2','P-LG1',6,'C'),('AD101F','P-LG1',7,'A'),('AD101F','P-LG1',7,'B'),('AD101F','P-LG1',7,'C'),('B6N4H1','P-LG1',7,'E'),('AD101F','P-LG1',8,'A'),('AD101F','P-LG1',8,'B'),('AD101F','P-LG1',8,'C'),('DA103F','P-LG1',9,'A'),('DA103F','P-LG1',9,'B'),('DA103F','P-LG1',9,'C'),('W9K2L7','P-LG1',9,'F'),('DA103F','P-LG1',10,'A'),('DA103F','P-LG1',10,'B'),('DA103F','P-LG1',10,'C'),('DA103F','P-LG1',10,'D'),('DA103F','P-LG1',10,'E'),('DA103F','P-LG1',10,'F'),('D2P4AE','P-LG2',1,'A'),('D2P4AE','P-LG2',1,'B'),('D2P4AE','P-LG2',1,'C'),('D2P4AE','P-LG2',1,'D'),('D2P4AE','P-LG2',2,'A'),('D2P4AE','P-LG2',2,'B'),('D2P4AE','P-LG2',2,'C'),('D2P4AE','P-LG2',2,'D'),('EZ3CEK','P-LG2',3,'A'),('EZ3CEK','P-LG2',3,'B'),('DEJ368','P-LG2',3,'C'),('DEJ368','P-LG2',3,'D'),('D2P4AE','P-LG2',4,'A'),('D2P4AE','P-LG2',4,'B'),('D2P4AE','P-LG2',4,'C'),('D2P4AE','P-LG2',4,'D'),('D2P4AE','P-LG2',4,'E'),('D2P4AE','P-LG2',4,'F'),('D2P4AE','P-LG2',5,'A'),('D2P4AE','P-LG2',5,'B'),('D2P4AE','P-LG2',5,'C'),('D2P4AE','P-LG2',5,'D'),('D2P4AE','P-LG2',5,'E'),('D2P4AE','P-LG2',5,'F'),('DEJ368','P-LG2',7,'D'),('DEJ368','P-LG2',7,'E'),('DEJ368','P-LG2',7,'F'),('EZ3CEK','P-LG2',8,'A'),('EZ3CEK','P-LG2',8,'B'),('EZ3CEK','P-LG2',8,'C'),('EZ3CEK','P-LG2',9,'A'),('EZ3CEK','P-LG2',9,'B'),('Z1V5M9','P-LG2',10,'D'),('UE7X5D','P-LG3',3,'B'),('XMRT0L','P-LG3',4,'B'),('EV9Z9Z','P-LG3',4,'C'),('XMRT0L','P-LG3',4,'C'),('8AALFX','P-LG3',4,'D'),('8AALFX','P-LG3',4,'E'),('8AALFX','P-LG3',4,'F'),('8AALFX','P-LG3',5,'A'),('8AALFX','P-LG3',5,'B'),('MO105F','P-LG3',6,'A'),('MO105F','P-LG3',6,'B'),('MO105F','P-LG3',6,'C'),('MO105F','P-LG3',7,'A'),('MO105F','P-LG3',7,'B'),('MO105F','P-LG3',7,'C'),('MO105F','P-LG3',8,'A'),('MO105F','P-LG3',8,'B'),('CDPFWE','P-SM1',1,'A'),('CDPFWE','P-SM1',1,'B'),('CDPFWE','P-SM1',1,'C'),('CDPFWE','P-SM1',1,'D'),('CDPFWE','P-SM1',2,'A'),('CDPFWE','P-SM1',2,'B'),('CDPFWE','P-SM1',2,'C'),('CDPFWE','P-SM1',2,'D'),('CDPFWE','P-SM1',3,'D'),('WPKX7F','P-SM1',5,'A'),('WPKX7F','P-SM1',5,'B'),('WPKX7F','P-SM1',6,'A'),('WPKX7F','P-SM1',6,'B'),('WPKX7F','P-SM1',6,'C'),('WPKX7F','P-SM1',6,'D'),('MUZ7BP','P-SM1',7,'A'),('WPKX7F','P-SM1',7,'B'),('WPKX7F','P-SM1',7,'C'),('WPKX7F','P-SM1',7,'D'),('MUZ7BP','P-SM1',8,'A'),('MUZ7BP','P-SM1',8,'B'),('MUZ7BP','P-SM1',8,'C'),('MUZ7BP','P-SM1',8,'D'),('MUZ7BP','P-SM1',9,'A'),('MUZ7BP','P-SM1',9,'B'),('MUZ7BP','P-SM1',9,'C'),('MUZ7BP','P-SM1',9,'D'),('MUZ7BP','P-SM1',10,'A'),('MUZ7BP','P-SM1',10,'B'),('MUZ7BP','P-SM1',10,'C'),('MUZ7BP','P-SM1',10,'D'),('6FF73M','P-SM2',1,'A'),('PAU428','P-SM2',1,'A'),('6FF73M','P-SM2',1,'B'),('PAU428','P-SM2',1,'B'),('6FF73M','P-SM2',1,'C'),('PAU428','P-SM2',1,'C'),('6FF73M','P-SM2',1,'D'),('PAU428','P-SM2',2,'A'),('PAU428','P-SM2',2,'B'),('6FF73M','P-SM2',2,'D'),('L8MN1J','P-SM2',4,'A'),('L8MN1J','P-SM2',4,'B'),('L8MN1J','P-SM2',4,'C'),('L8MN1J','P-SM2',4,'D'),('L8MN1J','P-SM2',5,'A'),('L8MN1J','P-SM2',5,'B'),('L8MN1J','P-SM2',5,'C'),('L8MN1J','P-SM2',5,'D'),('L8MN1J','P-SM2',6,'A'),('ND2JV8','P-SM2',6,'A'),('ND2JV8','P-SM2',6,'B'),('ND2JV8','P-SM2',6,'C'),('L8MN1J','P-SM2',6,'D'),('ND2JV8','P-SM2',6,'D'),('ND2JV8','P-SM2',7,'A'),('ND2JV8','P-SM2',7,'B'),('ND2JV8','P-SM2',7,'C'),('ND2JV8','P-SM2',8,'A'),('ND2JV8','P-SM2',8,'B'),('ND2JV8','P-SM2',8,'C');
/*!40000 ALTER TABLE `seats_in_order` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-20 14:32:43
