<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.library.models.Book" %>
<%@ page import="com.library.services.BookService" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // 세션에서 사용자 학번 가져오기
    String sno = (String) session.getAttribute("sno");
	String userName = (String) session.getAttribute("userName");
    if (sno == null) {
        // 로그인이 되어 있지 않으면 로그인 페이지로 이동
        response.sendRedirect("login.jsp");
        return;
    }

    // 대여 이력 가져오기
    BookService bookService = new BookService();
    List<Book> rentalHistory = bookService.getRentalHistory(sno); // 대여 이력 조회 메서드 호출
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    <link rel="stylesheet" href="styles/review.css"> <!-- 외부 CSS 파일 링크 -->
</head>
<body>
    <header>
        <h1>리뷰 작성</h1>
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
    
    <section class="review-list">
        <h2>대여 이력</h2><br>
        <%
            if (rentalHistory != null && !rentalHistory.isEmpty()) {
                for (Book book : rentalHistory) {
        %>
                    <div class="review-item">
                        <div class="book-info">
                            <img src="images/<%= book.getImagePath() %>" alt="책 이미지" class="book-image"> <!-- 책 이미지 추가 -->
                            <div class="book-details">
                                <h3><%= book.getTitle() %></h3>
                                <p>저자: <%= book.getAuthor() %></p>
                                <p>대여일: <%= book.getBorrowDate() %></p>
                                <p>반납일: <%= book.getReturnDate() != null ? book.getReturnDate() : "반납되지 않음" %></p>
                            </div>
                        </div>
                        <!-- 별점 선택 -->
                        <form action="submitReview.jsp" method="post">
                            <input type="hidden" name="bookId" value="<%= book.getId() %>">
                            <input type="hidden" name="sno" value="<%= sno %>">

                            <div class="star-rating">
                                <input type="radio" id="5-stars-<%= book.getId() %>" name="rating" value="5">
                                <label for="5-stars-<%= book.getId() %>">★</label>
                                <input type="radio" id="4-stars-<%= book.getId() %>" name="rating" value="4">
                                <label for="4-stars-<%= book.getId() %>">★</label>
                                <input type="radio" id="3-stars-<%= book.getId() %>" name="rating" value="3">
                                <label for="3-stars-<%= book.getId() %>">★</label>
                                <input type="radio" id="2-stars-<%= book.getId() %>" name="rating" value="2">
                                <label for="2-stars-<%= book.getId() %>">★</label>
                                <input type="radio" id="1-star-<%= book.getId() %>" name="rating" value="1">
                                <label for="1-star-<%= book.getId() %>">★</label>
                            </div>
                            <textarea name="reviewText" placeholder="리뷰 내용을 작성하세요" required></textarea><br>
                            <button type="submit">리뷰 제출</button>
                        </form>
                    </div>
        <%
                }
            } else {
        %>
                <p>대여 이력이 없습니다.</p>
        <%
            }
        %>
    </section>
</body>
</html>
