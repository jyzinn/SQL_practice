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