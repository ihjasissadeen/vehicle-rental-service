package com.vehiclerental.servlet;

import com.vehiclerental.model.Review;
import com.vehiclerental.model.Vehicle;
import com.vehiclerental.service.ReviewService;
import com.vehiclerental.service.VehicleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ReviewService reviewService = new ReviewService();
    private VehicleService vehicleService = new VehicleService();

    // HANDLE POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                // Enforce active session validation
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("userId") == null) {
                    response.sendRedirect("login.html?error=required");
                    return;
                }

                int userId = (Integer) session.getAttribute("userId");
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                reviewService.addReview(userId, vehicleId, rating, comment);
                response.sendRedirect("review?action=list&vehicleId=" + vehicleId);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("index.jsp");
            }
        } 
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            reviewService.deleteReview(id);
            response.sendRedirect("review?action=adminList");
        }
    }

    // HANDLE GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                try {
                    String vehicleIdStr = request.getParameter("vehicleId");
                    List<Review> reviews;
                    if (vehicleIdStr != null && !vehicleIdStr.isEmpty()) {
                        int vehicleId = Integer.parseInt(vehicleIdStr);
                        reviews = reviewService.getReviewsByVehicle(vehicleId);
                        Vehicle vehicle = vehicleService.getVehicleById(vehicleId);
                        request.setAttribute("vehicle", vehicle);
                    } else {
                        reviews = reviewService.getAllReviews();
                    }
                    request.setAttribute("reviews", reviews);
                    request.getRequestDispatcher("/WEB-INF/views/viewReviews.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("index.jsp");
                }
                break;

            case "adminList":
                try {
                    List<Review> reviews = reviewService.getAllReviews();
                    request.setAttribute("reviews", reviews);
                    request.getRequestDispatcher("/WEB-INF/views/adminReviews.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("index.jsp");
                }
                break;

            case "addForm":
                try {
                    // Enforce login validation for accessing reviews form!
                    HttpSession session = request.getSession(false);
                    if (session == null || session.getAttribute("userId") == null) {
                        response.sendRedirect("login.html?error=required");
                        return;
                    }

                    int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                    Vehicle vehicle = vehicleService.getVehicleById(vehicleId);
                    request.setAttribute("vehicle", vehicle);
                    request.getRequestDispatcher("/WEB-INF/views/addReview.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("index.jsp");
                }
                break;

            default:
                response.sendRedirect("review?action=list");
        }
    }
}