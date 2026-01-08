USE `FLYTAU`;

-- ==========================================================
-- 3. טעינת נתונים (Data Injection)
-- ==========================================================

LOCK TABLES `customer` WRITE;
INSERT INTO `customer` VALUES ('dana@gmail.com','Dana','Israeli','87654321','1995-10-20','2025-06-01','dana456'),('moshe@gmail.com','Moshe','Peretz','12345678','1990-05-15','2025-01-01','pass123');
UNLOCK TABLES;

LOCK TABLES `customer_phone_numbers` WRITE;
INSERT INTO `customer_phone_numbers` VALUES ('dana@gmail.com','0525556666'),('moshe@gmail.com','0501112222'),('moshe@gmail.com','0543334444');
UNLOCK TABLES;

LOCK TABLES `guest` WRITE;
INSERT INTO `guest` VALUES ('adi.yogev100@gmail.com','Adi','Yogev'),('guest1@gmail.com','David','Cohen'),('guest2@gmail.com','Eli','Levi');
UNLOCK TABLES;

LOCK TABLES `guest_phone_numbers` WRITE;
INSERT INTO `guest_phone_numbers` VALUES ('adi.yogev100@gmail.com','0542090260'),('guest1@gmail.com','0523480647'),('guest2@gmail.com','0584132955');
UNLOCK TABLES;

LOCK TABLES `manager` WRITE;
INSERT INTO `manager` VALUES ('211555666','Noa','Nitzan','0501234567','2024-01-01','Tel Aviv','Herzl',10,'noa123'),('222333444','Eitan','Levi','0529876543','2024-05-01','Haifa','Hanassi',22,'eitan456');
UNLOCK TABLES;

LOCK TABLES `pilot` WRITE;
INSERT INTO `pilot` VALUES ('311111111','David','Cohen','0501112222','2020-01-01','Jaffa','Yefet',5,1),('311111112','Yossi','Barak','0503334444','2021-06-15','Ramat Gan','Bialik',12,1),('311111113','Ariel','Ziv','0505556666','2022-03-10','Netanya','Herzl',3,0),('311111114','Omer','Golan','0507778888','2022-11-20','Haifa','Allenby',8,0),('311111115','Itay','Halevi','0509990000','2019-12-01','Eilat','Hatmarim',1,1),('311111116','Nir','Shani','0521113333','2023-05-01','Holon','Kugel',90,0),('311111117','Guy','Sasson','0524445555','2021-01-01','Bat Yam','Nissenbaum',7,0),('311111118','Erez','Tal','0526667777','2020-08-12','Ashdod','Rogozin',14,1),('311111119','Lior','Raz','0528889999','2022-02-28','Givatayim','Katznelson',33,1),('311444555','Kerem','Samulelov','0504445555','2023-01-01','Tel Aviv','Dizengoff',45,1);
UNLOCK TABLES;

