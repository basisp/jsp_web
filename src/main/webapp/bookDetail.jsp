<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="com.library.models.Book"%>
<%@ page import="com.library.models.Review"%>
<%@ page import="com.library.services.BookService"%>
<%@ page import="com.library.services.ReviewService"%>

<%
// 파라미터에서 bookId 가져오기
int bookId = Integer.parseInt(request.getParameter("id"));

// 서비스 객체 초기화
BookService bookService = new BookService();
ReviewService reviewService = new ReviewService();

// 도서 세부 정보 가져오기
Book book = bookService.getBookById(bookId);

// 리뷰 목록 가져오기
List<Review> reviews = reviewService.getReviewsByBookId(bookId);

// 도서가 존재하지 않을 경우 404 페이지로 이동
if (book == null) {
	response.sendRedirect("404.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%=book.getTitle()%> - 도서 상세 정보</title>
<link rel="stylesheet" href="styles/bookDetail.css">
</head>

<body>
	<header>
		<h1>책 소개</h1>
	</header>
<nav>
	<a href="main.jsp">홈</a>
	<a href="myBooks.jsp">내 대여 목록</a> 
	<a href="review.jsp">리뷰 쓰기</a>
</nav>
	<section class="book-details">
		<div class="details-container">
			<div class="book-image">
				<img src="images/<%=book.getImagePath()%>"
					alt="<%=book.getTitle()%>">
			</div>
			<div class="book-info">
				<h1><%=book.getTitle()%></h1>
				<p>
					저자:
					<%=book.getAuthor()%></p>
				<p>
					출판사:
					<%=book.getPublisher()%></p>
				<h2>책 요약</h2>
				<p><%=book.getSummary()%></p>
			</div>
		</div>
	</section>

	<section class="book-reviews">
		<h2>리뷰</h2>
		<%
		if (reviews != null && !reviews.isEmpty()) {
		%>
		<%
		for (Review review : reviews) {
		%>
		<div class="review-item">
			<p>
				<strong>작성자:</strong>
				<%=review.getUser_id()%></p>
			<div class="review-rating">
				<%
				int fullStars = review.getRating(); // 채워진 별 개수
				%>
				<%
				for (int i = 1; i <= 5; i++) {
				%>
				<%
				if (i <= fullStars) {
				%>
				<!-- 채워진 별 -->
				<span class="star filled">★</span>
				<%
				} else {
				%>
				<!-- 빈 별 -->
				<span class="star">★</span>
				<%
				}
				%>
				<%
				}
				%>
			</div>
			<p>
				<strong>내용:</strong>
				<%=review.getReview_text()%></p>
		</div>
		<%
		}
		%>
		<%
		} else {
		%>
		<p>등록된 리뷰가 없습니다.</p>
		<%
		}
		%>
	</section>
</body>
</html>
