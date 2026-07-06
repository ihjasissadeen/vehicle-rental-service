package com.vehiclerental.model;

public class VerifiedReview extends Review {

    public VerifiedReview(int id, int userId, int vehicleId, int rating, String comment) {
        super(id, userId, vehicleId, rating, comment, "verified");
    }

    @Override
    public String displayReview() {
        return "[✓ Verified Renter] User " + getUserName() + " rated " + getRating() + "/5: " + getComment();
    }
}