LOCK TABLES `flight_attendant` WRITE;
INSERT INTO `flight_attendant` VALUES ('411000001','Maya','Sela','0541110001','2022-01-01','Herzliya','Sokolov',4,1),('411000002','Tamar','Agam','0541110002','2022-05-01','Jerusalem','Jaffa',15,0),('411000003','Roni','Shaked','0541110003','2021-11-01','Petah Tikva','Struma',2,1),('411000004','Noam','Dror','0541110004','2023-02-01','Rehovot','Herzl',88,0),('411000005','Gali','Aviv','0541110005','2020-01-01','Ashkelon','Barnea',1,1),('411000006','Shira','Lev','0541110006','2022-08-15','Kfar Saba','Weizmann',10,0),('411000007','Michal','Or','0541110007','2021-03-20','Hadera','Hanassi',5,0),('411000008','Hila','Zohar','0541110008','2023-06-01','Modiin','Valley',3,1),('411000009','Noga','Erez','0541110009','2019-10-10','Yavne','Dufna',12,0),('411000010','Dana','Berg','0541110010','2022-12-01','Lod','Zahal',20,1),('411000011','Tali','Farkash','0541110011','2021-07-07','Ramla','Bialik',9,0),('411000012','Keren','Peles','0541110012','2020-04-04','Nes Ziona','Rotem',2,1),('411000013','Gaya','Tavor','0541110013','2023-09-12','Afula','Sharet',14,0),('411000014','Zohar','Argov','0541110014','2021-12-25','Tiberias','Galil',6,1),('411000015','Eden','Ben','0541110015','2022-02-02','Nahariya','Gaaton',40,0),('411000016','Sarai','Givaty','0541110016','2020-11-11','Safed','Alon',11,1),('411000017','Lihi','Korn','0541110017','2023-01-10','Kiryat Shmona','Erez',8,0),('411000018','Moran','Atias','0541110018','2021-05-30','Raanana','Ahuza',19,1),('411000019','Yam','Kaspers','0541110019','2022-04-12','Shoham','Tamar',7,0),('411222333','Adi','Yogev','0545554444','2023-01-01','Tel Aviv','Ben Gurion',51,1);
UNLOCK TABLES;

LOCK TABLES `plane` WRITE;
INSERT INTO `plane` VALUES ('P-LG1','large','2020-01-01','Boeing'),('P-LG2','large','2021-02-01','Boeing'),('P-LG3','large','2022-03-01','Airbus'),('P-SM1','small','2020-01-01','Dassault'),('P-SM2','small','2021-02-01','Dassault'),('P-SM3','small','2022-03-01','Airbus');
UNLOCK TABLES;

LOCK TABLES `route` WRITE;
INSERT INTO `route` (`origin_airport`, `destination_airport`, `duration`) VALUES ('ATH','TLV','02:00:00'),('CDG','TLV','04:30:00'),('JFK','TLV','11:00:00'),('LHR','TLV','05:00:00'),('TLV','ATH','02:00:00'),('TLV','CDG','04:50:00'),('TLV','JFK','12:00:00'),('TLV','LHR','05:30:00');
UNLOCK TABLES;

