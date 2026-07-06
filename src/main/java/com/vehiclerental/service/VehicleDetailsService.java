package com.vehiclerental.service;

import com.vehiclerental.FileHandler;
import com.vehiclerental.model.VehicleDetails;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class VehicleDetailsService {

    private final String filePath = "data/vehicle_details.txt";

    public void saveDetails(VehicleDetails details) {
        try {
            // First try to update if exists
            List<String> lines = FileHandler.readAll(filePath);
            List<String> newLines = new ArrayList<>();
            boolean updated = false;

            for (String line : lines) {
                String[] parts = line.split(",");
                if (parts.length >= 1 && Integer.parseInt(parts[0]) == details.getVehicleId()) {
                    newLines.add(formatLine(details));
                    updated = true;
                } else {
                    newLines.add(line);
                }
            }

            if (updated) {
                FileHandler.writeAll(filePath, newLines);
            } else {
                FileHandler.appendLine(filePath, formatLine(details));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public VehicleDetails getDetailsByVehicleId(int vehicleId) {
        try {
            List<String> lines = FileHandler.readAll(filePath);
            for (String line : lines) {
                String[] parts = line.split(",");
                if (parts.length >= 5 && Integer.parseInt(parts[0]) == vehicleId) {
                    return new VehicleDetails(
                            vehicleId,
                            parts[1], // fuelType
                            Integer.parseInt(parts[2]), // seatingCapacity
                            Boolean.parseBoolean(parts[3]), // hasAc
                            Boolean.parseBoolean(parts[4]) // hasGear
                    );
                }
            }
        } catch (IOException e) {
            // File might not exist yet, that's okay
        }
        return null; // No details found
    }

    private String formatLine(VehicleDetails d) {
        return d.getVehicleId() + "," + d.getFuelType() + "," + d.getSeatingCapacity() + "," + d.isHasAc() + "," + d.isHasGear();
    }

    // Cascading Delete — Models Composition lifetime dependency!
    public void deleteDetails(int vehicleId) {
        try {
            List<String> lines = FileHandler.readAll(filePath);
            List<String> newLines = new ArrayList<>();
            for (String line : lines) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 1 && Integer.parseInt(parts[0].trim()) == vehicleId) {
                    continue; // Skip/delete matching specifications record!
                }
                newLines.add(line);
            }
            FileHandler.writeAll(filePath, newLines);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
