<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.library.models.Book" %>
<%@ page import="com.library.services.BookService" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // 세션에서 사용자 정보 가져오기
    String sno = (String) session.getAttribute("sno");
	String userName = (String) session.getAttribute("userName");
    if (sno == null) {
        // 로그인이 되어 있지 않으면 로그인 페이지로 이동
        response.sendRedirect("login.jsp");
        return;
    }

    // 도서 대여 목록 서비스 호출
    BookService bookService = new BookService();
    List<Book> myBooks = bookService.getBorrowedBooks(sno);
    
    bookService.updateOverdueBooksAsReturned();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>내 대여 목록</title>
    <link rel="stylesheet" href="styles/main.css">
</head>
<body>
    <header>
        <h1>내 대여 목록</h1>
        <div class="user-info">
            <span>환영합니다, <%= userName %>님!</span>
            <a href="logout.jsp">로그아웃</a>
        </div>
    </header>

    <nav>
        <a href="main.jsp">홈</a>
        <a href="myBooks.jsp">내 대여 목록</a>
		<a href="review.jsp">리뷰 쓰기</a>
    </nav>

    <section class="my-book-list">
        <h2>대여 중인 도서</h2><br>
        <%
            if (myBooks != null && !myBooks.isEmpty()) {
                for (Book book : myBooks) {
        %>
                    <div class="book-item">
                        <img src="images/<%= book.getImagePath() %>" alt="<%= book.getTitle() %>" style="max-width: 150px;">
                        <h3><%= book.getTitle() %></h3>
                        <p>저자: <%= book.getAuthor() %></p>
                        <p>출판사: <%= book.getPublisher() %></p>
                        <p>대여일: <%= book.getBorrowDate() %></p>
                        <p>반납 예정일: <%= book.getReturnDate() %></p>
                        <% if (!book.isReturned()) { %>
                            <form action="returnBook.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="bookId" value="<%= book.getId() %>">
                                <button type="submit">반납하기</button>
                            </form>
                        <% } %>
                    </div>
        <%
                }
            } else {
        %>
                <p>현재 대여 중인 도서가 없습니다.</p>
        <%
            }
        %>
    </section>
</body>
</html>
