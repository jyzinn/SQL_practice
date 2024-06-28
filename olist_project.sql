USE olist_project;

-- 지역별 유저 분포 조회
SELECT customer_state,								-- 고객의 주
       customer_city,								-- 고객의 도시
       COUNT(*) AS customer_cnt,					-- 해당 주/도시의 고객 수
       GROUPING(customer_state) AS grand_total,		-- 총계인지 표시
       GROUPING(customer_city) AS state_total		-- 소계인지 표시
FROM customers
GROUP BY customer_state, customer_city WITH ROLLUP	-- 주(state)와 도시(city)별로 그룹화하고 ROLLUP을 사용하여 소계를 계산
ORDER BY customer_state, customer_city;				-- 주와 도시별로 정렬

-- 지역별 유저의 평균 리뷰 점수 조회
SELECT	A.customer_state,
		A.customer_city,	
        COUNT(*) AS review_cnt,
        AVG(C.review_score) AS avg_review_score,
		GROUPING(customer_state) AS grand_total,		-- 총계인지 표시
		GROUPING(customer_city) AS state_total			-- 소계인지 표시
FROM	customers AS A
INNER JOIN orders AS B
ON		A.customer_id = B.customer_id
INNER JOIN order_reviews AS C
ON		B.order_id = C.order_id
GROUP BY A.customer_state, A.customer_city WITH ROLLUP	-- 주(state)와 도시(city)별로 그룹화하고 ROLLUP을 사용하여 소계를 계산
ORDER BY A.customer_state, A.customer_city;				-- 주와 도시별로 정렬

-- 배송일 예측 성공/실패 조회
SELECT	YEAR(order_purchase_timestamp) AS purchase_year,   																		-- 구매 연도
		MONTH(order_purchase_timestamp) AS purchase_month, 																		-- 구매 월
        COUNT(DISTINCT order_id) AS total_purchase,																				-- 전체 구매 수
        COUNT(DISTINCT CASE WHEN order_estimated_delivery_date >= order_delivered_customer_date THEN order_id END) AS success, 	-- 성공 건수
        COUNT(DISTINCT CASE WHEN order_estimated_delivery_date < order_delivered_customer_date THEN order_id END) AS fail, 		-- 실패 건수
        CONCAT(ROUND(100.0 * COUNT(DISTINCT CASE WHEN order_estimated_delivery_date >= order_delivered_customer_date THEN order_id END) 
               / COUNT(DISTINCT order_id), 2), '%')AS success_rate,																-- 예측 성공율
        GROUPING(YEAR(order_purchase_timestamp)) AS grand_total, 																-- 총계 여부 표시
        GROUPING(MONTH(order_purchase_timestamp)) AS year_total 																-- 년도별 소계 표시
FROM    orders
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp) WITH ROLLUP 											-- 연도와 월별로 그룹화하고 ROLLUP을 사용하여 소계를 계산
ORDER BY purchase_year, purchase_month; 																						-- 연도와 월별로 정렬
