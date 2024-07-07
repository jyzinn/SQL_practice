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