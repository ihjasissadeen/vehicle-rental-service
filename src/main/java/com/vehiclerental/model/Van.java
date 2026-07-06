package com.vehiclerental.model;

//Van class inherits from Vehicle class
public class Van extends Vehicle {
    private int seatingCapacity; //number of passengers

    public Van(int id,String brand, String type, double pricePerDay, boolean available, int seatingCapacity ){
        super(id, brand, type, pricePerDay, available);//Connects to the parent constructor with correct parameters
        this.seatingCapacity = seatingCapacity;
    }

    //Getter for seatingCapacity
    public int getSeatingCapacity(){
        return seatingCapacity;
    }

    //Setter for seatingCapacity
    public void setSeatingCapacity(int seatingCapacity){
        this.seatingCapacity = seatingCapacity;
    }

    @Override
    public String getDescription() {
        if (getDetails() != null) {
            return "Van: " + getBrand() + " with " + getDetails().getSeatingCapacity() + " seats" + (getDetails().isHasAc() ? " (AC)" : "");
        }
        return "Van: " + getBrand() + " with " + seatingCapacity + " seats";
    }
}
