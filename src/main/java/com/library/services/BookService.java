package com.library.services;

import com.library.models.Book;
import com.library.models.BookRentalList;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class BookService {
    // JDBC 연결 정보
    private static final String URL = "jdbc:mysql://localhost:3306/mydb";
    private static final String USER = "root";  // 필요에 따라 변경
    private static final String PASSWORD = "1234";  // 필요에 따라 변경

    // JDBC 드라이버 로드
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC 드라이버를 찾을 수 없습니다.", e);
        }
    }

    // 데이터베이스 연결 메서드
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 모든 도서 목록 가져오기
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book"; // book 테이블이 있다고 가정

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Book book = new Book(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getString("publisher"),
                    rs.getBoolean("available"),
                    rs.getString("image_path"),
                    rs.getFloat("rating"),
                    rs.getString("summary")
                );
                books.add(book);
            }
        } catch (SQLException e) {
            System.err.println("도서 목록을 가져오는 중 오류 발생: " + e.getMessage());
        }

        return books;
    }

    // 개별 도서 조회
    public Book getBookById(int id) {
        String sql = "SELECT * FROM book WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Book(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("publisher"),
                        rs.getBoolean("available"),
                        rs.getString("image_path"),
                        rs.getFloat("rating"),
                        rs.getString("summary")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("도서를 조회하는 중 오류 발생: " + e.getMessage());
        }
        
        return null;
    }

    // 도서 추가
    public boolean addBook(Book book) {
        String sql = "INSERT INTO book (title, author, publisher, available, image_path, summary) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getPublisher());
            pstmt.setBoolean(4, book.isAvailable());
            pstmt.setString(5, book.getImagePath());
            pstmt.setString(6, book.getSummary());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("도서를 추가하는 중 오류 발생: " + e.getMessage());
            return false;
        }
    }

    // 사용자별 대여 중인 도서 목록 가져오기
    public List<Book> getBorrowedBooks(String sno) {
        List<Book> borrowedBooks = new ArrayList<>();
        String sql = "SELECT b.id, b.title, b.author, b.publisher, b.available, b.image_path, r.borrow_date, r.return_date, r.returned " +
                     "FROM book b " +
                     "JOIN rental r ON b.id = r.book_id " +
                     "WHERE r.sno = ? AND r.returned = false";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, sno);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("publisher"),
                        rs.getBoolean("available"),
                        rs.getString("image_path")
                    );
                    book.setBorrowDate(rs.getDate("borrow_date"));
                    book.setReturnDate(rs.getDate("return_date"));
                    book.setReturned(rs.getBoolean("returned")); // 반납 여부 설정
                    borrowedBooks.add(book);
                }
            }
        } catch (SQLException e) {
            System.err.println("대여 목록을 가져오는 중 오류 발생: " + e.getMessage());
        }

        return borrowedBooks;
    }

    public boolean rentBook(int bookId, String sno) {
        // 대여 기록을 추가하는 SQL
        String insertRentalSQL = "INSERT INTO rental (book_id, sno, borrow_date, return_date, returned) VALUES (?, ?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), false)";
        
        // 책 상태를 "대여 불가"로 업데이트하는 SQL
        String updateBookSQL = "UPDATE book SET available = false WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement insertRentalStmt = conn.prepareStatement(insertRentalSQL);
             PreparedStatement updateBookStmt = conn.prepareStatement(updateBookSQL)) {
            
            // 트랜잭션 시작
            conn.setAutoCommit(false);

            // 대여 기록 추가
            insertRentalStmt.setInt(1, bookId);
            insertRentalStmt.setString(2, sno);
            insertRentalStmt.executeUpdate();

            // 책 상태 업데이트
            updateBookStmt.setInt(1, bookId);
            updateBookStmt.executeUpdate();

            // 트랜잭션 커밋
            conn.commit();

            return true;
        } catch (SQLException e) {
            System.err.println("도서를 대여하는 중 오류 발생: " + e.getMessage());
            return false;
        }
    }

    // 도서 반납 처리
    public boolean returnBook(int bookId, String sno) {
        String updateRentalSQL = "UPDATE rental SET returned = true, return_date = CURDATE() WHERE book_id = ? AND sno = ? AND returned = false";
        String updateBookSQL = "UPDATE book SET available = true WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement updateRentalStmt = conn.prepareStatement(updateRentalSQL);
             PreparedStatement updateBookStmt = conn.prepareStatement(updateBookSQL)) {

            // 트랜잭션 시작
            conn.setAutoCommit(false);

            // 대여 기록 업데이트
            updateRentalStmt.setInt(1, bookId);
            updateRentalStmt.setString(2, sno);
            int rentalUpdated = updateRentalStmt.executeUpdate();

            if (rentalUpdated == 0) {
                conn.rollback();
                return false; // 대여 기록이 없거나 이미 반납된 경우
            }

            // 책 상태 업데이트
            updateBookStmt.setInt(1, bookId);
            updateBookStmt.executeUpdate();

            // 트랜잭션 커밋
            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("도서를 반납하는 중 오류 발생: " + e.getMessage());
            return false;
        }
    }

    
    public void updateOverdueBooksAsReturned() {
        String sql = "UPDATE rental SET returned = true WHERE return_date < CURDATE() AND returned = false";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("기한 초과 도서를 자동 반납 처리했습니다: " + rowsUpdated + "건");
            }
        } catch (SQLException e) {
            System.err.println("기한 초과 도서를 반납 처리하는 중 오류 발생: " + e.getMessage());
        }
        
    }
    
    public List<Book> getRentalHistory(String sno) {
        List<Book> rentalHistory = new ArrayList<>();
        String sql = "SELECT b.id, b.title, b.author, b.publisher, b.image_path, r.borrow_date, r.return_date " +
                     "FROM book b " +
                     "JOIN rental r ON b.id = r.book_id " +
                     "WHERE r.sno = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, sno);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("publisher"),
                        true, // available은 의미 없음
                        rs.getString("image_path")
                    );
                    book.setBorrowDate(rs.getDate("borrow_date"));
                    book.setReturnDate(rs.getDate("return_date"));
                    rentalHistory.add(book);
                }
            }
        } catch (SQLException e) {
            System.err.println("대여 이력을 가져오는 중 오류 발생: " + e.getMessage());
        }

        return rentalHistory;
    }
    
    public List<Book> searchBooks(String query) {
        List<Book> resultList = new ArrayList<>();
        
        // 쿼리로 제목이나 저자에서 검색 로직 구현
        // 예시로 가상의 데이터베이스 접근을 통해 검색을 진행한다고 가정
        for (Book book : getAllBooks()) {
            if (book.getTitle().toLowerCase().contains(query.toLowerCase()) || 
                book.getAuthor().toLowerCase().contains(query.toLowerCase())) {
                resultList.add(book);
            }
        }
        return resultList;
    }
    
    private RentalStatusCheckService rentalStatusChecker = new RentalStatusCheckService();

    public List<BookRentalList> getBooksWithRentalStatus(String sno) {
        // 기존의 getAllBooks() 메서드 로직
        List<Book> books = getAllBooks();
        
        // 사용자의 대여 중인 책 ID 가져오기
        Set<Integer> rentedBookIds = rentalStatusChecker.getUserRentedBookIds(sno);
        
        // BookRentalDTO로 변환
        return books.stream()
            .map(book -> new BookRentalList(book, rentedBookIds.contains(book.getId())))
            .collect(Collectors.toList());
    }


    public boolean isRentedByCurrentUser(int bookId, String sno) {
        String sql = "SELECT COUNT(*) FROM rental WHERE book_id = ? AND sno = ? AND returned = false";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookId);
            pstmt.setString(2, sno);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // 대여 중이면 true 반환
                }
            }
        } catch (SQLException e) {
            System.err.println("사용자의 대여 상태를 확인하는 중 오류 발생: " + e.getMessage());
        }

        return false;
    }
    
}
