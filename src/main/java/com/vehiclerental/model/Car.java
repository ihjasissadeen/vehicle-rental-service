package com.vehiclerental.model;

//Car class inherits from Vehicle class
public class Car extends Vehicle {
    private String fuelType; //Specific property for car

    public Car(int id, String brand, String type, double pricePerDay, boolean available, String fuelType) {
        super(id, brand, type, pricePerDay, available); //super() connects this class to the Vehicle class constructor
        this.fuelType = fuelType;
    }

    //Getter foe fuelType
    public String getFuelType() {
        return fuelType;
    }

    //Setter for fuelType
    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    @Override
    public String getDescription() {
        if (getDetails() != null) {
            return "Car: " + getBrand() + " running on " + getDetails().getFuelType() + (getDetails().isHasAc() ? " (AC)" : " (Non-AC)");
        }
        return "Car: " + getBrand() + " running on " + fuelType;
    }
}
