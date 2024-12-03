<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.library.services.BookService" %>

<%
    // 사용자가 보낸 bookId와 sno 가져오기
    int bookId = Integer.parseInt(request.getParameter("bookId"));
    String sno = (String) session.getAttribute("sno");

    if (sno == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 서비스 호출로 대여 정보 삭제
    BookService bookService = new BookService();
    boolean isDeleted = bookService.returnBook(bookId, sno);

    if (isDeleted) {
        System.out.println("반납 성공: bookId=" + bookId + ", sno=" + sno);
    } else {
        System.err.println("반납 실패: bookId=" + bookId + ", sno=" + sno);
    }

    // 페이지 새로고침
    response.sendRedirect("myBooks.jsp");
%>
