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
                    
/*
solvesql 레스토랑의 대목
https://solvesql.com/problems/high-season-of-restaurant/
*/

SELECT  *
FROM    tips
WHERE   day IN (
                SELECT  day
                FROM    tips
                GROUP BY day
                HAVING  SUM(total_bill) >= 1500		-- 일별 총 결제 금액이 1500 이상인 날짜를 선택
                )
                
                
/*
solvesql 레스토랑의 요일별 VIP
https://solvesql.com/problems/restaurant-vip/
*/

SELECT  *
FROM    tips
WHERE   total_bill IN (
                       SELECT MAX(total_bill) 		-- 일별 가장 높은 금액의 결제 내역 선택
                       FROM   tips
                       GROUP BY day
                       );
                       
/*
leetcode 512. Game Play Analysis II
https://leetcode.com/problems/game-play-analysis-ii/description/
*/

SELECT	player_id,
		device_id
FROM	activity
WHERE	(player_id, event_date) IN (
									SELECT	player_id,
											MIN(event_date) AS first_event_date		-- player_id별 최초 event_date 추출
									FROM	activity
                                    GROUP BY player_id
                                    );

/*
solvesql 복수 국적 메달 수상한 선수 찾기
https://solvesql.com/problems/multiple-medalist/
*/

SELECT  a.name
FROM    records AS r
INNER JOIN athletes AS a ON r.athlete_id = a.id
INNER JOIN games    AS g ON r.game_id = g.id
WHERE   r.medal IS NOT NULL							-- 메달 수상 이력이 있는 선수만
        AND g.year >= 2000							-- 2000년 이후의 기록만
GROUP BY a.id
HAVING  COUNT(DISTINCT r.team_id) >= 2				-- 국적이 2개 이상인 선수만
ORDER BY 1;

/*
solvesql 할부는 몇 개월로 해드릴까요
https://solvesql.com/problems/installment-month/
*/

SELECT  payment_installments,
        COUNT(DISTINCT order_id) AS order_count,
        MIN(payment_value) AS min_value,
        MAX(payment_value) AS max_value,
        AVG(payment_value) AS avg_value
FROM    olist_order_payments_dataset
WHERE   payment_type == 'credit_card'
GROUP BY payment_installments;

/*
solvesql 지역별 주문의 특징
https://solvesql.com/problems/characteristics-of-orders/
*/

SELECT  region AS Region,
        COUNT(DISTINCT(CASE WHEN category='Furniture' THEN order_id END)) AS 'Furniture',
        COUNT(DISTINCT(CASE WHEN category='Office Supplies' THEN order_id END)) AS 'Office Supplies',
        COUNT(DISTINCT(CASE WHEN category='Technology' THEN order_id END)) AS 'Technology'
FROM    records
GROUP BY Region
ORDER BY Region;

/*
solvesql 배송 예정일 예측 성공과 실패
https://solvesql.com/problems/estimated-delivery-date/
*/

SELECT  DATE(order_purchase_timestamp) AS purchase_date,
		-- 예상 배송 날짜가 실제 배송 날짜보다 크거나 같을 때 (배송 예정 시각 안에 도착)
        COUNT(DISTINCT CASE WHEN order_estimated_delivery_date >= order_delivered_customer_date THEN order_id END) AS success,
        -- 예상 배송 날짜가 실제 배송 날짜보다 작을 때 (배송 예정 시각 이후에 도착)
        COUNT(DISTINCT CASE WHEN order_estimated_delivery_date <  order_delivered_customer_date THEN order_id END) AS fail
FROM    olist_orders_dataset
WHERE   purchase_date LIKE '2017-01%'
GROUP BY purchase_date
ORDER BY purchase_date;

/*
solvesql 쇼핑몰의 일일 매출액과 ARPPU
https://solvesql.com/problems/daily-arppu/
*/

