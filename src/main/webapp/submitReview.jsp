<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%

    // 리뷰 제출 데이터를 폼에서 가져오기
    String sno = request.getParameter("sno");
    String bookId = request.getParameter("bookId");
    int rating = Integer.parseInt(request.getParameter("rating"));
    String reviewText = request.getParameter("reviewText");

    Connection conn = null;
    PreparedStatement insertReviewStmt = null;
    PreparedStatement updateBookRatingStmt = null;

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "1234");

        // 1. 리뷰 테이블에 새 리뷰 추가
        String insertReviewQuery = "INSERT INTO reviews (book_id, user_id, rating, review_text) VALUES (?, ?, ?, ?)";
        insertReviewStmt = conn.prepareStatement(insertReviewQuery);
        insertReviewStmt.setString(1, bookId);
        insertReviewStmt.setString(2, sno);
        insertReviewStmt.setInt(3, rating);
        insertReviewStmt.setString(4, reviewText);
        insertReviewStmt.executeUpdate();

        // 2. 별점 평균 업데이트
  		String updateBookRatingQuery = 
    		"UPDATE book " +
    		"SET rating = (rating * review_count + ?) / (review_count + 1), " +
    		"review_count = review_count + 1 " +
    		"WHERE id = ?";
        
        updateBookRatingStmt = conn.prepareStatement(updateBookRatingQuery);
        updateBookRatingStmt.setInt(1, rating);
        updateBookRatingStmt.setString(2, bookId);
        updateBookRatingStmt.executeUpdate();

        // 리뷰 제출 성공 메시지
        request.setAttribute("message", "리뷰가 성공적으로 제출되었습니다.");
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "리뷰 제출 중 오류가 발생했습니다.");
    } finally {
        // 자원 해제
        if (insertReviewStmt != null) insertReviewStmt.close();
        if (updateBookRatingStmt != null) updateBookRatingStmt.close();
        if (conn != null) conn.close();
    }

    // 결과 페이지로 리다이렉트
    response.sendRedirect("review.jsp");
%>
