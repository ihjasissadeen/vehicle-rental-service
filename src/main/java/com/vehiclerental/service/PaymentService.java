package com.vehiclerental.service;

import com.vehiclerental.FileHandler;
import com.vehiclerental.model.Payment;
import com.vehiclerental.model.CardPayment;
import com.vehiclerental.model.CashPayment;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class PaymentService {

    private static final String FILE_PATH = "data/payments.txt";

    // READ — get all payments (instantiates subclasses polymorphically!)
    public List<Payment> getAllPayments() throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<Payment> payments = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",", -1);
            if (parts.length < 8) continue;

            // Skip CSV Header
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                continue;
            }

            try {
                int id = Integer.parseInt(parts[0].trim());
                int bookingId = Integer.parseInt(parts[1].trim());
                double amount = Double.parseDouble(parts[2].trim());
                String date = parts[3].trim();
                String status = parts[4].trim();
                String type = parts[5].trim();
                String detail1 = parts[6].trim();
                String detail2 = parts[7].trim();

                Payment p;
                if ("card".equalsIgnoreCase(type)) {
                    p = new CardPayment(id, bookingId, amount, date, status, detail1, detail2);
                } else {
                    p = new CashPayment(id, bookingId, amount, date, status, detail1, detail2);
                }
                payments.add(p);
            } catch (NumberFormatException e) {
                // Ignore any corrupted rows to prevent crashes
                e.printStackTrace();
            }
        }
        return payments;
    }

    // READ — get a single payment by its ID
    public Payment getPaymentById(int paymentId) throws IOException {
        List<Payment> all = getAllPayments();
        for (Payment p : all) {
            if (p.getId() == paymentId) {
                return p;
            }
        }
        return null;
    }

    // READ — get payment by Booking ID
    public Payment getPaymentByBookingId(int bookingId) throws IOException {
        List<Payment> all = getAllPayments();
        for (Payment p : all) {
            if (p.getBookingId() == bookingId) {
                return p;
            }
        }
        return null;
    }

    // CREATE — write a new payment to flat file
    // Synchronized on FileHandler.class (the same lock FileHandler.getNextId/appendWithNextId use) so the
    // id-scan-then-append sequence below can't race with another thread and hand out a duplicate id.
    public void addPayment(Payment p) throws IOException {
        synchronized (FileHandler.class) {
            List<Payment> all = getAllPayments();
            int nextId = 1;
            for (Payment pay : all) {
                if (pay.getId() >= nextId) {
                    nextId = pay.getId() + 1;
                }
            }
            p.setId(nextId);

            String detail1 = "";
            String detail2 = "";

            if (p instanceof CardPayment) {
                CardPayment cp = (CardPayment) p;
                detail1 = cp.getCardNumber();
                detail2 = cp.getTransactionId();
            } else if (p instanceof CashPayment) {
                CashPayment csp = (CashPayment) p;
                detail1 = csp.getBranchLocation();
                detail2 = csp.getEmployeeId();
            }

            // Sanitize fields against comma injection
            detail1 = detail1 != null ? detail1.replace(",", ";") : "";
            detail2 = detail2 != null ? detail2.replace(",", ";") : "";

            String line = p.getId() + "," +
                         p.getBookingId() + "," +
                         p.getAmount() + "," +
                         p.getDate() + "," +
                         p.getStatus() + "," +
                         p.getType() + "," +
                         detail1 + "," +
                         detail2;

            FileHandler.appendLine(FILE_PATH, line);
        }
    }

    // UPDATE — update payment status in flat file
    public void updatePaymentStatus(int paymentId, String status) throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",", -1);
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                updated.add(line); // keep the header
                continue;
            }
            try {
                if (Integer.parseInt(parts[0].trim()) == paymentId) {
                    // Update the status column (index 4)
                    String newLine = parts[0].trim() + "," +
                                     parts[1].trim() + "," +
                                     parts[2].trim() + "," +
                                     parts[3].trim() + "," +
                                     status + "," +
                                     parts[5].trim() + "," +
                                     parts[6].trim() + "," +
                                     parts[7].trim();
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

    // DELETE — void a payment
    public void deletePayment(int paymentId) throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",", -1);
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                updated.add(line); // keep the header
                continue;
            }
            try {
                if (Integer.parseInt(parts[0].trim()) != paymentId) {
                    updated.add(line);
                }
            } catch (NumberFormatException e) {
                updated.add(line);
            }
        }
        FileHandler.writeAll(FILE_PATH, updated);
    }

    // DELETE — void a payment by its associated Booking ID to support Cascading Deletes
    public void deletePaymentByBookingId(int bookingId) throws IOException {
        List<String> lines = FileHandler.readAll(FILE_PATH);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split(",", -1);
            if ("id".equalsIgnoreCase(parts[0].trim())) {
                updated.add(line); // keep the header
                continue;
            }
            try {
                if (Integer.parseInt(parts[1].trim()) != bookingId) {
                    updated.add(line);
                }
            } catch (NumberFormatException e) {
                updated.add(line);
            }
        }
        FileHandler.writeAll(FILE_PATH, updated);
    }
}
