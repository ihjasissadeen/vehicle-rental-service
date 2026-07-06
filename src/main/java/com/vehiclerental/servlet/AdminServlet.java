package com.vehiclerental.servlet;

import com.vehiclerental.model.User;
import com.vehiclerental.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    // Service to handle user-related logic
    private final UserService userService = new UserService();

    // File where all user accounts are saved
    private final String securePath = "data/users.txt";

    // Handles loading pages (like the dashboard)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Security check: If not logged in as admin, kick them out to the login page
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect("adminLogin.html");
            return;
        }

        // Show the admin dashboard view
        if ("dashboard".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/adminDashboard.jsp").forward(request, response);
        }
    }

    // Handles form submissions (Register and Login forms)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // 1. Process Admin Registration form
        if ("adminRegister".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            // Create a new user object and save it to our text file
            User newAdmin = User.createUser(0, name, email, password, role);
            userService.addUser(newAdmin, securePath);

            // Go to login page after signing up
            response.sendRedirect("adminLogin.html");
        }

        // 2. Process Admin Login form
        else if ("adminLogin".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Check if credentials match any user in the text file
            User admin = userService.validateUser(email, password, securePath);

            // Check if the user exists and is actually an admin
            if (admin != null && "admin".equalsIgnoreCase(admin.getRole())) {
                // Success: Save user info into the session
                HttpSession session = request.getSession();
                session.setAttribute("userId", admin.getId());
                session.setAttribute("userName", admin.getName());
                session.setAttribute("role", admin.getRole());

                // Send them to the dashboard
                response.sendRedirect("admin?action=dashboard");
            } else {
                // Failure: Send them back to login page with an error flag
                response.sendRedirect("adminLogin.html?error=true");
            }
        }
    }
}