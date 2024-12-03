<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    // 세션 종료 처리
	session.invalidate();

    // 로그아웃 후 리다이렉트
    response.sendRedirect("main.jsp"); // 로그아웃 후 로그인 페이지로 이동
%>
