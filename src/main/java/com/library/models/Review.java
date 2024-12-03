package com.library.models;

public class Review {
	private int id;
	private int book_id;
	private int user_id;
	private int rating;
	private String review_text;
	
	
	public Review(int book_id, int user_id, int rating, String review_text) {
		super();
		this.book_id = book_id;
		this.user_id = user_id;
		this.rating = rating;
		this.review_text = review_text;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getBook_id() {
		return book_id;
	}
	public void setBook_id(int book_id) {
		this.book_id = book_id;
	}
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public String getReview_text() {
		return review_text;
	}
	public void setReview_text(String review_text) {
		this.review_text = review_text;
	}
	
	
}
