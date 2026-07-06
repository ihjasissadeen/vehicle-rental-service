package com.vehiclerental.model;

public abstract class Payment {

    private int id;
    private int bookingId;
    private double amount;
    private String date;
    private String status;
    private String type;

    public Payment(int id, int bookingId, double amount, String date, String status, String type) {
        this.id = id;
        this.bookingId = bookingId;
        this.amount = amount;
        this.date = date;
        this.status = status;
        this.type = type;
    }

    // Encapsulated getters & setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    // Polymorphic method overridden by subclasses
    public abstract String generateReceipt();
}
