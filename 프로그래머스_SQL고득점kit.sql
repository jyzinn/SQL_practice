-- SELECT
/*
조건에 맞는 도서 리스트 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/144853
*/
SELECT  book_id,
		-- 출력 요구 형식에 맞추어 포맷팅
        DATE_FORMAT(published_date, '%Y-%m-%d') AS published_date
FROM    book
		-- 2021년에 출력된 인문 카테고리 도서
WHERE   published_date LIKE '2021%'
        AND category = '인문'
		-- pusblised_date로 오름차순 정렬
ORDER BY published_date;

/*
조건에 부합하는 중고거래 댓글 조회하기
https://school.programmers.co.kr/learn/courses/30/lessons/164673
*/
SELECT  A.title,
        A.board_id,
        B.reply_id,
        B.writer_id,
        B.contents,
        -- 출력 요구 형식에 맞추어 포맷팅
        DATE_FORMAT(B.created_date, '%Y-%m-%d') AS created_date
FROM    used_goods_board AS A
		-- 게시글 ID를 기준으로 JOIN
INNER JOIN used_goods_reply AS B
ON      A.board_id = B.board_id
		-- 2022년 10월에 작성된 게시글만 조회
WHERE   A.created_date LIKE '2022-10%'
ORDER BY B.created_date, A.title;

/*
3월에 태어난 여성 회원 목록 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/131120
*/
SELECT  member_id,
        member_name,
        gender,
        -- 출력 요구 형식에 맞추어 포맷팅
        DATE_FORMAT(date_of_birth, '%Y-%m-%d') AS date_of_birth
FROM    member_profile
		-- 생일이 3월인 여성 회원, 전화번호가 NULL이 아닌 경우만 조회
WHERE   MONTH(date_of_birth) = 3
        AND gender = 'w'
        AND tlno IS NOT NULL
ORDER BY member_id;

/*
흉부외과 또는 일반외과 의사 목록 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/132203
*/
SELECT  dr_name,
        dr_id,
        mcdp_cd,
        -- 출력 요구 형식에 맞추어 포맷팅
        DATE_FORMAT(hire_ymd, '%Y-%m-%d') AS hire_ymd
FROM    doctor
		-- 진료과가 흉부외과(CS)이거나 일반외과(GS)인 의사만 조회
WHERE   mcdp_cd IN ('CS', 'GS')
ORDER BY hire_ymd DESC, dr_name;

/*
과일로 만든 아이스크림 고르기
https://school.programmers.co.kr/learn/courses/30/lessons/133025
*/
SELECT  A.flavor
FROM    first_half AS A
		-- flavor로 JOIN
INNER JOIN icecream_info AS B
ON      A.flavor = B.flavor
		-- 총 주문량이 3,000보다 높은 주 성분이 과일인 아이스크림 조회
WHERE   total_order > 3000
        AND ingredient_type = 'fruit_based'
ORDER BY total_order DESC;

/*
평균 일일 대여 요금 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/151136
*/
		-- 평균 일일 대여 요금 소수 첫번째 자리에서 반올림
SELECT  ROUND(AVG(daily_fee)) AS average_fee
FROM    car_rental_company_car
		-- 자동차 종류가 SUV인 경우만 조회
WHERE   car_type = 'SUV';

/*
인기있는 아이스크림
https://school.programmers.co.kr/learn/courses/30/lessons/133024
*/
SELECT  flavor
FROM    first_half
ORDER BY total_order DESC, shipment_id;

/*
강원도에 위치한 생산공장 목록 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/131112
*/
SELECT  factory_id,
        factory_name,
        address
FROM    food_factory
-- 강원도에 위치한 공장 조회
WHERE   address LIKE '강원도%'
ORDER BY factory_id;

/*
12세 이하인 여자 환자 목록 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/132201
*/
SELECT  pt_name,
        pt_no,
        gend_cd,
        age,
        -- 전화번호가 없는 경우 'NONE' 출력
        IFNULL(tlno, 'NONE') AS tlno
FROM    patient
		-- 12세 이하인 여자 환자만 조회
WHERE   age <= 12
        AND gend_cd = 'w'
