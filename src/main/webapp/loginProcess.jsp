<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String dbUrl = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPassword = "1234";

    String sno = request.getParameter("sno");
    String password = request.getParameter("password");

    boolean loginSuccess = false;
    String userRole = null; // role 값을 저장할 변수
    String userName = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); 
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        String query = "SELECT * FROM member WHERE sno = ? AND password = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, sno);
        pstmt.setString(2, password);

        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            loginSuccess = true;
            session.setAttribute("sno", sno);
            userRole = rs.getString("role"); // role 값 가져오기
            session.setAttribute("userRole", userRole); // 세션에 userRole 설정
            userName = rs.getString("name");
            session.setAttribute("userName",userName);
        }

        // 리소스 정리
        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (loginSuccess) {
        response.sendRedirect("main.jsp");
    } else {
        request.setAttribute("loginError", "학번 또는 비밀번호가 잘못되었습니다.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
%>
