/* 
solvesql 레스토랑의 일일 매출
https://solvesql.com/problems/daily-revenue/ 
*/

SELECT  day,
        SUM(total_bill) AS revenue_daily	-- 일별 매출 계산
FROM    tips
GROUP BY day
HAVING  revenue_daily >= 1000				-- 매출이 1000이상인 일자 필터링
ORDER BY revenue_daily DESC;				-- 일별 매출 내림차순 정렬