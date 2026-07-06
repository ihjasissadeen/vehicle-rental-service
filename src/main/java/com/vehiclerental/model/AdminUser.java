package com.vehiclerental.model;

// AdminUser inherits from the main User class
public class AdminUser extends User {

    private String adminRole;

    public AdminUser(int id, String name, String email, String password, String adminRole) {
        // Pass details to parent constructor and force the system role to "admin"
        super(id, name, email, password, "admin");
        this.adminRole = adminRole;
    }

    // Get the admin role
    public String getAdminRole() {
        return adminRole;
    }

    // Set the admin role
    public void setAdminRole(String adminRole) {
        this.adminRole = adminRole;
    }

    // Method to simulate admin management activity
    public void manageSystem() {
        System.out.println("Admin " + getName() + " is managing the system.");
    }

    // Returns the dashboard URL for this specific user type
    @Override
    public String getDashboardRedirectURL() {
        return "admin?action=dashboard";
    }
}