LOCK TABLES `class` WRITE;
INSERT INTO `class` VALUES ('P-LG1',1,'A','business'),('P-LG1',1,'B','business'),('P-LG1',1,'C','business'),('P-LG1',1,'D','business'),('P-LG1',2,'A','business'),('P-LG1',2,'B','business'),('P-LG1',2,'C','business'),('P-LG1',2,'D','business'),('P-LG1',3,'A','business'),('P-LG1',3,'B','business'),('P-LG1',3,'C','business'),('P-LG1',3,'D','business'),('P-LG1',4,'A','economy'),('P-LG1',4,'B','economy'),('P-LG1',4,'C','economy'),('P-LG1',4,'D','economy'),('P-LG1',4,'E','economy'),('P-LG1',4,'F','economy'),('P-LG1',5,'A','economy'),('P-LG1',5,'B','economy'),('P-LG1',5,'C','economy'),('P-LG1',5,'D','economy'),('P-LG1',5,'E','economy'),('P-LG1',5,'F','economy'),('P-LG1',6,'A','economy'),('P-LG1',6,'B','economy'),('P-LG1',6,'C','economy'),('P-LG1',6,'D','economy'),('P-LG1',6,'E','economy'),('P-LG1',6,'F','economy'),('P-LG1',7,'A','economy'),('P-LG1',7,'B','economy'),('P-LG1',7,'C','economy'),('P-LG1',7,'D','economy'),('P-LG1',7,'E','economy'),('P-LG1',7,'F','economy'),('P-LG1',8,'A','economy'),('P-LG1',8,'B','economy'),('P-LG1',8,'C','economy'),('P-LG1',8,'D','economy'),('P-LG1',8,'E','economy'),('P-LG1',8,'F','economy'),('P-LG1',9,'A','economy'),('P-LG1',9,'B','economy'),('P-LG1',9,'C','economy'),('P-LG1',9,'D','economy'),('P-LG1',9,'E','economy'),('P-LG1',9,'F','economy'),('P-LG1',10,'A','economy'),('P-LG1',10,'B','economy'),('P-LG1',10,'C','economy'),('P-LG1',10,'D','economy'),('P-LG1',10,'E','economy'),('P-LG1',10,'F','economy'),('P-LG2',1,'A','business'),('P-LG2',1,'B','business'),('P-LG2',1,'C','business'),('P-LG2',1,'D','business'),('P-LG2',2,'A','business'),('P-LG2',2,'B','business'),('P-LG2',2,'C','business'),('P-LG2',2,'D','business'),('P-LG2',3,'A','business'),('P-LG2',3,'B','business'),('P-LG2',3,'C','business'),('P-LG2',3,'D','business'),('P-LG2',4,'A','economy'),('P-LG2',4,'B','economy'),('P-LG2',4,'C','economy'),('P-LG2',4,'D','economy'),('P-LG2',4,'E','economy'),('P-LG2',4,'F','economy'),('P-LG2',5,'A','economy'),('P-LG2',5,'B','economy'),('P-LG2',5,'C','economy'),('P-LG2',5,'D','economy'),('P-LG2',5,'E','economy'),('P-LG2',5,'F','economy'),('P-LG2',6,'A','economy'),('P-LG2',6,'B','economy'),('P-LG2',6,'C','economy'),('P-LG2',6,'D','economy'),('P-LG2',6,'E','economy'),('P-LG2',6,'F','economy'),('P-LG2',7,'A','economy'),('P-LG2',7,'B','economy'),('P-LG2',7,'C','economy'),('P-LG2',7,'D','economy'),('P-LG2',7,'E','economy'),('P-LG2',7,'F','economy'),('P-LG2',8,'A','economy'),('P-LG2',8,'B','economy'),('P-LG2',8,'C','economy'),('P-LG2',8,'D','economy'),('P-LG2',8,'E','economy'),('P-LG2',8,'F','economy'),('P-LG2',9,'A','economy'),('P-LG2',9,'B','economy'),('P-LG2',9,'C','economy'),('P-LG2',9,'D','economy'),('P-LG2',9,'E','economy'),('P-LG2',9,'F','economy'),('P-LG2',10,'A','economy'),('P-LG2',10,'B','economy'),('P-LG2',10,'C','economy'),('P-LG2',10,'D','economy'),('P-LG2',10,'E','economy'),('P-LG2',10,'F','economy'),('P-LG3',1,'A','business'),('P-LG3',1,'B','business'),('P-LG3',1,'C','business'),('P-LG3',1,'D','business'),('P-LG3',2,'A','business'),('P-LG3',2,'B','business'),('P-LG3',2,'C','business'),('P-LG3',2,'D','business'),('P-LG3',3,'A','business'),('P-LG3',3,'B','business'),('P-LG3',3,'C','business'),('P-LG3',3,'D','business'),('P-LG3',4,'A','economy'),('P-LG3',4,'B','economy'),('P-LG3',4,'C','economy'),('P-LG3',4,'D','economy'),('P-LG3',4,'E','economy'),('P-LG3',4,'F','economy'),('P-LG3',5,'A','economy'),('P-LG3',5,'B','economy'),('P-LG3',5,'C','economy'),('P-LG3',5,'D','economy'),('P-LG3',5,'E','economy'),('P-LG3',5,'F','economy'),('P-LG3',6,'A','economy'),('P-LG3',6,'B','economy'),('P-LG3',6,'C','economy'),('P-LG3',6,'D','economy'),('P-LG3',6,'E','economy'),('P-LG3',6,'F','economy'),('P-LG3',7,'A','economy'),('P-LG3',7,'B','economy'),('P-LG3',7,'C','economy'),('P-LG3',7,'D','economy'),('P-LG3',7,'E','economy'),('P-LG3',7,'F','economy'),('P-LG3',8,'A','economy'),('P-LG3',8,'B','economy'),('P-LG3',8,'C','economy'),('P-LG3',8,'D','economy'),('P-LG3',8,'E','economy'),('P-LG3',8,'F','economy'),('P-LG3',9,'A','economy'),('P-LG3',9,'B','economy'),('P-LG3',9,'C','economy'),('P-LG3',9,'D','economy'),('P-LG3',9,'E','economy'),('P-LG3',9,'F','economy'),('P-LG3',10,'A','economy'),('P-LG3',10,'B','economy'),('P-LG3',10,'C','economy'),('P-LG3',10,'D','economy'),('P-LG3',10,'E','economy'),('P-LG3',10,'F','economy'),('P-SM1',1,'A','economy'),('P-SM1',1,'B','economy'),('P-SM1',1,'C','economy'),('P-SM1',1,'D','economy'),('P-SM1',2,'A','economy'),('P-SM1',2,'B','economy'),('P-SM1',2,'C','economy'),('P-SM1',2,'D','economy'),('P-SM1',3,'A','economy'),('P-SM1',3,'B','economy'),('P-SM1',3,'C','economy'),('P-SM1',3,'D','economy'),('P-SM1',4,'A','economy'),('P-SM1',4,'B','economy'),('P-SM1',4,'C','economy'),('P-SM1',4,'D','economy'),('P-SM1',5,'A','economy'),('P-SM1',5,'B','economy'),('P-SM1',5,'C','economy'),('P-SM1',5,'D','economy'),('P-SM1',6,'A','economy'),('P-SM1',6,'B','economy'),('P-SM1',6,'C','economy'),('P-SM1',6,'D','economy'),('P-SM1',7,'A','economy'),('P-SM1',7,'B','economy'),('P-SM1',7,'C','economy'),('P-SM1',7,'D','economy'),('P-SM1',8,'A','economy'),('P-SM1',8,'B','economy'),('P-SM1',8,'C','economy'),('P-SM1',8,'D','economy'),('P-SM1',9,'A','economy'),('P-SM1',9,'B','economy'),('P-SM1',9,'C','economy'),('P-SM1',9,'D','economy'),('P-SM1',10,'A','economy'),('P-SM1',10,'B','economy'),('P-SM1',10,'C','economy'),('P-SM1',10,'D','economy'),('P-SM2',1,'A','economy'),('P-SM2',1,'B','economy'),('P-SM2',1,'C','economy'),('P-SM2',1,'D','economy'),('P-SM2',2,'A','economy'),('P-SM2',2,'B','economy'),('P-SM2',2,'C','economy'),('P-SM2',2,'D','economy'),('P-SM2',3,'A','economy'),('P-SM2',3,'B','economy'),('P-SM2',3,'C','economy'),('P-SM2',3,'D','economy'),('P-SM2',4,'A','economy'),('P-SM2',4,'B','economy'),('P-SM2',4,'C','economy'),('P-SM2',4,'D','economy'),('P-SM2',5,'A','economy'),('P-SM2',5,'B','economy'),('P-SM2',5,'C','economy'),('P-SM2',5,'D','economy'),('P-SM2',6,'A','economy'),('P-SM2',6,'B','economy'),('P-SM2',6,'C','economy'),('P-SM2',6,'D','economy'),('P-SM2',7,'A','economy'),('P-SM2',7,'B','economy'),('P-SM2',7,'C','economy'),('P-SM2',7,'D','economy'),('P-SM2',8,'A','economy'),('P-SM2',8,'B','economy'),('P-SM2',8,'C','economy'),('P-SM2',8,'D','economy'),('P-SM2',9,'A','economy'),('P-SM2',9,'B','economy'),('P-SM2',9,'C','economy'),('P-SM2',9,'D','economy'),('P-SM2',10,'A','economy'),('P-SM2',10,'B','economy'),('P-SM2',10,'C','economy'),('P-SM2',10,'D','economy'),('P-SM3',1,'A','economy'),('P-SM3',1,'B','economy'),('P-SM3',1,'C','economy'),('P-SM3',1,'D','economy'),('P-SM3',2,'A','economy'),('P-SM3',2,'B','economy'),('P-SM3',2,'C','economy'),('P-SM3',2,'D','economy'),('P-SM3',3,'A','economy'),('P-SM3',3,'B','economy'),('P-SM3',3,'C','economy'),('P-SM3',3,'D','economy'),('P-SM3',4,'A','economy'),('P-SM3',4,'B','economy'),('P-SM3',4,'C','economy'),('P-SM3',4,'D','economy'),('P-SM3',5,'A','economy'),('P-SM3',5,'B','economy'),('P-SM3',5,'C','economy'),('P-SM3',5,'D','economy'),('P-SM3',6,'A','economy'),('P-SM3',6,'B','economy'),('P-SM3',6,'C','economy'),('P-SM3',6,'D','economy'),('P-SM3',7,'A','economy'),('P-SM3',7,'B','economy'),('P-SM3',7,'C','economy'),('P-SM3',7,'D','economy'),('P-SM3',8,'A','economy'),('P-SM3',8,'B','economy'),('P-SM3',8,'C','economy'),('P-SM3',8,'D','economy'),('P-SM3',9,'A','economy'),('P-SM3',9,'B','economy'),('P-SM3',9,'C','economy'),('P-SM3',9,'D','economy'),('P-SM3',10,'A','economy'),('P-SM3',10,'B','economy'),('P-SM3',10,'C','economy'),('P-SM3',10,'D','economy');
UNLOCK TABLES;

