package com.vehiclerental.model;

// CardPayment inherits from the main Payment class
public class CardPayment extends Payment {

    private String cardNumber;
    private String transactionId;

    // Constructor to set up a card payment
    public CardPayment(int id, int bookingId, double amount, String date, String status, String cardNumber,
            String transactionId) {
        // Pass common fields to parent class and force type to "card"
        super(id, bookingId, amount, date, status, "card");
        this.cardNumber = cardNumber;
        this.transactionId = transactionId;
    }

    // Get the card number
    public String getCardNumber() {
        return cardNumber;
    }

    // Set the card number
    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    // Get the transaction reference ID
    public String getTransactionId() {
        return transactionId;
    }

    // Set the transaction reference ID
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    // Hides the full card number and only shows the last 4 digits for security
    public String getMaskedCardNumber() {
        if (cardNumber == null || cardNumber.isEmpty())
            return "****";
        String clean = cardNumber.replace("-", "").replace(" ", "");
        if (clean.length() < 4)
            return "****";
        return "**** **** **** " + clean.substring(clean.length() - 4);
    }

    // Generates a text receipt for this card payment
    @Override
    public String generateReceipt() {
        return "💳 Card Payment processed successfully via Secure Gateway. Card: " + getMaskedCardNumber()
                + " (Transaction Ref: " + transactionId + ")";
    }
}