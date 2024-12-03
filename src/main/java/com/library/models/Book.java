package com.library.models;
import java.util.Date;

public class Book {
    private int id;
    private String title;
    private String author;
    private String publisher;
    private boolean available;
    private String imagePath; // 새로 추가
    private Date borrowDate; // 대여일
    private Date returnDate; // 반납 예정일
    private boolean returned;
    private String summary;
    private float rating; // 평균 별점
    private int reviewCount; 
    
    // 생성자, getter, setter 추가
    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    
    
    public Book(int id, boolean available) {
		super();
		this.id = id;
		this.available = available;
	}

	// 기본 생성자
    public Book() {}

    // 전체 매개변수 생성자
    public Book(int id, String title, String author, String publisher, boolean available, String imagePath,float rating, String summary) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.available = available;
        this.imagePath = imagePath;
        this.rating=rating;
        this.summary=summary;
        
    }
    public Book(int id, String title, String author, String publisher, boolean available, String imagePath) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.available = available;
        this.imagePath = imagePath;
        
    }

    // Getter와 Setter 메서드
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
    
    public Date getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Date borrowDate) {
        this.borrowDate = borrowDate;
    }
    
    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }
    
    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }
    
    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}
    
}