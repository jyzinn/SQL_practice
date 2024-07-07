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