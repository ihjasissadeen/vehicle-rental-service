package com.vehiclerental.model;

// Category class representing a vehicle classification (e.g. Luxury Sedan, SUV, Bike, Van)
public class Category {

    private int id;
    private String name;
    private String description;

    // Constructor with built-in comma sanitization to prevent delimiter injection in flat files!
    public Category(int id, String name, String description) {
        this.id = id;
        this.name = name != null ? name.replace(",", ";") : "";
        this.description = description != null ? description.replace(",", ";") : "";
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    // Setters with built-in comma sanitization to ensure data integrity
    public void setName(String name) {
        this.name = name != null ? name.replace(",", ";") : "";
    }

    public void setDescription(String description) {
        this.description = description != null ? description.replace(",", ";") : "";
    }

    // Convert object → text file format (CSV record)
    public String toFileString() {
        return id + "," + name + "," + description;
    }

    // Convert text line → object
    public static Category fromString(String line) {
        String[] parts = line.split(",");
        return new Category(
                Integer.parseInt(parts[0]),
                parts[1],
                parts[2]
        );
    }
}
