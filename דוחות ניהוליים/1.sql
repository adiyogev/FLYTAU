USE `FLYTAU`;

SELECT AVG(occupied_seats / total_capacity) * 100 AS avg_occupancy_percentage
FROM (
    SELECT f.flight_id,
        (SELECT COUNT(*) FROM Class c WHERE c.plane_id = f.plane_id) AS total_capacity,
        (SELECT COUNT(*) 
		 FROM Seats_in_Order sio JOIN Orders o ON sio.code = o.code 
         WHERE o.flight_id = f.flight_id AND o.status != 'cancelled by user') AS occupied_seats
    FROM Flight f
    WHERE f.status = 'completed'
	) AS flight_occupancy;