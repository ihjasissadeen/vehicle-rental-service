package com.vehiclerental.service;

import com.vehiclerental.FileHandler; //file read/write
import com.vehiclerental.model.Vehicle; //vehicle objects
import java.io.IOException; // catch the file errors
import java.util.ArrayList; // create resizable list
import java.util.List; // declare the list type
import com.vehiclerental.service.VehicleDetailsService;
import com.vehiclerental.model.Car;
import com.vehiclerental.model.Bike;
import com.vehiclerental.model.Van;

public class VehicleService {

    // path to the text file where vehicle records are stored
    private final String filePath;

    public VehicleService() {
        this("data/vehicles.txt");
    }

    // Package-visible constructor letting tests point this service at an isolated file
    VehicleService(String filePath) {
        this.filePath = filePath;
    }

    // Add Vehicle (CREATE)
    public void addVehicle(Vehicle vehicle) {
        try {

            // Atomically assign the next id and append the record (avoids duplicate IDs under concurrent requests)
            int newId = FileHandler.appendWithNextId(filePath, id -> id + "," +
                    vehicle.getBrand() + "," +
                    vehicle.getType() + "," +
                    vehicle.getPricePerDay() + "," +
                    vehicle.isAvailable());
            vehicle.setId(newId);

            // display the error details when file handling
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Get All Vehicles (READ)
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        VehicleDetailsService detailsService = new VehicleDetailsService();

        try {
            // read all lines from the file
            List<String> lines = FileHandler.readAll(filePath);

            for (String line : lines) {
                String[] parts = line.split(",");

                String type = parts[2];
                Vehicle v;

                if (type.equalsIgnoreCase("Car")) {
                    v = new Car(
                            Integer.parseInt(parts[0]), parts[1], type,
                            Double.parseDouble(parts[3]), Boolean.parseBoolean(parts[4]), "Petrol/Diesel"
                    );
                } else if (type.equalsIgnoreCase("Bike")) {
                    v = new Bike(
                            Integer.parseInt(parts[0]), parts[1], type,
                            Double.parseDouble(parts[3]), Boolean.parseBoolean(parts[4]), true
                    );
                } else if (type.equalsIgnoreCase("Van")) {
                    v = new Van(
                            Integer.parseInt(parts[0]), parts[1], type,
                            Double.parseDouble(parts[3]), Boolean.parseBoolean(parts[4]), 14
                    );
                } else {
                    v = new Vehicle(
                            Integer.parseInt(parts[0]), parts[1], type,
                            Double.parseDouble(parts[3]), Boolean.parseBoolean(parts[4])
                    );
                }

                // Attach details from the second file
                v.setDetails(detailsService.getDetailsByVehicleId(v.getId()));

                vehicles.add(v);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    // Get Vehicle by ID
    public Vehicle getVehicleById(int id) {
        List<Vehicle> vehicles = getAllVehicles();

        for (Vehicle v : vehicles) {
            if (v.getId() == id) {
                return v;
            }
        }
        return null;
    }

    // Update Vehicle (UPDATE)
    public void updateVehicle(Vehicle updatedVehicle) {
        try {
            List<String> lines = FileHandler.readAll(filePath);
            List<String> newLines = new ArrayList<>();

            for (String line : lines) {
                String[] parts = line.split(",");
                int vehicleId = Integer.parseInt(parts[0]);

                if (vehicleId == updatedVehicle.getId()) {
                    //replace line with new data
                    String newLine = updatedVehicle.getId() + "," +
                            updatedVehicle.getBrand() + "," +
                            updatedVehicle.getType() + "," +
                            updatedVehicle.getPricePerDay() + "," +
                            updatedVehicle.isAvailable();

                    newLines.add(newLine);
                } else {
                    newLines.add(line);// keep all other lines unchanged
                }
            }

            FileHandler.writeAll(filePath, newLines); // write everything back

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Delete Vehicle (DELETE)
    public void deleteVehicle(int id) {
        try {
            // Cascading Delete — Delete specifications first to enforce Composition lifetime dependency!
            VehicleDetailsService detailsService = new VehicleDetailsService();
            detailsService.deleteDetails(id);

            List<String> lines = FileHandler.readAll(filePath);
            List<String> newLines = new ArrayList<>();

            for (String line : lines) {
                String[] parts = line.split(",");
                int vehicleId = Integer.parseInt(parts[0]);

                if (vehicleId != id) {
                    newLines.add(line); // only keep lines that don't match
                }
            }

            FileHandler.writeAll(filePath, newLines);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Search Vehicles by Brand or Type
    public List<Vehicle> searchVehicles(String keyword) {
        List<Vehicle> results = new ArrayList<>();
        List<Vehicle> vehicles = getAllVehicles();

        for (Vehicle v : vehicles) {
            if (v.getBrand().toLowerCase().contains(keyword.toLowerCase())
                    || v.getType().toLowerCase().contains(keyword.toLowerCase())) {
                results.add(v);
            }
        }

        return results;
    }
}
