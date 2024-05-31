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

/*
solvesql 버뮤다 삼각지대에 들어가버린 택배
https://solvesql.com/problems/shipment-in-bermuda/
*/

SELECT  DATE(order_delivered_carrier_date) AS delivered_carrier_date,	-- 택배사 도착 날짜만 추출
        COUNT(*) AS orders												-- 일자별 주문 수 계산
FROM    olist_orders_dataset
WHERE   order_delivered_carrier_date LIKE '2017-01%'					-- 2017년 1월에 택배사에 전달되었지만,
        AND order_delivered_customer_date IS NULL						-- 배송 완료되지 않은 주문 필터링
GROUP BY delivered_carrier_date											
ORDER BY delivered_carrier_date;										-- 일자 오름차순 정렬