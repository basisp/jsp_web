<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 등록 처리</title>
</head>
<body>
    <h1>회원 등록 처리 결과</h1>

    <%
        String dbUrl = "jdbc:mysql://localhost:3306/mydb";
        String dbUser = "root";  
        String dbPassword = "1234"; 

        // 회원 정보 파라미터 받기
        int sno = Integer.parseInt(request.getParameter("sno"));
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String major = request.getParameter("major");
        String email = request.getParameter("email");
		String roll = "user";
		
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            String sql = "INSERT INTO member (sno, password, name, major, email, role) VALUES (?, ?, ?, ?,?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sno);
            pstmt.setString(2, password);
            pstmt.setString(3, name);
            pstmt.setString(4, major);
            pstmt.setString(5, email);
            pstmt.setString(6, roll);

            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                out.println("<p>회원 등록이 성공적으로 완료되었습니다!</p>");
            } else {
                out.println("<p>회원 등록에 실패했습니다. 다시 시도해 주세요.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    %>

    <p><a href="register.jsp">회원 등록 페이지로 돌아가기</a></p>
    <p><a href="main.jsp">메인 페이지로 돌아가기</a></p>
</body>
</html>
