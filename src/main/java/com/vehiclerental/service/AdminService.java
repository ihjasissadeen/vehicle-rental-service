package com.vehiclerental.service;

import com.vehiclerental.model.User;
import com.vehiclerental.FileHandler;

import java.io.IOException;
import java.util.List;

public class AdminService {

    // 1. Security Login Check
    public boolean authenticateAdmin(String email, String password, String filePath) {
        try {
            List<String> lines = FileHandler.readAll(filePath);
            for (String line : lines) {
                String[] parts = line.split(",");
                // email,password,role
                if (parts.length >= 5) {
                    if (parts[2].trim().equals(email) &&
                            parts[3].trim().equals(password) &&
                            parts[4].trim().equalsIgnoreCase("admin")) {
                        return true; // Match found == they are an admin
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false; // Failed password OR they are just a customer
    }

    // Registering a New Admin
    public void addAdmin(User admin, String filePath) {
        try {
            // Get the next ID automatically using your team's FileHandler
            int nextId = FileHandler.getNextId(filePath);
            admin.setId(nextId);

            // Format the text line
            String record = admin.getId() + "," + admin.getName() + "," +
                    admin.getEmail() + "," + admin.getPassword() + "," + admin.getRole();

            FileHandler.appendLine(filePath, record);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}