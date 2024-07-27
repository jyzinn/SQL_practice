USE olist_project;

-- EDA

-- 지역별 유저 조회
SELECT customer_state,												-- 고객의 주
       customer_city,												-- 고객의 도시
       COUNT(*) AS customer_cnt,									-- 해당 주/도시의 고객 수
       CONCAT(
			   COUNT(*) / (SELECT COUNT(*) FROM customers) * 100
               , '%') AS user_ratio,								-- 지역별 유저 수 / 전체 유저 수로 유저 비율 조회
       GROUPING(customer_state) AS grand_total,						-- 총계인지 표시
       GROUPING(customer_city) AS state_total						-- 소계인지 표시
FROM customers
GROUP BY customer_state, customer_city WITH ROLLUP					-- 주(state)와 도시(city)별로 그룹화하고 ROLLUP을 사용하여 소계를 계산
ORDER BY customer_state, customer_city;								-- 주와 도시별로 정렬

-- state별 유저 비율 조회
SELECT	customer_state,
		CONCAT(
			   COUNT(*) / (SELECT COUNT(*) FROM customers) * 100
               , '%') AS user_ratio
FROM	customers
GROUP BY customer_state
ORDER BY COUNT(*) / (SELECT COUNT(*) FROM customers) DESC;

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

-- payment type별 평균 value
SELECT	payment_type,
		ROUND(AVG(payment_value), 2) AS avg_value
FROM	order_payments
GROUP BY payment_type;

-- 카테고리별 평균 가격
SELECT	B.product_category_name,
        ROUND(AVG(A.price), 2) AS category_avg_price,
        ROUND(AVG(A.freight_value), 2) AS category_avg_freight_value
FROM	order_items AS A
INNER JOIN products AS B
ON		A.product_id = B.product_id
GROUP BY B.product_category_name
ORDER BY B.product_category_name;

-- 유저별 가장 최근 거래 시점 조회
SELECT	A.customer_unique_id,
		MAX(B.order_purchase_timestamp)
FROM	customers AS A
INNER JOIN orders AS B
ON		A.customer_id = B.customer_id
GROUP BY A.customer_unique_id;

-- RFM 분석

-- Recency
SELECT	customer_unique_id,
		DATEDIFF(CURRENT_DATE(), MAX(order_purchase_timestamp)) AS recency	-- 오늘 날짜와 가장 최근 구매 일자의 차이 계산하여 recency 구하기
FROM	orders AS A
INNER JOIN customers AS B
ON		A.customer_id = B.customer_id
WHERE	order_status = 'delivered'											-- 배송 완료된 정상 구매 건만 조회
GROUP BY customer_unique_id;

WITH recency_scores AS (																		-- recency score CTE
						SELECT	customer_unique_id,
                        DATEDIFF(CURRENT_DATE(), MAX(order_purchase_timestamp)) AS recency		-- 오늘 날짜와 가장 최근 구매 일자의 차이 계산하여 recency 구하기
                        FROM	orders AS A
                        INNER JOIN customers AS B
                        ON		A.customer_id = B.customer_id
                        WHERE	order_status = 'delivered'										-- 배송 완료된 정상 구매 건만 조회
                        GROUP BY customer_unique_id),
ntile_recency AS (																				-- 5개의 그룹으로 recency Group 정의
				  SELECT	customer_unique_id,
							recency,
                            NTILE(5) OVER (ORDER BY recency DESC) AS recency_group				-- recency를 내림차순으로 정렬 (recency가 낮을수록 높은 점수 부여)
				  FROM		recency_scores)
                  
-- 각 recency_group의 recency 범위 확인
SELECT	recency_group,
		MIN(recency) AS min_recency,
        MAX(recency) AS max_recency
FROM	ntile_recency
GROUP BY recency_group
ORDER BY recency_group;

-- Frequency
SELECT	customer_unique_id,
		COUNT(DISTINCT order_id) AS frequency	-- 구매 횟수로 frequency 구하기
FROM	orders AS A
INNER JOIN customers AS B
ON		A.customer_id = B.customer_id
WHERE	order_status = 'delivered'				-- 배송 완료된 정상 구매 건만 조회
GROUP BY customer_unique_id;

WITH frequency_scores AS (															-- frequency score CTE
						  SELECT	customer_unique_id,
									COUNT(DISTINCT order_id) AS frequency			-- 구매 횟수로 frequency 구하기
						  FROM		orders AS A
                          INNER JOIN customers AS B
                          ON		A.customer_id = B.customer_id
                          WHERE		order_status = 'delivered'						-- 배송 완료된 정상 구매 건만 조회
                          GROUP BY customer_unique_id),
ntile_frequency AS (																-- 5개의 그룹으로 frequency_group 정의
					SELECT	customer_unique_id,
							frequency,
                            NTILE(5) OVER (ORDER BY frequency) AS frequency_group
					FROM	frequency_scores)
                    
-- 각 frequency_group의 frequency 범위 확인                    
SELECT	frequency_group,
		MIN(frequency) AS min_frequency,
        MAX(frequency) AS max_frequency