SELECT  DATE(o.order_purchase_timestamp) AS dt,
        COUNT(DISTINCT o.customer_id) AS pu,										-- 해당 일자의 결제 고객 수
        ROUND(SUM(p.payment_value),2) AS revenue_daily,								-- 해당 일자의 매출액
        ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.customer_id), 2) AS arppu		-- 해당 일자의 arppu
FROM    olist_orders_dataset AS o
INNER JOIN olist_order_payments_dataset AS p
ON      o.order_id = p.order_id
WHERE   o.order_purchase_timestamp >= '2018-01-01'									-- 2018년 1월 1일 이후 매출
GROUP BY dt												
ORDER BY dt;

/*
ssolvesql 멘토링 짝꿍 리스트
https://solvesql.com/problems/mentor-mentee-list/
*/

SELECT  A.employee_id AS mentee_id,
        A.name AS mentee_name,
        B.employee_id AS mentor_id,
        B.name AS mentor_name
FROM    employees AS A
CROSS JOIN employees AS B
WHERE   A.join_date BETWEEN '2021-10-01' AND '2021-12-31'	-- 2021년 12월 31일 기준 3개월 이내 입사한 인원 == 멘티
        AND B.join_date <= '2019-12-31'						-- 멘토는 재직한지 2년 이상
        AND A.department != B.department					-- 멘티와 멘토는 서로 다른 부서
ORDER BY mentee_id, mentor_id;

/*
solvesql 작품이 없는 작가 찾기
https://solvesql.com/problems/artists-without-artworks/
*/

SELECT  A.artist_id,
        A.name
FROM    artists AS A
LEFT JOIN artworks_artists AS B
ON      A.artist_id = B.artist_id
WHERE   A.death_year IS NOT NULL		-- 살아있지 않은 작가
        AND B.artist_id IS NULL;		-- MoMA에 작품이 등록되지 않은 작가
        
/*
solvesql 가구 판매의 비중이 높았던 날 찾기
https://solvesql.com/problems/day-of-furniture/
*/

SELECT  order_date,
		-- 해당 일자의 Furniture 카테고리 주문 수
        COUNT(DISTINCT CASE WHEN category = 'Furniture' THEN order_id END) AS furniture,	
        -- 해당 일자의 Furniture 카테고리 주문 비율
        ROUND(
            (COUNT(DISTINCT CASE WHEN category = 'Furniture' THEN order_id END) * 1.0 / COUNT(DISTINCT order_id)) * 100, 2
        ) AS furniture_pct
FROM    records
GROUP BY order_date
HAVING  COUNT(DISTINCT order_id) >= 10	-- 하루 10건 이상의 주문이 발생한 날
        AND furniture_pct >= 40			-- Furniture 카테고리 주문 비율이 40% 이상인 날
ORDER BY furniture_pct DESC;

/*
solvesql 레스토랑 요일 별 구매금액 Top 3 영수증
https://solvesql.com/problems/top-3-bill/
*/

WITH RankedBills AS (
                     SELECT day,
                             time,
                             sex,
                             total_bill,
                             DENSE_RANK() OVER (PARTITION BY day ORDER BY total_bill DESC) AS rank	-- 중복 순위 구하기
                     FROM    tips
                     )
SELECT  day,
        time,
        sex,
        total_bill
FROM    RankedBills
WHERE   rank <= 3;		-- rank가 3위 이상인 경우만

/*
LeetCode 608. Tree Node
https://leetcode.com/problems/tree-node/description/
*/

SELECT  id,
        CASE 
            WHEN p_id IS NULL THEN 'Root'						-- p_id가 없을 경우 Root
            WHEN id IN (SELECT p_id FROM tree) then 'Inner'		-- p_id가 있고 다른 노드의 p_id일 경우 Inner
            ELSE 'Leaf'											-- p_id가 있지만 다른 노드의 p_id가 아닐 경우 Leaf
        END AS type
FROM    tree;