LOCK TABLES `flight` WRITE;
INSERT INTO `flight` VALUES ('FT101','active','TLV','JFK','2026-01-10 10:00:00','2026-01-10 22:00:00','P-LG1',850,1600),('FT102','active','TLV','ATH','2026-02-20 11:00:00','2026-02-20 13:00:00','P-SM1',350,NULL),('FT103','active','JFK','TLV','2026-01-12 20:00:00','2026-01-13 07:00:00','P-LG1',850,1600);
UNLOCK TABLES;

LOCK TABLES `orders` WRITE;
INSERT INTO `orders` VALUES ('E6GERF','active',850,'2026-01-03 15:55:15','FT101',NULL,'adi.yogev100@gmail.com'),('N2GLZ7','active',3300,'2026-01-06 11:11:13','FT101','moshe@gmail.com',NULL);
UNLOCK TABLES;

LOCK TABLES `seats_in_order` WRITE;
INSERT INTO `seats_in_order` VALUES ('N2GLZ7','P-LG1',3,'B'),('E6GERF','P-LG1',4,'B'),('N2GLZ7','P-LG1',6,'A'),('N2GLZ7','P-LG1',6,'B');
UNLOCK TABLES;

LOCK TABLES `pilots_on_flight` WRITE;
INSERT INTO `pilots_on_flight` VALUES ('FT101','311111111'),('FT101','311111112'),('FT102','311111113'),('FT102','311111114'),('FT103','311111118'),('FT103','311111119'),('FT101','311444555'),('FT103','311444555');
UNLOCK TABLES;

LOCK TABLES `flight_attendants_on_flight` WRITE;
INSERT INTO `flight_attendants_on_flight` VALUES ('FT101','411000001'),('FT103','411000001'),('FT102','411000002'),('FT101','411000003'),('FT102','411000004'),('FT101','411000005'),('FT102','411000006'),('FT101','411000008'),('FT101','411000010'),('FT103','411000010'),('FT103','411000012'),('FT103','411000014'),('FT103','411000018'),('FT101','411222333'),('FT103','411222333');
UNLOCK TABLES;

LOCK TABLES `flight_created_by` WRITE;
INSERT INTO `flight_created_by` VALUES ('FT102','211555666'),('FT103','211555666');
UNLOCK TABLES;

