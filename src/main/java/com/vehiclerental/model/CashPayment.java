package com.vehiclerental.model;

public class CashPayment extends Payment {

    private String branchLocation;
    private String employeeId;

    public CashPayment(int id, int bookingId, double amount, String date, String status, String branchLocation, String employeeId) {
        super(id, bookingId, amount, date, status, "cash");
        this.branchLocation = branchLocation;
        this.employeeId = employeeId;
    }

    public String getBranchLocation() {
        return branchLocation;
    }

    public void setBranchLocation(String branchLocation) {
        this.branchLocation = branchLocation;
    }

    public String getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    @Override
    public String generateReceipt() {
        return "💵 Cash Payment collection scheduled at physical counter. Pickup Branch: " + branchLocation + " (Assigned Counter Representative ID: " + employeeId + ")";
    }
}
