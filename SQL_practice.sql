CREATE DATABASE sql_practice;
USE	sql_practice;

/* 
solvesql 레스토랑의 일일 매출
https://solvesql.com/problems/daily-revenue/ 
*/

SELECT  day,
        SUM(total_bill) AS revenue_daily
FROM    tips
GROUP BY day
HAVING  SUM(total_bill) >= 1000
ORDER BY revenue_daily DESC;

/* 
solvesql 버뮤다 삼각지대에 들어가버린 택배
https://solvesql.com/problems/shipment-in-bermuda/
*/

SELECT  DATE(order_delivered_carrier_date) AS delivered_carrier_date,
        COUNT(*) AS orders
FROM    olist_orders_dataset
WHERE   order_delivered_carrier_date LIKE '2017-01%'
        AND order_delivered_customer_date IS NULL
GROUP BY delivered_carrier_date
ORDER BY 1;