FROM	ntile_frequency
GROUP BY frequency_group
ORDER BY frequency_group;

/*
대부분의 고객이 1회만 구매한 것으로 보이며, 구매 빈도가 편향되어 있는 것으로 해석
많은 고객이 재구매를 하지 않으며, 소수의 고객만이 여러 번 구매하는 경향 보임
| frequency_group | min_frequency | max_frequency |
|-----------------|---------------|---------------|
|        1        |       1       |       1       |
|        2        |       1       |       1       |
|        3        |       1       |       1       |
|        4        |       1       |       1       |
|        5        |       1       |       15      |
*/

-- 구매 빈도별 고객 수 count하여 분포 확인
SELECT	frequency, COUNT(*) AS user_count
FROM	(
		SELECT COUNT(DISTINCT order_id) AS frequency
        FROM orders AS A
        INNER JOIN customers AS B ON A.customer_id = B.customer_id
        WHERE order_status = 'delivered'
        GROUP BY customer_unique_id
        ) AS subquery
GROUP BY frequency
ORDER BY frequency DESC;

-- 현재 frequency_score는 편향된 점수로 고객 분석에 유효하지 않기에 재정의
WITH frequency_score AS (
						SELECT	customer_unique_id,		        -- 고객별로 고유한 구매 주문의 수를 계산하여 구매 빈도(frequency) 구하기
								COUNT(DISTINCT order_id) AS num_orders
						FROM	orders AS A
                        INNER JOIN customers AS B
                        ON		A.customer_id = B.customer_id
                        WHERE	order_status = 'delivered' -- 배송 완료된 정상 구매 건만 조회
                        GROUP BY customer_unique_id
)

SELECT	customer_unique_id,
		CASE
			WHEN num_orders = 1 THEN 1
			WHEN num_orders = 2 THEN 2
			WHEN num_orders = 3 THEN 3
			WHEN num_orders = 4 THEN 4
			ELSE 5
		END AS frequency
FROM	frequency_score;

-- Monetary
SELECT	A.customer_id,
		SUM(B.price) AS monetary		-- 고객이 구매한 가격의 총합을 계산하여 monetary 구하기
FROM	orders AS A
INNER JOIN order_items AS B
ON		A.order_id = B.order_id
WHERE	order_status = 'delivered'		-- 배송 완료된 정상 구매 건만 조회
GROUP BY customer_id;

WITH monetary_scores AS (									-- monetary score CTE
						 SELECT	A.customer_id,
								SUM(B.price) AS monetary	-- 고객이 구매한 가격의 총합을 계산하여 monetary 구하기
						 FROM	orders AS A
                         INNER JOIN order_items AS B
                         ON		A.order_id = B.order_id
                         WHERE	order_status = 'delivered'	-- 배송 완료된 정상 구매 건만 조회
                         GROUP BY customer_id),
ntile_monetary AS ( 										-- 5개의 그룹으로 monetary_group 정의
				   SELECT	customer_id,
							monetary,
                            NTILE(5) OVER (ORDER BY monetary) AS monetary_group
					FROM	monetary_scores)

-- 각 monetary_group의 monetary 범위 확인                    
SELECT	monetary_group,
		MIN(monetary) AS min_monetary,
        MAX(monetary) AS max_monetary
FROM	ntile_monetary
GROUP BY monetary_group
ORDER BY monetary_group;

-- 고객별 RFM score 계산
SELECT	customer_unique_id,
		NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
        CASE
			WHEN frequency = 1 THEN 1
            WHEN frequency = 2 THEN 2
            WHEN frequency = 3 THEN 3
            WHEN frequency = 4 THEN 4
            ELSE 5
		END AS F_score,
        NTILE(5) OVER (ORDER BY monetary) AS M_score
FROM	(
		 SELECT	customer_unique_id,
				DATEDIFF(CURRENT_DATE(), MAX(order_purchase_timestamp)) AS recency,
                COUNT(DISTINCT A.order_id) AS frequency,
                SUM(price) AS monetary
		 FROM	orders AS A
         INNER JOIN customers AS B
         ON		A.customer_id = B.customer_id
         INNER JOIN order_items AS C
         ON		A.order_id = C.order_id
         WHERE	order_status = 'delivered'
         GROUP BY customer_unique_id
         ) AS rfm_scores;
         
