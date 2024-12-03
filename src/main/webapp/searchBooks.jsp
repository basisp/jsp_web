<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.library.models.Book" %> <!-- Book 클래스 및 관련 모델 불러오기 -->
<%@ page import="com.library.services.BookService" %> <!-- BookService 클래스 불러오기 -->
<%@ page import="jakarta.servlet.http.HttpSession" %> <!-- 세션을 위한 임포트 -->

<%
    // 검색 쿼리 받기
    String query = request.getParameter("query");

    // BookService 인스턴스 생성 후 도서 검색
    BookService bookService = new BookService();
    List<Book> searchResults = new ArrayList<>();
    
    if (query != null && !query.trim().isEmpty()) {
        // 도서 제목이나 저자에서 검색
        searchResults = bookService.searchBooks(query);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>도서 검색 결과</title>
    <link rel="stylesheet" href="styles/main.css">
</head>
<body>
    <header>
        <h1>도서 검색 결과</h1>
        <div class="user-info">
            <% 
                String username = (String) session.getAttribute("userName");
                if (username != null) { 
            %>
                <span>환영합니다, <%= username %>님!</span>
                <a href="logout.jsp">로그아웃</a>
            <% } else { %>
                <a href="login.jsp">로그인</a>
            <% } %>
        </div>
    </header>

    <nav>
        <a href="main.jsp">홈</a>
        <a href="myBooks.jsp">내 대여 목록</a>
        <a href="review.jsp">리뷰 쓰기</a>
    </nav>

    <section class="search-section">
        <h2>도서 검색</h2>
        <form action="searchBooks.jsp" method="get">
            <input type="text" name="query" placeholder="도서 제목 또는 저자 검색" value="<%= query != null ? query : "" %>" required>
            <button type="submit">검색</button>
        </form>
    </section>

    <section class="book-list">
        <h2>검색 결과</h2><br>
        <% 
            if (searchResults != null && !searchResults.isEmpty()) {
                for (Book book : searchResults) {
        %>
                    <div class="book-item">
                        <img src="images/<%= book.getImagePath() %>" alt="<%= book.getTitle() %>" style="max-width: 200px;">
                        <h3><%= book.getTitle() %></h3>
                        <p>저자: <%= book.getAuthor() %></p>
                        <p>출판사: <%= book.getPublisher() %></p>
                        <p>상태: <%= book.isAvailable() ? "대여 가능" : "대여 중" %></p>
                        <a href="bookDetail.jsp?id=<%= book.getId() %>">자세히 보기</a>
                    </div>
        <% 
                }
            } else {
        %>
                <p>검색된 도서가 없습니다.</p>
        <% 
            }
        %>
    </section>
</body>
</html>