ORDER BY age DESC, pt_name;

/*
서울에 위치한 식당 목록 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/131118
*/
SELECT  A.rest_id,
        A.rest_name,
        A.food_type,
        A.favorites,
        A.address,
        ROUND(AVG(B.review_score),2) AS score	-- 평균 점수는 소수 세번째 자리에서 반올림
FROM    rest_info AS A
INNER JOIN rest_review AS B
ON      A.rest_id = B.rest_id					-- rest_id를 key로 join
WHERE   address LIKE '서울%'						-- 서울에 위치한 식당만 조회
GROUP BY rest_id								-- rest_id별 평균 점수 조회를 위해 group
ORDER BY score DESC, favorites DESC;

/*
재구매가 일어난 상품과 회원 리스트 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/131536
*/
SELECT  user_id,
        product_id
FROM    online_sale
GROUP BY user_id, product_id			-- 재구매 판단을 위해 group
HAVING  COUNT(sales_date) >= 2			-- sales_date가 2 이상인 경우만 조회 (재구매)
ORDER BY user_id, product_id DESC;

/*
모든 레코드 조회하기
https://school.programmers.co.kr/learn/courses/30/lessons/59034
*/
SELECT  *
FROM    animal_ins
ORDER BY animal_id;

/*
오프라인/온라인 판매 데이터 통합하기
https://school.programmers.co.kr/learn/courses/30/lessons/131537
*/
SELECT  DATE_FORMAT(sales_date, '%Y-%m-%d') AS sales_date,	-- 출력 요구 형식에 맞추어 포맷팅
        product_id,
        user_id,
        sales_amount
FROM    online_sale
WHERE   sales_date LIKE '2022-03%'							-- 22년 3월 판매 데이터만 조회

UNION ALL

SELECT  DATE_FORMAT(sales_date, '%Y-%m-%d') AS sales_date,	-- 출력 요구 형식에 맞추어 포맷팅
        product_id,
        NULL AS user_id,									-- offline_sale에는 user_id가 없기에 null로 처리
        sales_amount
FROM    offline_sale
WHERE   sales_date LIKE '2022-03%'							-- 22년 3월 판매 데이터만 조회

ORDER BY sales_date, product_id, user_id;

/*
역순 정렬하기
https://school.programmers.co.kr/learn/courses/30/lessons/59035
*/
SELECT  name,
        datetime
FROM    animal_ins
ORDER BY animal_id DESC;

/*
아픈 동물 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/59036#fn1
*/
SELECT  animal_id,
        name
FROM    animal_ins
WHERE   intake_condition = 'Sick'
ORDER BY animal_id;

/*
어린 동물 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/59037
*/
SELECT  animal_id,
        name
FROM    animal_ins
WHERE   intake_condition != 'Aged'
ORDER BY animal_id;

/*
동물의 아이디와 이름
https://school.programmers.co.kr/learn/courses/30/lessons/59403
*/
SELECT  animal_id,
        name
FROM    animal_ins
ORDER BY animal_id;

/*
여러 기준으로 정렬하기
https://school.programmers.co.kr/learn/courses/30/lessons/59404
*/
SELECT  animal_id,
        name,
        datetime
FROM    animal_ins
ORDER BY name, datetime DESC;

/*
상위 n개 레코드
https://school.programmers.co.kr/learn/courses/30/lessons/59405
*/
SELECT  name
FROM    animal_ins
WHERE   datetime = (
                    SELECT  MIN(datetime)
                    FROM    animal_ins
				   );
                   
SELECT	name 
FROM 	animal_ins
ORDER BY datetime
LIMIT 	1;

/*
조건에 맞는 회원수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/131535
*/
SELECT  COUNT(user_id) AS users
FROM    user_info
WHERE   joined LIKE '2021%'
        AND age BETWEEN 20 AND 29;
        
/*
업그레이드 된 아이템 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/273711
*/
SELECT  A.item_id,
        A.item_name,
        A.rarity
