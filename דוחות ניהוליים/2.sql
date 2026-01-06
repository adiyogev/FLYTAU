USE FLYTAU;

SELECT p.manufacturer AS 'יצרנית מטוס', p.size AS 'גודל מטוס', c.class_type AS 'מחלקה',
    SUM(
        CASE 
            WHEN c.class_type = 'business' THEN f.business_seat_price
            WHEN c.class_type = 'economy' THEN f.economy_seat_price
            ELSE 0 
        END
    ) AS 'סה"כ הכנסות'
FROM Seats_in_Order as sio
	JOIN Orders o ON sio.code = o.code
	JOIN Flight f ON o.flight_id = f.flight_id
	JOIN Plane p ON f.plane_id = p.plane_id
	JOIN Class c ON sio.seats_plane_id = c.plane_id AND sio.seat_row = c.seat_row AND sio.seat_position = c.seat_position
WHERE o.status != 'cancelled' AND f.status != 'cancelled'
GROUP BY p.manufacturer, p.size, c.class_type
ORDER BY 'סה"כ הכנסות' DESC;