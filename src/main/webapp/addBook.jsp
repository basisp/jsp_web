<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="com.library.services.BookService"%>
<%@ page import="com.library.models.Book"%>

<%
// 세션에서 사용자 권한 확인
String userRole = (String) session.getAttribute("userRole");
String username = (String) session.getAttribute("userName");

// admin이 아닌 경우 메인 페이지로 리다이렉트
if (!"admin".equals(userRole)) {
%>
    <script>
        alert('관리자가 아닙니다.');
        window.location.href = 'main.jsp';
    </script>
<%
    return;
}

// POST 요청 처리 (도서 추가)
if ("POST".equalsIgnoreCase(request.getMethod())) {
    request.setCharacterEncoding("UTF-8");
    
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String publisher = request.getParameter("publisher");
    String imagePath = request.getParameter("imagePath");
    String summary = request.getParameter("summary");
    
    Book newBook = new Book();
    newBook.setTitle(title);
    newBook.setAuthor(author);
    newBook.setPublisher(publisher);
    newBook.setAvailable(true);
    newBook.setImagePath(imagePath);
    newBook.setSummary(summary);
    newBook.setRating(0.0f);
    
    BookService bookService = new BookService();
    boolean success = bookService.addBook(newBook);
    
    if (success) {
        response.sendRedirect("main.jsp");
        return;
    }
}
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 추가 - 도서 관리 시스템</title>
    <link rel="stylesheet" href="styles/main.css">
    <link rel="stylesheet" href="styles/addBook.css">
</head>
<body>
    <header>
        <h1>도서 관리 시스템</h1>
        <div class="user-info">
            <span>관리자: <%= username %></span>
            <a href="logout.jsp">로그아웃</a>
        </div>
    </header>

    <nav>
        <a href="main.jsp">홈</a>
        <a href="addBook.jsp" class="active">도서 등록</a>
        <a href="myBooks.jsp">대여 현황</a>
    </nav>

    <main>
        <div class="add-book-form">
            <h2>새로운 도서 추가</h2>
            <form action="addBook.jsp" method="post">
                <div class="form-group">
                    <label for="title">도서명 *</label>
                    <input type="text" id="title" name="title" required>
                </div>
                
                <div class="form-group">
                    <label for="author">저자 *</label>
                    <input type="text" id="author" name="author" required>
                </div>
                
                <div class="form-group">
                    <label for="publisher">출판사 *</label>
                    <input type="text" id="publisher" name="publisher" required>
                </div>
                
                <div class="form-group">
                    <label for="imagePath">이미지 경로</label>
                    <input type="text" id="imagePath" name="imagePath" placeholder="예: book.jpg">
                </div>
                
                <div class="form-group">
                    <label for="summary">도서 요약</label>
                    <textarea id="summary" name="summary" placeholder="도서의 간단한 설명을 입력하세요"></textarea>
                </div>
                
                <button type="submit" class="submit-button">도서 추가</button>
            </form>
        </div>
    </main>

    <footer>
        <p>&copy; 2024 도서 관리 시스템. All rights reserved.</p>
    </footer>

    <script>
        // 폼 유효성 검사
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const author = document.getElementById('author').value.trim();
            const publisher = document.getElementById('publisher').value.trim();
            
            if (!title || !author || !publisher) {
                e.preventDefault();
                alert('필수 항목(*)을 모두 입력해주세요.');
            }
        });
    </script>
</body>
</html>