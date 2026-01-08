USE `FLYTAU`;

SELECT 
    t.plane_id,
    t.activity_month,
    SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) AS flights_completed,
    SUM(CASE WHEN t.status = 'cancelled' THEN 1 ELSE 0 END) AS flights_cancelled,
    (SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) / 30.0) * 100 AS utilization_percent,
    (
        SELECT CONCAT(t2.origin_airport, '-', t2.destination_airport)
        FROM (SELECT
                p2.plane_id,
                DATE_FORMAT(f2.departure, '%Y-%m') AS activity_month,
                f2.origin_airport,
                f2.destination_airport
             FROM Plane p2 JOIN Flight f2 ON p2.plane_id = f2.plane_id
             WHERE f2.status = 'completed') AS t2
        WHERE t2.plane_id = t.plane_id AND t2.activity_month = t.activity_month
        GROUP BY t2.origin_airport, t2.destination_airport
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS dominant_route
FROM (
    SELECT
        p.plane_id,
        DATE_FORMAT(f.departure, '%Y-%m') AS activity_month,
        f.status,
        f.origin_airport,
        f.destination_airport
    FROM Plane p
    JOIN Flight f ON p.plane_id = f.plane_id
) AS t
GROUP BY t.plane_id, t.activity_month
ORDER BY t.activity_month DESC, t.plane_id;
