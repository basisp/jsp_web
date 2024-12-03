<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="com.library.models.Book"%>
<!-- Book 클래스 및 관련 모델 불러오기 -->
<%@ page import="com.library.services.BookService"%>
<!-- BookService 클래스 불러오기 -->
<%@ page import="jakarta.servlet.http.HttpSession"%>
<!-- 수정된 부분 -->
<%
// 세션에서 사용자 정보와 권한 가져오기 (예: "userRole"을 이용해 관리자 구분)
String username = (String) session.getAttribute("userName");
String sno = (String) session.getAttribute("sno");
%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>도서 관리 시스템 - 메인 페이지</title>
<link rel="stylesheet" href="styles/main.css">
</head>
<body>
	<header>
		<h1>도서 관리 시스템</h1>
		<div class="user-info">
			<span>환영합니다, <%=username != null ? username : "게스트"%>님!
			</span>
			<%
			if (username != null) {
			%>
			<a href="logout.jsp">로그아웃</a>
			<%
			} else {
			%>
			<a href="login.jsp">로그인</a>
			<%
			}
			%>
		</div>
	</header>

	<nav>
		<a href="main.jsp">홈</a> <a href="addBook.jsp">도서 등록</a> <a
			href="myBooks.jsp">내 대여 목록</a> <a href="review.jsp">리뷰 쓰기</a>
	</nav>

	<section class="search-section">
		<h2>도서 검색</h2>
		<br>
		<form action="searchBooks.jsp" method="get">
			<input type="text" name="query" placeholder="도서 제목 또는 저자 검색" required>
			<button type="submit">검색</button>
		</form>
	</section>

	<section class="book-list">
		<h2>도서 목록</h2>
		<br>
		<%
		// 도서 목록을 가져오기 위한 서비스 호출
		BookService bookService = new BookService();
		List<Book> books = bookService.getAllBooks();

		if (books != null && !books.isEmpty()) {
			for (Book book : books) {
		%>
		<div class="book-item">
			<img src="images/<%=book.getImagePath()%>" alt="<%=book.getTitle()%>"
				style="max-width: 200px;">
			<h3>
				<%=book.getTitle()%>
				<span style="font-size: 16px; color: #D4B500;">★ <%= String.format("%.2f", book.getRating()) %></span>
			</h3>
			<p>
				저자:
				<%=book.getAuthor()%></p>
			<p>
				출판사:
				<%=book.getPublisher()%></p>
			<p>
				상태:
				<%=book.isAvailable() ? "대여 가능" : "대여 중"%></p>
			<a href="bookDetail.jsp?id=<%=book.getId()%>">자세히 보기</a>

			<%
			// 로그인한 사용자에게만 대여/반납 버튼 표시
       if (sno != null) { %>
			<% 
        // 도서 대여 여부 확인
    boolean isRentedByCurrentUser = bookService.isRentedByCurrentUser(book.getId(), sno);
        %>

        <% if (isRentedByCurrentUser) { %>
            <!-- 반납하기 버튼 -->
            <form action="returnBook.jsp" method="post" style="display: inline;">
                <input type="hidden" name="bookId" value="<%=book.getId()%>">
                <button type="submit" class="rent-button">반납하기</button>
            </form>
        <% } else if (book.isAvailable()) { %>
            <!-- 대여하기 버튼 -->
            <form action="rentBook.jsp" method="post" style="display: inline;">
                <input type="hidden" name="bookId" value="<%=book.getId()%>">
                <button type="submit" class="rent-button">대여하기</button>
            </form>
        <% } else { %>
            <!-- 다른 사람이 대여중 -->
            <button class="rent-button" disabled style="background-color: #ccc; color: #666; cursor: not-allowed;">
                다른 사람이 대여중입니다.
            </button>
			<%
			}
			}
			%>
		</div>

		<%
		}
		} else {
		%>
		<p>등록된 도서가 없습니다.</p>
		<%
		}
		%>
	</section>
</body>
</html>
