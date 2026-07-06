package com.vehiclerental.servlet;

import com.vehiclerental.model.User;
import com.vehiclerental.service.UserService;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/user")
public class UserServlet extends HttpServlet
{
    UserService service = new UserService();

    // Only admins may browse/manage the full user directory
    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect("adminLogin.html");
            return false;
        }
        return true;
    }

    //Handle get requests
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, jakarta.servlet.ServletException {

        // Get action parameter from url
        String action = request.getParameter("action");

        // user data file path
        String dynamicPath = "data/users.txt";

        if ("listUsers".equals(action))
        {
            if (!requireAdmin(request, response)) return;

            // Get all users
            java.util.ArrayList<User> allUsers = service.getUsers(dynamicPath);

            // Send user list to jsp
            request.setAttribute("userList", allUsers);

            // Open userList.jsp
            request.getRequestDispatcher("/WEB-INF/views/userList.jsp").forward(request, response);
        }

        //edit user
        else if ("edit".equals(action))
        {
            if (!requireAdmin(request, response)) return;

            // get user id from url
            int id = Integer.parseInt(request.getParameter("id"));
            // find user by id
            User user = service.getUserById(id, dynamicPath);
            //send user object to jsp
            request.setAttribute("user", user);
            //open edit page
            request.getRequestDispatcher("/WEB-INF/views/editUser.jsp").forward(request, response);
        }

        //delete user
        else if ("delete".equals(action)) {
            if (!requireAdmin(request, response)) return;

            //get user id
            int id = Integer.parseInt(request.getParameter("id"));
            //delete user
            service.deleteUser(id, dynamicPath);
            //redirect to user list
            response.sendRedirect("user?action=listUsers");
        }

        // add user form
        else if ("addUserForm".equals(action))
        {
            if (!requireAdmin(request, response)) return;

            //open adduser.jsp page
            request.getRequestDispatcher("/WEB-INF/views/addUser.jsp").forward(request, response);
        }

        // view and edit customer profile
        else if ("editProfile".equals(action))
        {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null)
            {
                response.sendRedirect("login.html");
                return;
            }
            int id = (Integer) session.getAttribute("userId");
            User user = service.getUserById(id, dynamicPath);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        }

        //user logout
        else if ("logout".equals(action))
        {
            //get current session
            HttpSession session = request.getSession(false);
            //if session available
            if (session != null)
            {
                //terminate session
                session.invalidate();
            }
            //redirect to homepage
            response.sendRedirect("index.jsp");
        }
    }

    //handle post requests
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, jakarta.servlet.ServletException
    {
        //get action parameter
        String action = request.getParameter("action");
        //user file path
        String securePath = "data/users.txt";
        //register user
        if ("register".equals(action))
        {
            //get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            //get selected role
            String role = request.getParameter("role");

            //create user object
            User newUser = User.createUser(0, name, email, password, role);
            //save user to user service
            service.addUser(newUser, securePath);
            //redirect to login
            response.sendRedirect("login.html?success=true");
        }

        //user login
        else if ("login".equals(action))
        {
            //get loin details
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            //validate user
            User user = service.validateUser(email, password, securePath);

            //if login done
            if (user != null)
            {
                // Admins are prohibited from logging in via standard customer portal!
                if ("admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("login.html?error=adminProhibited");
                    return;
                }

                //create session
                HttpSession session = request.getSession();
                //store user data
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("role", user.getRole());
                
                //redirect to dashboard
                response.sendRedirect(user.getDashboardRedirectURL());
            }
            else
            {
                //login failed
                response.sendRedirect("login.html?error=invalid");
            }
        }

        //update user
        else if ("update".equals(action))
        {
            if (!requireAdmin(request, response)) return;

            //get updated user details
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            //get role
            String role = request.getParameter("role");

            //get old user (needed for the role fallback and to keep the existing password if left blank)
            User oldUser = service.getUserById(id, securePath);

            //if role is empty
            if (role == null || role.isEmpty())
            {
                //keep previous role
                role = (oldUser != null) ? oldUser.getRole() : "customer";
            }

            //if password field left blank, keep the existing (already hashed) password
            if (password == null || password.isEmpty())
            {
                password = (oldUser != null) ? oldUser.getPassword() : password;
            }

            //create updated user object
            User updatedUser = User.createUser(id, name, email, password, role);

            //update user in file
            service.updateUser(updatedUser, securePath);

            //redirect to list page
            response.sendRedirect("user?action=listUsers");
        }

        // Customer self profile update
        else if ("updateProfile".equals(action))
        {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null)
            {
                response.sendRedirect("login.html");
                return;
            }
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Maintain their existing role (always keep original role, which is 'customer')
            User oldUser = service.getUserById(id, securePath);
            String role = (oldUser != null) ? oldUser.getRole() : "customer";

            //if password field left blank, keep the existing (already hashed) password
            if (password == null || password.isEmpty())
            {
                password = (oldUser != null) ? oldUser.getPassword() : password;
            }

            User updatedUser = User.createUser(id, name, email, password, role);
            service.updateUser(updatedUser, securePath);

            // Dynamically refresh the session's name attribute so navigation instantly updates
            session.setAttribute("userName", name);

            response.sendRedirect("user?action=editProfile&success=true");
        }

        //admin add user
        else if ("adminAddUser".equals(action))
        {
            if (!requireAdmin(request, response)) return;

            //get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            //create user object
            User newUser = User.createUser(0, name, email, password, role);
            //save user
            service.addUser(newUser, securePath);
            //redirect to userlist
            response.sendRedirect("user?action=listUsers");
        }
    }
}

