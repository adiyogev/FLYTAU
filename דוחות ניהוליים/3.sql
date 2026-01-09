USE `FLYTAU`;

SELECT e.employee_id, e.first_name, e.last_name,
    CASE WHEN r.is_long = 1 THEN 'long' ELSE 'short' END AS flight_length,
    SUM(TIME_TO_SEC(r.duration)/3600) AS working_hours
FROM (
    SELECT 
        p.pilot_id AS employee_id, p.first_name, p.last_name, pf.flight_id
    FROM Pilot p JOIN Pilots_on_Flight pf ON pf.pilot_id = p.pilot_id

    UNION ALL

    SELECT fa.fa_id AS employee_id, fa.first_name, fa.last_name, ff.flight_id
    FROM Flight_Attendant fa JOIN flight_attendants_on_flight ff ON ff.fa_id = fa.fa_id
	) AS e
JOIN Flight f ON f.flight_id = e.flight_id
JOIN Route r ON r.origin_airport = f.origin_airport AND r.destination_airport = f.destination_airport
WHERE f.status != 'cancelled'
GROUP BY e.employee_id, e.first_name, e.last_name, flight_length
ORDER BY e.employee_id, flight_length;
