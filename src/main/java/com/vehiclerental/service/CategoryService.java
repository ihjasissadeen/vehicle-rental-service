package com.vehiclerental.service;

import com.vehiclerental.model.Category;
import com.vehiclerental.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Service layer → handles business logic
public class CategoryService {

    // File path where data is stored
    private final String path = "data/categories.txt";

    // CREATE → add new category
    public void addCategory(String name, String desc) throws IOException {
        // Atomically assign the next id and append the record (avoids duplicate IDs under concurrent requests)
        FileHandler.appendWithNextId(path, id -> new Category(id, name, desc).toFileString());
    }

    // READ → get all categories
    public List<Category> getAll() throws IOException {
        List<String> lines = FileHandler.readAll(path);
        List<Category> list = new ArrayList<>();

        // convert each line → Category object
        for (String line : lines) {
            list.add(Category.fromString(line));
        }

        return list;
    }

    // UPDATE → update category
    public void update(int id, String name, String desc) throws IOException {
        List<String> lines = FileHandler.readAll(path);
        List<String> updated = new ArrayList<>();

        for (String line : lines) {
            Category c = Category.fromString(line);

            if (c.getId() == id) {
                c.setName(name);
                c.setDescription(desc);
                updated.add(c.toFileString());
            } else {
                updated.add(line);
            }
        }

        FileHandler.writeAll(path, updated);
    }

    // DELETE → delete category with Referential Integrity check!
    public void delete(int id) throws IOException {
        Category targetCategory = getById(id);
        if (targetCategory == null) {
            return;
        }

        // Integrity Check: Ensure no active vehicle is registered under this category!
        com.vehiclerental.service.VehicleService vehicleService = new com.vehiclerental.service.VehicleService();
        List<com.vehiclerental.model.Vehicle> activeVehicles = vehicleService.getAllVehicles();
        for (com.vehiclerental.model.Vehicle vehicle : activeVehicles) {
            if (vehicle.getType().equalsIgnoreCase(targetCategory.getName())) {
                throw new IllegalStateException("Cannot delete Category '" + targetCategory.getName() +
                        "' because active vehicles are currently classified under it. Reassign those vehicles first.");
            }
        }

        List<String> lines = FileHandler.readAll(path);
        List<String> updated = new ArrayList<>();

        for (String line : lines) {
            Category c = Category.fromString(line);

            if (c.getId() != id) {
                updated.add(line);
            }
        }

        FileHandler.writeAll(path, updated);
    }

    // READ SINGLE RECORD → fetch category by its ID
    public Category getById(int id) throws IOException {
        List<Category> allCategories = getAll();
        for (Category c : allCategories) {
            if (c.getId() == id) {
                return c;
            }
        }
        return null;
    }
}
