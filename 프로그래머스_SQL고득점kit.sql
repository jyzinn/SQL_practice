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