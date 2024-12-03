package com.library.services;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.library.models.Review;

public class ReviewService {
    private static final String URL = "jdbc:mysql://localhost:3306/mydb";
    private static final String USER = "root";  // 필요에 따라 변경
    private static final String PASSWORD = "1234";  // 필요에 따라 변경

    // JDBC 드라이버 로드
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC 드라이버를 찾을 수 없습니다.", e);
        }
    }

    // 데이터베이스 연결 메서드
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 특정 도서의 리뷰 목록 가져오기
    public List<Review> getReviewsByBookId(int bookId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT user_id, rating, review_text " +
                     "FROM reviews " +
                     "WHERE book_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review(
                    	bookId,    
                        rs.getInt("user_id"),  // 리뷰 작성자 ID              // 도서 ID
                        rs.getInt("rating"),     // 별점
                        rs.getString("review_text")
                    );
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("리뷰 목록을 가져오는 중 오류 발생: " + e.getMessage());
        }

        return reviews;
    }
}
