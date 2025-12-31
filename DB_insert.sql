USE `FLYTAU`;

-- 1. Managers (2 Managers)
INSERT INTO `Manager` VALUES 
('211555666', 'Noa', 'Nitzan', '0501234567', '2024-01-01', 'Tel Aviv', 'Herzl', 10, 'noa123'),
('222333444', 'Eitan', 'Levi', '0529876543', '2024-05-01', 'Haifa', 'Hanassi', 22, 'eitan456');

-- 2. Registered Customers (2 Customers)
INSERT INTO `Customer` VALUES 
('moshe@gmail.com', 'Moshe', 'Peretz', '12345678', '1990-05-15', '2025-01-01', 'pass123'),
('dana@gmail.com', 'Dana', 'Israeli', '87654321', '1995-10-20', '2025-06-01', 'dana456');

-- Adding phone numbers for the registered customers
INSERT INTO `Customer_Phone_Numbers` (`phone_customer_email`, `phone_num`) VALUES 
('moshe@gmail.com', '0501112222'),
('moshe@gmail.com', '0543334444'), -- Moshe has 2 numbers
('dana@gmail.com', '0525556666');  -- Dana has 1 number

-- 3. Guests (2 Guests)
INSERT INTO `Guest` (guest_email, passport, name) VALUES 
('guest1@gmail.com', 'P123456', 'Avi Ron'),
('guest2@gmail.com', 'P987654', 'Gali Li');

-- 4. Planes (6 Planes: 3 Small, 3 Large)
INSERT INTO `Plane` VALUES 
('P-SM1', 'small', '2020-01-01', 'Dassault'),
('P-SM2', 'small', '2021-02-01', 'Dassault'),
('P-SM3', 'small', '2022-03-01', 'Airbus'),
('P-LG1', 'large', '2020-01-01', 'Boeing'),
('P-LG2', 'large', '2021-02-01', 'Boeing'),
('P-LG3', 'large', '2022-03-01', 'Airbus');

-- 5. Pilots (10 Pilots)
INSERT INTO `Pilot` VALUES 
('311444555', 'Kerem', 'Samulelov', '0504445555', '2023-01-01', 'Tel Aviv', 'Dizengoff', 45, 1),
('311111111', 'David', 'Cohen', '0501112222', '2020-01-01', 'Jaffa', 'Yefet', 5, 1),
('311111112', 'Yossi', 'Barak', '0503334444', '2021-06-15', 'Ramat Gan', 'Bialik', 12, 1),
('311111113', 'Ariel', 'Ziv', '0505556666', '2022-03-10', 'Netanya', 'Herzl', 3, 0),
('311111114', 'Omer', 'Golan', '0507778888', '2022-11-20', 'Haifa', 'Allenby', 8, 0),
('311111115', 'Itay', 'Halevi', '0509990000', '2019-12-01', 'Eilat', 'Hatmarim', 1, 1),
('311111116', 'Nir', 'Shani', '0521113333', '2023-05-01', 'Holon', 'Kugel', 90, 0),
('311111117', 'Guy', 'Sasson', '0524445555', '2021-01-01', 'Bat Yam', 'Nissenbaum', 7, 0),
('311111118', 'Erez', 'Tal', '0526667777', '2020-08-12', 'Ashdod', 'Rogozin', 14, 1),
('311111119', 'Lior', 'Raz', '0528889999', '2022-02-28', 'Givatayim', 'Katznelson', 33, 1);

