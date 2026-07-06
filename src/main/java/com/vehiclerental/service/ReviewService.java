package com.vehiclerental.service;

import com.vehiclerental.FileHandler;
import com.vehiclerental.model.Review;
import com.vehiclerental.model.PublicReview;
import com.vehiclerental.model.VerifiedReview;
import com.vehiclerental.model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReviewService {

    private static final String FILE_PATH = "data/reviews.txt";

    // CREATE — add a new review with automatic transactional verification check!
    public void addReview(int userId, int vehicleId, int rating, String comment) throws IOException {
        // Verification Logic: Auto-detect if user has an approved booking for this vehicle!
        String type = "public";
        try {
            com.vehiclerental.service.BookingService bookingService = new com.vehiclerental.service.BookingService();
            List<com.vehiclerental.model.Booking> bookings = bookingService.getAllBookings();
            for (com.vehiclerental.model.Booking b : bookings) {
                if (b.getUserId() == userId && b.getVehicleId() == vehicleId && "approved".equalsIgnoreCase(b.getStatus())) {
                    type = "verified";
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String finalType = type;
        // Atomically assign the next id and append the record (avoids duplicate IDs under concurrent requests)
        FileHandler.appendWithNextId(FILE_PATH, id -> {
            Review r = "verified".equalsIgnoreCase(finalType)
                    ? new VerifiedReview(id, userId, vehicleId, rating, comment)
                    : new PublicReview(id, userId, vehicleId, rating, comment);
            return r.getId() + "," + r.getUserId() + "," + r.getVehicleId() + "," + r.getRating() + "," + r.getComment() + "," + r.getType();
        });
    }

    // READ — get all reviews (instantiates subclasses polymorphically!)
    public List<Review> getAllReviews() throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<Review> reviews = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",");
            if (parts.length < 6) continue;

            // Skip CSV Header or any corrupted headers!
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                continue;
            }

            try {
                int id = Integer.parseInt(parts[0].trim());
                int userId = Integer.parseInt(parts[1].trim());
                int vehicleId = Integer.parseInt(parts[2].trim());
                int rating = Integer.parseInt(parts[3].trim());
                String comment = parts[4].trim();
                String type = parts[5].trim();

                Review r;
                if ("verified".equalsIgnoreCase(type)) {
                    r = new VerifiedReview(id, userId, vehicleId, rating, comment);
                } else {
                    r = new PublicReview(id, userId, vehicleId, rating, comment);
                }
                reviews.add(r);
            } catch (NumberFormatException e) {
                // Ignore any corrupted rows to prevent page crashes
                e.printStackTrace();
            }
        }

        // Resolve display names in one batch lookup (keeps the User service out of the model layer)
        try {
            Map<Integer, String> namesById = new HashMap<>();
            for (User u : new com.vehiclerental.service.UserService().getUsers("data/users.txt")) {
                namesById.put(u.getId(), u.getName());
            }
            for (Review r : reviews) {
                String name = namesById.get(r.getUserId());
                if (name != null) {
                    r.setUserName(name);
                }
            }
        } catch (Exception e) {
            // Keep the safe "User #id" fallback already set on each Review
        }

        return reviews;
    }

    // READ — get reviews for a specific vehicle
    public List<Review> getReviewsByVehicle(int vehicleId) throws IOException {
        List<Review> all = getAllReviews();
        List<Review> filtered = new ArrayList<>();
        for (Review r : all) {
            if (r.getVehicleId() == vehicleId) {
                filtered.add(r);
            }
        }
        return filtered;
    }

    // DELETE — remove a review by id
    public void deleteReview(int reviewId) throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",");
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                updated.add(line); // keep the header!
                continue;
            }
            try {
                if (Integer.parseInt(parts[0].trim()) != reviewId) {
                    updated.add(line);
                }
            } catch (NumberFormatException e) {
                updated.add(line);
            }
        }
        FileHandler.writeAll(FILE_PATH, updated);
    }

    // UPDATE — edit a review's comment and rating
    public void updateReview(int reviewId, int newRating, String newComment) throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",");
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                updated.add(line); // keep the header!
                continue;
            }
            try {
                if (Integer.parseInt(parts[0].trim()) == reviewId) {
                    String sanitizedComment = newComment != null ? newComment.replace(",", ";") : "";
                    String newLine = parts[0].trim() + "," + parts[1].trim() + "," + parts[2].trim() + "," + newRating + "," + sanitizedComment + "," + parts[5].trim();
                    updated.add(newLine);
                } else {
                    updated.add(line);
                }
            } catch (NumberFormatException e) {
                updated.add(line);
            }
        }
        FileHandler.writeAll(FILE_PATH, updated);
    }
}