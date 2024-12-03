<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import ="com.library.services.UserService" %>
<%
    String loginError = (String) request.getAttribute("loginError");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 관리 시스템 - 로그인</title>
    <link rel="stylesheet" href="styles/login.css">
</head>
<body>
    <header>
        <h1>도서 관리 시스템</h1>
    </header>

    <section class="login-container">
        <h2>로그인</h2>
        
        <% if (loginError != null) { %>
            <p class="error-message"><%= loginError %></p>
        <% } %>
        
        <form action="loginProcess.jsp" method="post">
            <label for="sno">학번:</label>
            <input type="text" id="sno" name="sno" required>
            
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required>
            
            <button type="submit">로그인</button>
        </form>

        <p>계정이 없으신가요? <a href="register.jsp">회원가입</a></p>
    </section>

    <footer>
        <p>&copy; 2020197 김민상 도서 관리 시스템</p>
    </footer>
</body>
</html>