FROM    item_info AS A
INNER JOIN item_tree AS B
ON      A.item_id = B.item_id
WHERE   B.parent_item_id IN (							-- parent_item의 희귀도가 'RARE'인 item
                            SELECT  item_id
                            FROM    item_info
                            WHERE   rarity = 'RARE'		-- 아이템 희귀도가 'RARE'인 아이템 조회
                            )
ORDER BY item_id DESC;

/*
Python 개발자 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/276013
*/
SELECT  id,
        email,
        first_name,
        last_name
FROM    developer_infos
WHERE   'Python' IN (skill_1, skill_2, skill_3)		-- skill 중 'Python'이 포함된 경우만 조회
ORDER BY id;

/*
조건에 맞는 개발자 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/276034
*/
SELECT  id,
        email,
        first_name, 
        last_name
FROM    developers
WHERE   skill_code & (									-- 비트 마스크와 skill_code를 비트 연산하여 'Python' 또는 'C#'을 보유한 개발자를 필터링
                     SELECT SUM(code)					-- 비트 마스크 생성
                     FROM   skillcodes
                     WHERE  name IN ('Python','C#')
                     )
ORDER BY id;

/*
잔챙이 잡은 수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/293258
*/
SELECT  COUNT(id) AS fish_count
FROM    fish_info
WHERE   length IS NULL;				-- 길이가 10cm 이하인 물고기는 length가 NULL

/*
가장 큰 물고기 10마리 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/298517
*/
SELECT  id,
        length
FROM    fish_info
ORDER BY length DESC, id
LIMIT   10;

/*
특정 물고기를 잡은 총 수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/298518
*/
SELECT  COUNT(*) AS fish_count
FROM    fish_info AS A
INNER JOIN fish_name_info AS B
ON      A.fish_type = B.fish_type
WHERE   fish_name IN ('BASS', 'SNAPPER');	-- 'BASS'나 'SNAPPER'를 잡은 것만 조회

/*
대장균들의 자식의 수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/299305
*/
SELECT  A.id,
        COUNT(B.id) AS child_count
FROM    ecoli_data AS A					-- 부모 id를 나타내는 테이블
LEFT JOIN ecoli_data AS B				-- 자식 id를 나타내는 테이블
ON      A.id = B.parent_id				-- 부모-자식 관계 정의
GROUP BY A.id
ORDER BY A.id;

/*
대장균의 크기에 따라 분류하기 1
https://school.programmers.co.kr/learn/courses/30/lessons/299307
*/
SELECT  id,
        CASE
            WHEN size_of_colony <= 100 THEN 'LOW'		-- 크기가 100 이하면 'LOW'
            WHEN size_of_colony <= 1000 THEN 'MEDIUM'	-- 크기가 1000 이하면 'MEDIUM'
            ELSE 'HIGH'									-- 그 외 크기는 'HIGH'
        END AS size
FROM    ecoli_data
ORDER BY id;

/*
특정 형질을 가지는 대장균 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/301646
*/
SELECT  COUNT(*) AS count
FROM    ecoli_data
WHERE   genotype & 2 = 0								-- 2번 형질을 보유하지 않음 '0010'
		AND (genotype & 1 != 0 OR genotype & 4 != 0);	-- 1번 형질을 보유하거나 3번 형질을 보유함 '0001' or '0100'
        
/*
부모의 형질을 모두 가지는 대장균 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/301647
*/
SELECT  A.id,
        A.genotype,
        B.genotype AS parent_genotype
FROM    ecoli_data AS A							-- 부모 id를 나타내는 테이블
LEFT JOIN ecoli_data AS B						-- 자식 id를 나타내는 테이블
ON      A.id = B.parent_id						-- 부모-자식 관계 정의
WHERE   A.genotype & B.genotype = B.genotype	-- 비트 연산으로 자식이 부모의 모든 형질을 보유한 것만 조회
ORDER BY id;

/*
대장균의 크기에 따라 분류하기 2
https://school.programmers.co.kr/learn/courses/30/lessons/301649
*/
SELECT  id,
        CASE
            WHEN quartile  = 1 THEN 'CRITICAL'
            WHEN quartile  = 2 THEN 'HIGH'
            WHEN quartile  = 3 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS colony_name