-- 6. Flight Attendants (20 Attendants)
INSERT INTO `Flight_Attendant` VALUES 
('411222333', 'Adi', 'Yogev', '0545554444', '2023-01-01', 'Tel Aviv', 'Ben Gurion', 51, 1),
('411000001', 'Maya', 'Sela', '0541110001', '2022-01-01', 'Herzliya', 'Sokolov', 4, 1),
('411000002', 'Tamar', 'Agam', '0541110002', '2022-05-01', 'Jerusalem', 'Jaffa', 15, 0),
('411000003', 'Roni', 'Shaked', '0541110003', '2021-11-01', 'Petah Tikva', 'Struma', 2, 1),
('411000004', 'Noam', 'Dror', '0541110004', '2023-02-01', 'Rehovot', 'Herzl', 88, 0),
('411000005', 'Gali', 'Aviv', '0541110005', '2020-01-01', 'Ashkelon', 'Barnea', 1, 1),
('411000006', 'Shira', 'Lev', '0541110006', '2022-08-15', 'Kfar Saba', 'Weizmann', 10, 0),
('411000007', 'Michal', 'Or', '0541110007', '2021-03-20', 'Hadera', 'Hanassi', 5, 0),
('411000008', 'Hila', 'Zohar', '0541110008', '2023-06-01', 'Modiin', 'Valley', 3, 1),
('411000009', 'Noga', 'Erez', '0541110009', '2019-10-10', 'Yavne', 'Dufna', 12, 0),
('411000010', 'Dana', 'Berg', '0541110010', '2022-12-01', 'Lod', 'Zahal', 20, 1),
('411000011', 'Tali', 'Farkash', '0541110011', '2021-07-07', 'Ramla', 'Bialik', 9, 0),
('411000012', 'Keren', 'Peles', '0541110012', '2020-04-04', 'Nes Ziona', 'Rotem', 2, 1),
('411000013', 'Gaya', 'Tavor', '0541110013', '2023-09-12', 'Afula', 'Sharet', 14, 0),
('411000014', 'Zohar', 'Argov', '0541110014', '2021-12-25', 'Tiberias', 'Galil', 6, 1),
('411000015', 'Eden', 'Ben', '0541110015', '2022-02-02', 'Nahariya', 'Gaaton', 40, 0),
('411000016', 'Sarai', 'Givaty', '0541110016', '2020-11-11', 'Safed', 'Alon', 11, 1),
('411000017', 'Lihi', 'Korn', '0541110017', '2023-01-10', 'Kiryat Shmona', 'Erez', 8, 0),
('411000018', 'Moran', 'Atias', '0541110018', '2021-05-30', 'Raanana', 'Ahuza', 19, 1),
('411000019', 'Yam', 'Kaspers', '0541110019', '2022-04-12', 'Shoham', 'Tamar', 7, 0);

-- 7. Routes (Bidirectional)
-- Every origin also appears as a destination
INSERT INTO `Route` (origin_airport, destination_airport, duration) VALUES 
('TLV', 'JFK', '12:00:00'), 
('JFK', 'TLV', '11:00:00'),
('TLV', 'LHR', '05:30:00'), 
('LHR', 'TLV', '05:00:00'),
('TLV', 'ATH', '02:00:00'), 
('ATH', 'TLV', '02:00:00'),
('TLV', 'CDG', '04:50:00'),
('CDG', 'TLV', '04:30:00');

-- Seats for Large Planes (P-LG1, P-LG2, P-LG3)
-- Business Class: Rows 1-3, Seats A, B, C, D
INSERT INTO `Class` (`plane_id`, `seat_row`, `seat_position`, `class_type`)
SELECT p.plane_id, r.row_num, pos.pos_char, 'business'
FROM (SELECT plane_id FROM Plane WHERE size = 'large') p
CROSS JOIN (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3) r
CROSS JOIN (SELECT 'A' AS pos_char UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D') pos;

-- Economy Class: Rows 4-10, Seats A, B, C, D, E, F
INSERT INTO `Class` (`plane_id`, `seat_row`, `seat_position`, `class_type`)
SELECT p.plane_id, r.row_num, pos.pos_char, 'economy'
FROM (SELECT plane_id FROM Plane WHERE size = 'large') p
CROSS JOIN (SELECT 4 AS row_num UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 'A' AS pos_char UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D' UNION SELECT 'E' UNION SELECT 'F') pos;


-- Seats for Small Planes (P-SM1, P-SM2, P-SM3)
-- Economy Only: Rows 1-10, Seats A, B, C, D
INSERT INTO `Class` (`plane_id`, `seat_row`, `seat_position`, `class_type`)
SELECT p.plane_id, r.row_num, pos.pos_char, 'economy'
FROM (SELECT plane_id FROM Plane WHERE size = 'small') p
CROSS JOIN (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 'A' AS pos_char UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D') pos;