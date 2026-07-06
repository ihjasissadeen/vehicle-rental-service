package com.vehiclerental.service;

import com.vehiclerental.model.Car;
import com.vehiclerental.model.Vehicle;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class VehicleServiceTest {

    private VehicleService vehicleService;

    @TempDir
    Path tempDir;

    @BeforeEach
    void setUp() {
        // Package-private constructor points the service at an isolated temp file instead of the real data/ dir
        vehicleService = new VehicleService(tempDir.resolve("vehicles.txt").toString());
    }

    @Test
    void addVehicle_assignsSequentialIdsAndPersists() {
        vehicleService.addVehicle(new Vehicle(0, "Toyota", "Car", 5000, true));
        vehicleService.addVehicle(new Vehicle(0, "Honda", "Bike", 1500, true));

        List<Vehicle> all = vehicleService.getAllVehicles();
        assertEquals(2, all.size());
        assertEquals(1, all.get(0).getId());
        assertEquals(2, all.get(1).getId());
    }

    @Test
    void getAllVehicles_buildsCorrectSubclassByType() {
        vehicleService.addVehicle(new Vehicle(0, "Toyota", "Car", 5000, true));

        Vehicle v = vehicleService.getVehicleById(1);
        assertInstanceOf(Car.class, v);
    }

    @Test
    void deleteVehicle_removesOnlyTheMatchingRecord() {
        vehicleService.addVehicle(new Vehicle(0, "Toyota", "Car", 5000, true));
        vehicleService.addVehicle(new Vehicle(0, "Honda", "Bike", 1500, true));

        vehicleService.deleteVehicle(1);

        List<Vehicle> remaining = vehicleService.getAllVehicles();
        assertEquals(1, remaining.size());
        assertEquals("Honda", remaining.get(0).getBrand());
    }

    @Test
    void searchVehicles_matchesByBrandOrType() {
        vehicleService.addVehicle(new Vehicle(0, "Toyota", "Car", 5000, true));
        vehicleService.addVehicle(new Vehicle(0, "Honda", "Bike", 1500, true));

        assertEquals(1, vehicleService.searchVehicles("toyota").size());
        assertEquals(1, vehicleService.searchVehicles("bike").size());
        assertEquals(0, vehicleService.searchVehicles("van").size());
    }
}