FROM    (
        SELECT  id,
                NTILE(4) OVER(ORDER BY size_of_colony DESC) AS quartile		-- 개체 크기 내림차순으로 사분위로 나눔
        FROM    ecoli_data
        ) AS ranked_data
ORDER BY id;

WITH ranked_data AS(
                    SELECT  id,
                            NTILE(4) OVER (ORDER BY size_of_colony DESC) AS quartile	-- 개체 크기 내림차순으로 사분위로 나눔
                    FROM    ecoli_data
                    )
                    
SELECT  id,
        CASE
            WHEN quartile = 1 THEN 'CRITICAL'
            WHEN quartile = 2 THEN 'HIGH'
            WHEN quartile = 3 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS colony_name
FROM    ranked_data
ORDER BY id;

/*
특정 세대의 대장균 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/301650
*/
WITH 1st_gen AS (
                SELECT  id
                FROM    ecoli_data
                WHERE   parent_id IS NULL
                )

SELECT  gen3.id
FROM    1st_gen AS gen1				-- 1세대 대장균 테이블
LEFT JOIN ecoli_data AS gen2		-- 2세대 대장균 테이블
ON      gen1.id = gen2.parent_id	-- 1세대-2세대 관계 정의
LEFT JOIN ecoli_data AS gen3		-- 3세대 대장균 테이블
ON      gen2.id = gen3.parent_id	-- 2세대-3세대 관계 정의
WHERE   gen3.id IS NOT NULL			-- 3세대 ID 출력이 필요하므로 NOT NULL 조건
ORDER BY gen3.id;

/*
멸종위기의 대장균 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/301651
*/
WITH RECURSIVE generation AS (											-- 재귀적 CTE
                             SELECT id,
                                    parent_id,
                                    1 AS generation						-- parent_id가 없는 세대를 1세대
                             FROM   ecoli_data
                             WHERE  parent_id IS NULL
    
                             UNION ALL
                             
                             SELECT e.id,
                                    e.parent_id,
                                    g.generation + 1 AS generation		-- join하며 generation 값 1씩 증가
                             FROM   ecoli_data AS e
                             INNER JOIN generation AS g 				-- 1세대 부모 id와 2세대 자식 id를 join
							 ON		e.parent_id = g.id
                             )
                             
SELECT  COUNT(g1.id) AS count,
        g1.generation AS generation
FROM    generation AS g1
LEFT JOIN generation AS g2
ON      g1.id = g2.parent_id
WHERE   g2.id IS NULL					-- 자식이 없는 개체만 조회
GROUP BY g1.generation
ORDER BY g1.generation;

-- SUM, MAX, MIN
/*
가격이 제일 비싼 식품의 정보 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/131115
*/
SELECT  product_id,
        product_name,
        product_cd,
        category,
        price
FROM    food_product
WHERE   price = (						-- 가격이 가장 비싼 식품만 조회
                SELECT MAX(price)
                FROM   food_product
                );
                
/*
가장 비싼 상품 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/131697
*/
SELECT  MAX(price) AS max_price
FROM    product;

/*
최댓값 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/59415
*/
SELECT  MAX(datetime) AS 시간
FROM    animal_ins;

/*
최솟값 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/59038
*/
SELECT  MIN(datetime) AS 시간
FROM    animal_ins;

/*
동물 수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/59406
*/
SELECT  COUNT(*) AS count
FROM    animal_ins;

/*
중복 제거하기
https://school.programmers.co.kr/learn/courses/30/lessons/59408
*/
SELECT  COUNT(DISTINCT name) AS count
FROM    animal_ins;

/*
조건에 맞는 아이템들의 가격의 총합 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/273709
*/
SELECT  SUM(price) AS total_price
FROM    item_info
WHERE   rarity = 'LEGEND';

/*
물고기 종류 별 대어 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/293261
*/
SELECT  A.id,
        B.fish_name,
        A.length
FROM    fish_info AS A
INNER JOIN fish_name_info AS B
ON      A.fish_type = B.fish_type
WHERE   (A.fish_type, A.length) IN (						-- fish_type별 최대 길이 조회	
                                    SELECT  fish_type,
                                            MAX(length)		
                                    FROM    fish_info
                                    GROUP BY fish_type
									)
