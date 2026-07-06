package com.vehiclerental.servlet;

import com.vehiclerental.model.Booking;
import com.vehiclerental.service.BookingService;
import com.vehiclerental.FileHandler;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private BookingService service = new BookingService();


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session = request.getSession();
        Integer sessionUserId = (Integer) session.getAttribute("userId");
        
        if (sessionUserId == null) {
            response.sendRedirect("login.html");
            return;
        }

        int vehicleId;
        try {
            vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("booking?action=my&error=invalid_vehicle");
            return;
        }
        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");


        if (start == null || start.trim().isEmpty() || end == null || end.trim().isEmpty()) {
            response.sendRedirect("booking?action=my&error=missing_dates");
            return;
        }

        if (service.isVehicleAvailable(vehicleId, start, end)) {
            Booking booking = new Booking(0, sessionUserId, vehicleId, start, end, "pending");
            service.addBooking(booking);
            response.sendRedirect("booking?action=my");

        } else {
            response.getWriter().println("Vehicle not available for the selected dates!");
        }
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            HttpSession deleteSession = request.getSession(false);
            Integer sessionUserId = deleteSession == null ? null : (Integer) deleteSession.getAttribute("userId");
            if (sessionUserId == null) {
                response.sendRedirect("login.html");
                return;
            }

            int id;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendRedirect("booking?action=my");
                return;
            }
            Booking target = service.getBookingById(id);
            boolean isAdmin = "admin".equalsIgnoreCase((String) deleteSession.getAttribute("role"));

            // Only the booking's own customer, or an admin, may cancel/delete it
            if (target != null && (isAdmin || target.getUserId() == sessionUserId)) {
                service.deleteBooking(id);
            }
            response.sendRedirect("booking?action=my");
            return;
        }
        
        if ("getBookedDates".equals(action)) {
            String vIdParam = request.getParameter("vehicleId");
            if (vIdParam != null && !vIdParam.trim().isEmpty()) {
                try {
                    int vehicleId = Integer.parseInt(vIdParam.trim());
                    List<Booking> all = service.getAllBookings();
                    System.out.println("DEBUG: Total bookings found in file: " + all.size());
                    
                    StringBuilder json = new StringBuilder("[");
                    boolean first = true;
                    for (Booking b : all) {
                        System.out.println("DEBUG: Checking booking: ID=" + b.getId() + ", VehicleID=" + b.getVehicleId() + ", Status=" + b.getStatus());
                        if (b.getVehicleId() == vehicleId && "active".equals(b.getStatus())) {
                            if (!first) json.append(",");
                            json.append("{\"from\":\"").append(b.getStartDate()).append("\",\"to\":\"").append(b.getEndDate()).append("\"}");
                            first = false;
                            System.out.println("DEBUG: MATCH! Adding range: " + b.getStartDate() + " to " + b.getEndDate());
                        }
                    }
                    json.append("]");
                    response.setContentType("application/json");
                    response.getWriter().write(json.toString());
                    System.out.println("DEBUG: JSON output sent: " + json.toString());
                } catch (Exception e) {
                    System.err.println("ERROR in getBookedDates: " + e.getMessage());
                    e.printStackTrace();
                    response.setStatus(500);
                }
            }
            return;
        }

        if ("all".equals(action)) {
            HttpSession adminSession = request.getSession(false);
            if (adminSession == null || adminSession.getAttribute("userId") == null
                    || !"admin".equalsIgnoreCase((String) adminSession.getAttribute("role"))) {
                response.sendRedirect("adminLogin.html");
                return;
            }

            List<Booking> list = service.getAllBookings();
            request.setAttribute("bookings", list);
            request.getRequestDispatcher("WEB-INF/views/allBookings.jsp").forward(request, response);

        } else { // default → my bookings
            HttpSession session = request.getSession();
            Integer sessionUserId = (Integer) session.getAttribute("userId");
            
            if (sessionUserId == null) {
                response.sendRedirect("login.html");
                return;
            }
            
            List<Booking> list = service.getBookingsByUser(sessionUserId);
            request.setAttribute("bookings", list);
            request.getRequestDispatcher("WEB-INF/views/myBookings.jsp").forward(request, response);
        }
    }
}