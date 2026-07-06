package com.vehiclerental.model;

public class VehicleDetails {
    private int vehicleId;
    private String fuelType;
    private int seatingCapacity;
    private boolean hasAc;
    private boolean hasGear;

    public VehicleDetails() {}

    public VehicleDetails(int vehicleId, String fuelType, int seatingCapacity, boolean hasAc, boolean hasGear) {
        this.vehicleId = vehicleId;
        this.fuelType = fuelType;
        this.seatingCapacity = seatingCapacity;
        this.hasAc = hasAc;
        this.hasGear = hasGear;
    }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public int getSeatingCapacity() { return seatingCapacity; }
    public void setSeatingCapacity(int seatingCapacity) { this.seatingCapacity = seatingCapacity; }

    public boolean isHasAc() { return hasAc; }
    public void setHasAc(boolean hasAc) { this.hasAc = hasAc; }

    public boolean isHasGear() { return hasGear; }
    public void setHasGear(boolean hasGear) { this.hasGear = hasGear; }
}