ORDRE BY id;

/*
잡은 물고기 중 가장 큰 물고기의 길이 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/298515
*/
SELECT  CONCAT(MAX(length), 'cm') AS max_length
FROM    fish_info;

/*
연도별 대장균 크기의 편차 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/299310
*/
WITH ecoli_size AS (												-- 각 연도의 가장 큰 크기로 구성된 CTE
                    SELECT  YEAR(differentiation_date) AS year,
                            MAX(size_of_colony) AS max_size
                    FROM    ecoli_data
                    GROUP BY year
                    )
                    
SELECT  YEAR(differentiation_date) AS year,
        B.max_size - A.size_of_colony AS year_dev,					-- 대장균 크기 편차 구하기
        A.id
FROM    ecoli_data AS A
LEFT JOIN ecoli_size AS B											-- CTE와 year를 기준으로 LEFT JOIN
ON      YEAR(A.differentiation_date) = B.year	
ORDER BY year, year_dev;

-- GROUP BY
/*
자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/151137
*/
SELECT  car_type,
        COUNT(*) AS cars
FROM    car_rental_company_car
WHERE   FIND_IN_SET('통풍시트', options) != 0			-- option에 통풍시트/열선시트/가죽시트 중 하나라도 있는 것만 조회
        OR FIND_IN_SET('열선시트', options) != 0
        OR FIND_IN_SET('가죽시트', options) != 0
GROUP BY car_type
ORDER BY car_type;

/*
성분으로 구분한 아이스크림 총 주문량
https://school.programmers.co.kr/learn/courses/30/lessons/133026
*/
SELECT  B.ingredient_type,
        SUM(A.total_order) AS total_order
FROM    first_half AS A
INNER JOIN icecream_info AS B
ON      A.flavor = B.flavor
GROUP BY B.ingredient_type						-- type별 주문량 집계를 위해 group
ORDER BY total_order;
ORDER BY car_type;

/*
조건에 맞는 사용자와 총 거래금액 조회하기
https://school.programmers.co.kr/learn/courses/30/lessons/164668
*/
SELECT  B.user_id,
        B.nickname,
        SUM(A.price) AS total_sales
FROM    used_goods_board AS A
INNER JOIN used_goods_user AS B			-- 게시판 작성자 id와 유저 id로 join
ON      A.writer_id = B.user_id
WHERE   A.status = 'DONE'				-- 완료된 중고 거래만 조회
GROUP BY B.user_id						-- 유저의 총 거래 금액 집계를 위해 group
HAVING  total_sales >= 700000			-- 총 거래 금액이 70만원 이상인 유저만 조회
ORDER BY total_sales;

/*
카테고리 별 도서 판매량 집계하기
https://school.programmers.co.kr/learn/courses/30/lessons/144855
*/
SELECT  category,
        SUM(B.sales) AS total_sales
FROM    book AS A
INNER JOIN book_sales AS B
ON      A.book_id = B.book_id
WHERE   B.sales_date LIKE '2022-01%'		-- 2022년 1월 도서 판매량만 조회
GROUP BY category							-- 카테고리별 도서 판매량 집계를 위해 group
ORDER BY category;

/*
즐겨찾기가 가장 많은 식당 정보 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/131123
*/
SELECT  food_type,
        rest_id,
        rest_name,
        favorites
FROM    rest_info
WHERE   (food_type, favorites) IN (												-- 가장 높은 favorites를 가진 food_type과 일치하는 값만 조회
                                   SELECT   food_type,
                                            MAX(favorites) AS max_favorites		-- food_type별 가장 높은 favorites 구하기
                                   FROM     rest_info
                                   GROUP BY food_type
                                  )
ORDER BY food_type DESC;

WITH maxfavorites AS (SELECT   food_type, MAX(favorites) AS max_favorites		-- food_type별 가장 높은 favorites 구하기
                       FROM     rest_info
                       GROUP BY food_type
                      )

SELECT  A.food_type,
        A.rest_id,
        A.rest_name,
        B.max_favorites
