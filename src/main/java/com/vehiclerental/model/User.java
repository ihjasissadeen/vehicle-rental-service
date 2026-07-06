package com.vehiclerental.model;

public abstract class User
{
    //Instance Variables
    protected int id;
    protected String name;
    protected String email;
    protected String password;

    private String role;

    //default Constructor
    public User()
    {

    }

    //parameterized Constructor
    public User(int id, String name, String email, String password, String role)
    {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    //abstract method to
    public abstract String getDashboardRedirectURL();

    //static factory method to create objects
    public static User createUser(int id, String name, String email, String password, String role)
    {
        //if role is admin
        if ("admin".equalsIgnoreCase(role))
        {
            //create admin user object
            return new AdminUser(id, name, email, password, "SystemAdmin");
        }
        else
        {
            //create customeruser object
            return new CustomerUser(id, name, email, password, "Standard");
        }
    }



    // Getters & Setters

    public int getId()
    {
        return id;
    }

    public String getName()
    {
        return name;
    }

    public String getEmail()
    {
        return email;
    }

    public String getPassword()
    {
        return password;
    }

    public String getRole()
    {
        return role;
    }

    public void setId(int id)
    {
        this.id = id;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public void setRole(String role)
    {
        this.role = role;
    }

    //convert object data to text file
    public String toFileString()
    {
        return id + "," + name + "," + email + "," + password + "," + role;
    }
}
