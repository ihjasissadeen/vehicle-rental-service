package com.vehiclerental.model;

public class Vehicle {

        private int id;
        private String brand;
        private String type;
        private double pricePerDay;
        private boolean available;
        private VehicleDetails details;

        //Default constructor - creates empty vehicle object
        public Vehicle() {

        }

        //parameterized constructor - creates vehicle with all values at once
        public Vehicle(int id, String brand, String type, double pricePerDay, boolean available) {
            this.id = id;
            this.brand = brand;
            this.type = type;
            this.pricePerDay = pricePerDay;
            this.available = available;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getBrand() {
            return brand;
        }

        public void setBrand(String brand) {
            this.brand = brand;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public double getPricePerDay() {
            return pricePerDay;
        }

        public void setPricePerDay(double pricePerDay) {
            this.pricePerDay = pricePerDay;
        }

        // check availability of the vehicle
        public boolean isAvailable() {
            return available;
        }

        //set availability status
        public void setAvailable(boolean available) {
            this.available = available;
        }

        public VehicleDetails getDetails() {
            return details;
        }

        public void setDetails(VehicleDetails details) {
            this.details = details;
        }

        // Method to be overridden by subclasses for polymorphism
        public String getDescription() {
            return brand + " (" + type + ")";
        }
}