FROM    rest_info AS A
INNER JOIN maxfavorites AS B
ON      A.food_type = B.food_type AND A.favorites = B.max_favorites				-- CTE와 food_type과 favorites로 join
ORDER BY A.food_type DESC;

/*
자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기
https://school.programmers.co.kr/learn/courses/30/lessons/157340
*/
SELECT  car_id,
        MAX(IF('2022-10-16' BETWEEN start_date AND end_date, '대여중','대여 가능')) AS availability		-- 2022-10-16에 대여중이라면 대여중, 아니라면 대여가능
FROM    car_rental_company_rental_history
GROUP BY car_id
ORDER BY car_id DESC;

/*
진료과별 총 예약 횟수 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/132202
*/
SELECT  mcdp_cd AS '진료과 코드',
        COUNT(apnt_no) AS '5월예약건수'	-- 진료과 코드별 예약 건수 조회
FROM    appointment
WHERE   apnt_ymd LIKE '2022-05%'		-- 2022년 05월 예약만 조회
GROUP BY mcdp_cd						-- 진료과 코드별 집계를 위해 group
ORDER BY 2, 1;	

/*
대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/151139
*/
WITH over5 AS (																		-- 조건 기간 동안 5회 이상 대여한 car_id를 CTE로
               SELECT   car_id
               FROM     car_rental_company_rental_history
               WHERE    start_date >= '2022-08-01' AND start_date < '2022-11-01'
               GROUP BY car_id
               HAVING   COUNT(history_id) >= 5
              )

SELECT  MONTH(start_date) AS month,
        car_id,
        COUNT(car_id) AS records
FROM    car_rental_company_rental_history
WHERE   start_date >= '2022-08-01' AND start_date < '2022-11-01'					-- 조건 기간 동안의 기록을 조회
        AND car_id IN (SELECT car_id FROM over5)									-- car_id가 CTE에 있는(조건 기간 동안 5회 이상 대여한) 것만 조회
GROUP BY month, car_id																-- 월별, 자동차별 집계를 위해 group
HAVING  records > 0																	-- 특정 월의 총 대여 횟수가 0인 경우에는 제외
ORDER BY month, car_id DESC;

/*
저자 별 카테고리 별 매출액 집계하기
https://school.programmers.co.kr/learn/courses/30/lessons/144856
*/
SELECT  A.author_id,
        C.author_name,
        A.category,
        SUM(A.price * B.sales) AS total_sales
FROM    book AS A
INNER JOIN book_sales AS B
ON      A.book_id = B.book_id
INNER JOIN author AS C
ON      A.author_id = C.author_id
WHERE   B.sales_date LIKE '2022-01%'
GROUP BY author_id, category
ORDER BY author_id, category DESC;

/*
식품분류별 가장 비싼 식품의 정보 조회하기
https://school.programmers.co.kr/learn/courses/30/lessons/131116
*/
SELECT  category,
        price AS max_price,
        product_name
FROM    food_product
WHERE   (category, price) IN (												-- 각 카테고리별 최대 가격을 구하는 서브쿼리
                             SELECT category,
                                    max(price)
                             FROM   food_product
                             WHERE category IN ('과자', '국', '김치', '식용유')
                             GROUP BY category
                             )
ORDER BY max_price DESC;

WITH ranked_products AS (													-- 각 카테고리별로 가격을 기준으로 행에 순위를 매기는 CTE
                        SELECT  category,
                                price AS max_price,
                                product_name,
                                ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS row_num
                        FROM	food_product
                        WHERE	category IN ('과자', '국', '김치', '식용유')
                        )
SELECT  category,
        max_price,
        product_name
FROM    ranked_products
WHERE   row_num = 1															-- 순위가 1인 행만 선택 (즉, 각 카테고리별로 가격이 가장 높은 제품)
ORDER BY max_price DESC;

-- join
/*
주문량이 많은 아이스크림들 조회하기
https://school.programmers.co.kr/learn/courses/30/lessons/133027
*/
SELECT  A.flavor
FROM    first_half AS A
INNER JOIN july AS B
ON      A.flavor = B.flavor
GROUP BY A.flavor
ORDER BY (SUM(A.total_order) + SUM(B.total_order)) DESC
LIMIT   3;

