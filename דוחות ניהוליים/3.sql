USE `FLYTAU`;

SELECT 'Pilot' AS role, 
	CASE WHEN r.is_long = 1 THEN 'long' ELSE 'short' END AS flight_length,
	SUM(TIME_TO_SEC(r.duration)/3600) AS working_hours
FROM Pilots_on_Flight pf 
	JOIN Flight f ON f.flight_id = pf.flight_id
	JOIN Route r ON r.origin_airport = f.origin_airport AND r.destination_airport = f.destination_airport
WHERE f.status != 'cancelled'
GROUP BY role, flight_length

UNION ALL

SELECT
	'Flight_Attendant' AS role,
	CASE WHEN r.is_long = 1 THEN 'long' ELSE 'short' END AS flight_length,
	SUM(TIME_TO_SEC(r.duration)/3600) AS working_hours
FROM FA_on_Flight ff
	JOIN Flight f ON f.flight_id = ff.flight_id
	JOIN Route r ON r.origin_airport = f.origin_airport AND r.destination_airport = f.destination_airport
WHERE f.status != 'cancelled'
GROUP BY role, flight_length