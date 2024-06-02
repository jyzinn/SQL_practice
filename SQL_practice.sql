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

/*
solvesql 쇼핑몰의 일일 매출액
https://solvesql.com/problems/olist-daily-revenue/
*/

SELECT  DATE(A.order_purchase_timestamp) AS dt,				-- 구매 날짜만 추출
        ROUND(SUM(B.payment_value),2) AS revenue_daily		-- 일자별 총 결제 금액을 소수점 둘째자리까지 출력
FROM    olist_orders_dataset AS A
INNER JOIN olist_order_payments_dataset AS B				
ON      A.order_id = B.order_id								-- 두 테이블을 order_id 열을 기준으로 join
WHERE   dt >= '2018-01-01'									-- dt 열이 2018-01-01 이후인 열만 선택
GROUP BY dt
ORDER BY dt;

/*
solvesql 점검이 필요한 자전거 찾기
https://solvesql.com/problems/inspection-needed-bike/
*/

-- 1번 풀이
SELECT bike_id
FROM (
      SELECT bike_id
      FROM rental_history
      WHERE rent_at LIKE '2021-01%'		-- 2021년 1월 렌트한 자전거
      GROUP BY bike_id					
      HAVING SUM(distance) >= 50000		-- bike_id별 총 주행 거리가 50km 이상인 bike_id만 추출
      ) AS filtered_bikes;
      
-- 2번 풀이
SELECT  DISTINCT bike_id								-- 중복된 bike_id 제거
FROM    rental_history
WHERE   bike_id in (
                    SELECT  bike_id
                    FROM    rental_history
                    WHERE   rent_at LIKE '2021-01%'		-- 2021년 1월 렌트한 자전거
                    GROUP BY bike_id
                    HAVING  SUM(distance) >= 50000		-- bike_id별 총 주행 거리가 50km 이상인 bike_id만 추출
                    );