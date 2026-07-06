package com.vehiclerental.model;

public class PublicReview extends Review {

    public PublicReview(int id, int userId, int vehicleId, int rating, String comment) {
        super(id, userId, vehicleId, rating, comment, "public");
    }

    @Override
    public String displayReview() {
        return "[Public] User " + getUserName() + " says: " + getComment();
    }
}