WITH combined_orders AS (
                         SELECT A.flavor, 
                                SUM(A.total_order) + SUM(B.total_order) AS total_order
                         FROM   first_half AS A
                         INNER JOIN july AS B
                         ON A.flavor = B.flavor
                         GROUP BY A.flavor
                        )
                        
SELECT  flavor
FROM    combined_orders
ORDER BY total_order DESC
LIMIT   3;

/*
5월 식품들의 총매출 조회하기
https://school.programmers.co.kr/learn/courses/30/lessons/131117
*/
SELECT  A.product_id,
        A.product_name,
        SUM(A.price * B.amount) AS total_sales		-- price * amount로 total sales 구하기
FROM    food_product AS A
INNER JOIN food_order AS B
ON      A.product_id = B.product_id
WHERE   B.produce_date LIKE '2022-05%'				-- 생산일자가 2022년 5월인 식품만 조회
GROUP BY A.product_id								-- product_id별 집계를 위해 group
ORDER BY total_sales DESC, product_id;

/*
특정 기간동안 대여 가능한 자동차들의 대여비용 구하기
https://school.programmers.co.kr/learn/courses/30/lessons/157339
*/
SELECT  A.car_id,
        A.car_type,
        ROUND(A.daily_fee * 30 * (1-C.discount_rate / 100)) AS fee					-- 30일 대여료 조회
FROM    car_rental_company_car AS A
INNER JOIN car_rental_company_discount_plan AS C
ON      A.car_type = C.car_type 
AND     C.duration_type = '30일 이상'
WHERE   A.car_type IN ('세단', 'SUV')												-- 세단 혹은 SUV만 조회
        AND A.car_id NOT IN (SELECT car_id											-- 대여 가능한 자동차만 조회
                             FROM car_rental_company_rental_history	
                             WHERE '2022-11-01' BETWEEN start_date AND end_date		
                             OR '2022-11-30' BETWEEN start_date AND end_date
                            )
HAVING  fee BETWEEN 500000 AND 2000000												-- 대여 금액이 50만원 이상 200만원 미만인 자동차
ORDER BY fee DESC, A.car_type ASC, A.car_id DESC;

/*
조건에 맞는 도서와 저자 리스트 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/144854
*/
SELECT  A.book_id,
        B.author_name,
        DATE_FORMAT(A.published_date, '%Y-%m-%d') AS published_date
FROM    book AS A
INNER JOIN author AS B
        ON A.author_id = B.author_id
WHERE   A.category = '경제'
ORDER BY published_date;

/*
그룹별 조건에 맞는 식당 목록 출력하기
https://school.programmers.co.kr/learn/courses/30/lessons/131124
*/
SELECT  A.member_name,
        B.review_text,
        DATE_FORMAT(B.review_date, '%Y-%m-%d') AS review_date
FROM    member_profile AS A
INNER JOIN rest_review AS B
        ON A.member_id = B.member_id
WHERE   A.member_id = (SELECT member_id					-- 가장 많은 리뷰 작성자만 조회
                       FROM   rest_review
                       GROUP BY member_id
                       ORDER BY COUNT(member_id) DESC
                       LIMIT  1 
                      )
ORDER BY review_date, review_text;

/*
없어진 기록 찾기
https://school.programmers.co.kr/learn/courses/30/lessons/59042
*/
SELECT  A.animal_id,
        A.name
FROM    animal_outs AS A
LEFT JOIN animal_ins AS B
       ON A.animal_id = B.animal_id
WHERE   B.animal_id IS NULL				-- 입양 보냈으나, 보호소에 들어온 이력이 없는 동물 조회
ORDER BY 1, 2;

/*
있었는데요 없었습니다
https://school.programmers.co.kr/learn/courses/30/lessons/59043
*/
SELECT  A.animal_id,
        A.name
FROM    animal_ins AS A
INNER JOIN animal_outs AS B
        ON A.animal_id = B.animal_id
WHERE   B.datetime < A.datetime			-- 보호 시작일보다 입양일이 더 빠른 동물 조회
ORDER BY A.datetime;