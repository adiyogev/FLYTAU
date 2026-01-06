USE FLYTAU;

SELECT AVG(occupancy_rate) as final_avg_occupancy
FROM (
    SELECT 
        f.flight_id,
        -- ספירת המושבים המוזמנים לטיסה זו (סינון הזמנות מבוטלות)
        (SELECT COUNT(*) 
         FROM seats_in_order sio 
         JOIN orders o ON sio.code = o.code 
         WHERE o.flight_id = f.flight_id 
         AND o.status != 'cancelled') as booked_seats,
        
        -- ספירת סך המושבים במטוס הספציפי של הטיסה
        (SELECT COUNT(*) 
         FROM class 
         WHERE plane_id = f.plane_id) as total_capacity,
         
        -- חישוב אחוז התפוסה לטיסה הבודדת
        ((SELECT COUNT(*) FROM seats_in_order sio JOIN orders o ON sio.code = o.code WHERE o.flight_id = f.flight_id AND o.status != 'cancelled') / 
         (SELECT COUNT(*) FROM class WHERE plane_id = f.plane_id)) * 100 as occupancy_rate
         
    FROM flight f
    -- סינון: רק טיסות פעילות
    WHERE f.status = 'completed'
) as flight_occupancy_table;