CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- 리뷰 ID (고유값, 자동 증가)
    book_id INT NOT NULL,                      -- 리뷰 대상 도서 ID
    user_id VARCHAR(50) NOT NULL,              -- 리뷰 작성자 ID
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5), -- 별점 (1~5 사이)
    review_text TEXT,                          -- 리뷰 내용
    FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE -- 도서 테이블과 연결
);