-- RFM segmentation
SELECT	customer_unique_id,
		R_score,
        F_score,
        M_score,
		CASE
			WHEN R_score IN (5, 4) AND F_score IN (5, 4) AND M_score IN (5, 4) THEN 'VIPs'
            WHEN R_score = 4 AND F_score = 3 AND M_score IN (5, 4, 3) THEN 'Loyal Customers'
            WHEN R_score = 3 AND F_score = 5 AND M_score = 5 THEN 'Potential Loyalist'
            WHEN R_score = 5 AND F_score IN (3, 2) AND M_score IN (5, 4, 3) THEN 'Potential Loyalist'
            WHEN R_score = 4 AND F_score IN (4, 3) AND M_score IN (5, 4, 3) THEN 'Potential Loyalist'
            WHEN R_score = 5 AND F_score = 1 THEN 'New Customers'
            WHEN R_score = 4 AND F_score IN (2, 1) THEN 'Promising'
            WHEN R_score = 3 AND F_score IN (4, 3) THEN 'Need Attention'
            WHEN R_score = 2 AND F_score = 3 THEN 'About To Sleep'
            WHEN R_score = 1 AND F_score = 5 AND M_score = 5 THEN 'Cannot Lose Them But Losing'
            WHEN R_score = 2 AND F_score = 4 AND M_score IN (4, 3, 2) THEN 'At Risk'
            WHEN R_score = 3 AND F_score IN (2, 1) THEN 'Hibernating Customers'
            WHEN R_score = 1 AND F_score = 1 AND M_score IN (2, 3, 4, 5) THEN 'Losing But Engaged'
            WHEN R_score <= 2 AND F_score = 1 AND M_score = 1 THEN 'Lost Customers'
            ELSE 'others'
		END AS segment
FROM	(
		 SELECT	customer_unique_id,
				NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
                CASE
					WHEN frequency = 1 THEN 1
                    WHEN frequency = 2 THEN 2
                    WHEN frequency = 3 THEN 3
                    WHEN frequency = 4 THEN 4
                    ELSE 5
				END AS F_score,
                NTILE(5) OVER (ORDER BY monetary) AS M_score
		FROM	(
				 SELECT	customer_unique_id,
						DATEDIFF(CURRENT_DATE(), MAX(order_purchase_timestamp)) AS recency,
                        COUNT(DISTINCT A.order_id) AS frequency,
                        SUM(price) AS monetary
				FROM	orders AS A
                INNER JOIN customers AS B
                ON		A.customer_id = B.customer_id
                INNER JOIN order_items AS C
                ON		A.order_id = C.order_id
                WHERE	order_status = 'delivered'
                GROUP BY customer_unique_id
                ) AS rfm_scores
		) AS rfm_segment;
        
-- 각 segmentation별 유저 수, 비율 조회
WITH rfm_segment AS (
					 SELECT	customer_unique_id,
							CASE
								WHEN R_score IN (5, 4) AND F_score IN (5, 4) AND M_score IN (5, 4) THEN 'VIPs'
								WHEN R_score = 4 AND F_score = 3 AND M_score IN (5, 4, 3) THEN 'Loyal Customers'
								WHEN R_score = 3 AND F_score = 5 AND M_score = 5 THEN 'Potential Loyalist'
								WHEN R_score = 5 AND F_score IN (3, 2) AND M_score IN (5, 4, 3) THEN 'Potential Loyalist'
								WHEN R_score = 4 AND F_score IN (4, 3) AND M_score IN (5, 4, 3) THEN 'Potential Loyalist'
								WHEN R_score = 5 AND F_score = 1 THEN 'New Customers'
								WHEN R_score = 4 AND F_score IN (2, 1) THEN 'Promising'
								WHEN R_score = 3 AND F_score IN (4, 3) THEN 'Need Attention'
								WHEN R_score = 2 AND F_score = 3 THEN 'About To Sleep'
								WHEN R_score = 1 AND F_score = 5 AND M_score = 5 THEN 'Cannot Lose Them But Losing'
								WHEN R_score = 2 AND F_score = 4 AND M_score IN (4, 3, 2) THEN 'At Risk'
								WHEN R_score = 3 AND F_score IN (2, 1) THEN 'Hibernating Customers'
								WHEN R_score = 1 AND F_score = 1 AND M_score IN (2, 3, 4, 5) THEN 'Losing But Engaged'
								WHEN R_score <= 2 AND F_score = 1 AND M_score = 1 THEN 'Lost Customers'
								ELSE 'others'
							END AS segment
					FROM	(
							 SELECT	customer_unique_id,
									NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
                                    CASE
										WHEN frequency = 1 THEN 1
                                        WHEN frequency = 2 THEN 2
                                        WHEN frequency = 3 THEN 3
                                        WHEN frequency = 4 THEN 4
                                        ELSE 5
									END AS F_score,
                                    NTILE(5) OVER (ORDER BY monetary) AS M_score
							 FROM	(
									 SELECT	customer_unique_id,
											DATEDIFF(CURRENT_DATE(), MAX(order_purchase_timestamp)) AS recency,
                                            COUNT(DISTINCT A.order_id) AS frequency,
                                            SUM(price) AS monetary
									 FROM	orders AS A
                                     INNER JOIN customers AS B
                                     ON		A.customer_id = B.customer_id
                                     INNER JOIN order_items AS C
                                     ON		A.order_id = C.order_id
                                     WHERE	order_status = 'delivered'
                                     GROUP BY customer_unique_id
									) AS rfm_scores
							) AS rfm_segment
					)
SELECT	segment,
		COUNT(*) AS user_count,
        CONCAT(ROUND(COUNT(*) / (SELECT COUNT(*) FROM rfm_segment) * 100, 2), '%') AS user_ratio
FROM	rfm_segment
GROUP BY segment
ORDER BY user_count DESC;