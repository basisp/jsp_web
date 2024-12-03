<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%

    String sno = (String) session.getAttribute("sno");
    int bookId = Integer.parseInt(request.getParameter("bookId"));

    if (sno == null || sno.isEmpty()) {
        // 로그인 상태가 아니면 로그인 페이지로 이동
        response.sendRedirect("login.jsp");
        return;
    }

    String dbUrl = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPassword = "1234";

    String sqlInsert = "INSERT INTO rental (book_id, sno, borrow_date, return_date, returned) VALUES (?, ?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), false)";
    String sqlUpdate = "UPDATE book SET available = false WHERE id = ?";

    try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
        // 대여 정보 추가
        try (PreparedStatement pstmt = conn.prepareStatement(sqlInsert)) {
            pstmt.setInt(1, bookId);
            pstmt.setString(2, sno);
            pstmt.executeUpdate();
        }

        // 책 상태 업데이트
        try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdate)) {
            pstmt.setInt(1, bookId);
            pstmt.executeUpdate();
        }

        // 성공 시 메인 페이지로 리다이렉트
        response.sendRedirect("main.jsp");
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>대여 처리 중 오류가 발생했습니다.</p>");
    }
%>
