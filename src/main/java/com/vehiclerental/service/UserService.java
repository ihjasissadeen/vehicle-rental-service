package com.vehiclerental.service;

import com.vehiclerental.model.User;
import com.vehiclerental.FileHandler;
import com.vehiclerental.util.PasswordUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class UserService
{


    //add new user
    public void addUser(User user, String filePath)
    {
        try
        {
            //dispaly file path
            System.out.println("ATTENTION : Securely saving data to -> " + filePath);

            //hash the password before it ever touches disk
            if (!PasswordUtil.isHashed(user.getPassword())) {
                user.setPassword(PasswordUtil.hash(user.getPassword()));
            }

            //atomically assign the next id and save user data (avoids duplicate IDs under concurrent requests)
            int nextId = FileHandler.appendWithNextId(filePath, id -> {
                user.setId(id);
                return user.toFileString();
            });
            user.setId(nextId);

            //done message
            System.out.println("SUCCESS : File writing complete!");

        }
        catch (IOException e)
        {
            //print error if operation fail
            e.printStackTrace();
        }
    }

    //read all users
    public ArrayList<User> getUsers(String filePath)
    {
        //create array list to store users
        ArrayList<User> users = new ArrayList<>();

        try
        {
            //read all lines
            List<String> lines = FileHandler.readAll(filePath);

            //loop through each line
            for (String line : lines)
            {
                //split line
                String[] data = line.split(",");

                //create user object
                User user = User.createUser
                        (Integer.parseInt(data[0]), //id
                        data[1], //name
                        data[2], //email
                        data[3], //password
                        data[4] //role
                );
                //add usre object to list
                users.add(user);
            }
        }

        catch (IOException e)
        {
            //print erroe if reading fail
            e.printStackTrace();
        }
        return users;
    }

    //login validation, check email & pw is correct
    public boolean login(String email, String password, String filePath)
    {
        return validateUser(email, password, filePath) != null;
    }

    //validate user & return object,return user object if login done
    public User validateUser(String email, String password, String filePath)
    {
        ArrayList<User> users = getUsers(filePath);
        //get all users
        for (User u : users)
        {
            //check mail & pw
            if (u.getEmail().equals(email) && PasswordUtil.verify(password, u.getPassword()))
            {
                //transparently upgrade legacy plaintext passwords to a hash on next successful login
                if (!PasswordUtil.isHashed(u.getPassword())) {
                    u.setPassword(PasswordUtil.hash(password));
                    updateUser(u, filePath);
                }
                //return matching user
                return u;
            }
        }
        //not found
        return null;
    }

    //get user by id,find user
    public User getUserById(int id, String filePath)
    {
        //get all users
        ArrayList<User> users = getUsers(filePath);
        //search user
        for (User u : users)
        {
            //compare id
            if (u.getId() == id)
            {
                //matching user
                return u;
            }
        }
        //not found
        return null;
    }

    //update existing user details
    public void updateUser(User updatedUser, String filePath)
    {
        try {
            //hash the password if it isn't already a stored hash (e.g. a freshly submitted plaintext password)
            if (!PasswordUtil.isHashed(updatedUser.getPassword())) {
                updatedUser.setPassword(PasswordUtil.hash(updatedUser.getPassword()));
            }

            //read all line
            List<String> lines = FileHandler.readAll(filePath);
            //create new list
            List<String> newLines = new ArrayList<>();

            for (String line : lines)
            {
                String[] parts = line.split(",");
                //get user id
                int userId = Integer.parseInt(parts[0]);
                //if matching user found
                if (userId == updatedUser.getId())
                {
                    //add updated user data
                    newLines.add(updatedUser.toFileString());
                }
                else
                {
                    //keep old data
                    newLines.add(line);
                }
            }
            //rewrite updated data
            FileHandler.writeAll(filePath, newLines);
        }
        catch (IOException e)
        {
            //error print
            e.printStackTrace();
        }
    }

    //delete user using id
    public void deleteUser(int id, String filePath)
    {
        try
        {
            //;read all lines
            List<String> lines = FileHandler.readAll(filePath);
            //create new list
            List<String> newLines = new ArrayList<>();

            for (String line : lines)
            {
                String[] parts = line.split(",");
                //get user id
                int userId = Integer.parseInt(parts[0]);
                //keep onl;y users(dont match delete id)
                if (userId != id)
                {
                    //add remain users
                    newLines.add(line);
                }
            }
            //save update data
            FileHandler.writeAll(filePath, newLines);
        }
        catch (IOException e)
        {
            //print error
            e.printStackTrace();
        }
    }
}