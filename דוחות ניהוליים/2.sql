USE `FLYTAU`;

SELECT p.size AS plane_size, p.manufacturer, c.class_type,
    SUM(CASE 
			WHEN c.class_type = 'business' AND o.status != 'cancelled by user' THEN f.business_seat_price 
            WHEN c.class_type = 'business' AND o.status = 'cancelled by user' THEN f.business_seat_price*0.05
            WHEN c.class_type = 'economy' AND o.status != 'cancelled by user' THEN f.economy_seat_price 
            WHEN c.class_type = 'economy' AND o.status = 'cancelled by user' THEN f.economy_seat_price*0.05
    END) AS total_revenue
FROM Orders o
	JOIN Seats_in_Order sio ON o.code = sio.code
	JOIN Flight f ON o.flight_id = f.flight_id
	JOIN Plane p ON f.plane_id = p.plane_id
	JOIN Class c ON sio.seats_plane_id = c.plane_id AND sio.seat_row = c.seat_row AND sio.seat_position = c.seat_position
WHERE f.status != 'cancelled'
GROUP BY p.size, p.manufacturer, c.class_type;
