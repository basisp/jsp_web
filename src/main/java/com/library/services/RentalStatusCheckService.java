package com.library.services;

import java.sql.*;
import java.util.HashSet;
import java.util.Set;

public class RentalStatusCheckService {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/mydb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    public Set<Integer> getUserRentedBookIds(String sno) {
        Set<Integer> rentedBookIds = new HashSet<>();
        
        if (sno == null || sno.isEmpty()) {
            return rentedBookIds;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sqlCheckRental = "SELECT book_id FROM rental WHERE sno = ? AND returned = false";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlCheckRental)) {
                pstmt.setString(1, sno);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        rentedBookIds.add(rs.getInt("book_id"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rentedBookIds;
    }
}
