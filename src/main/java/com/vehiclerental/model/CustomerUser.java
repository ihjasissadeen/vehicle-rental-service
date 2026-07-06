package com.vehiclerental.model;

public class CustomerUser extends User
{
    private String customerType;

    //default Constructor
    public CustomerUser()
    {
        //call parent class
        super();
    }

    // Parameterized constructor
    public CustomerUser(int id, String name, String email, String password, String customerType)
    {
        //call parent class
        super(id, name, email, password, "customer");

        //assign customer type
        this.customerType = customerType;
    }

    //getter & setter

    public String getCustomerType()
    {
        return customerType;
    }

    public void setCustomerType(String customerType)
    {
        this.customerType = customerType;
    }

    //booking vehicle method
    public void bookVehicle()
    {
        System.out.println("Customer " + getName() + " is booking a vehicle.");
    }

    @Override
    public String getDashboardRedirectURL() {
        return "index.jsp";
    }
}
