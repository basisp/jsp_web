package com.library.models;

public class BookRentalList extends Book {
    private boolean isRentedByCurrentUser;

    public BookRentalList(Book book, boolean isRentedByCurrentUser) {
        super(book.getId(), book.isAvailable());
        this.isRentedByCurrentUser = isRentedByCurrentUser;
    }

    public boolean isRentedByCurrentUser() {
        return isRentedByCurrentUser;
    }
}
