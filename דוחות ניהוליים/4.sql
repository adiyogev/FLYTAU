USE `FLYTAU`;

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    (SUM(CASE WHEN o.status = 'cancelled by user' THEN 1 ELSE 0 END) / COUNT(*)) AS cancellation_rate
FROM Orders o
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month DESC;