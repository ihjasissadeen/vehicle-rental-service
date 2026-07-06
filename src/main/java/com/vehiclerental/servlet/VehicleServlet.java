package com.vehiclerental.servlet;

import com.vehiclerental.model.Vehicle; //create vehicle objects
import com.vehiclerental.model.VehicleDetails;
import com.vehiclerental.service.VehicleService; //call service methods
import com.vehiclerental.service.VehicleDetailsService;

import jakarta.servlet.ServletException; //handle servlet errors
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest; //get the browser data
import jakarta.servlet.http.HttpServletResponse; //send to the browser data
import jakarta.servlet.http.Part;

import java.io.IOException; //handle IO errors
import java.util.List; //store vehicle list

@WebServlet("/vehicle")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class VehicleServlet extends HttpServlet {

    private VehicleService vehicleService;
    private VehicleDetailsService detailsService;

    @Override
    public void init() {
        vehicleService = new VehicleService();
        detailsService = new VehicleDetailsService();
    }

    // Fleet management (add/edit/delete) is an admin-only area
    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect("adminLogin.html");
            return false;
        }
        return true;
    }

    // Handles GET requests (view, edit, delete, search)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the action parameter from URL
        String action = request.getParameter("action");

        // If action is null, default to list
        if (action == null) {
            action = "list";
        }

        // Decide which function to execute based on action
        switch (action) {

            // List all vehicles
            case "list":
                List<Vehicle> vehiclesList = vehicleService.getAllVehicles();

                // Load vehicle categories dynamically for the catalog filter bar
                try {
                    com.vehiclerental.service.CategoryService categoryService = new com.vehiclerental.service.CategoryService();
                    List<com.vehiclerental.model.Category> categoriesList = categoryService.getAll();
                    request.setAttribute("categories", categoriesList);

                    // Apply category filter if parameter is passed
                    String catFilter = request.getParameter("category");
                    if (catFilter != null && !catFilter.trim().isEmpty()) {
                        List<Vehicle> filteredList = new java.util.ArrayList<>();
                        String filterNorm = catFilter.trim().toLowerCase();
                        if (filterNorm.endsWith("s")) {
                            filterNorm = filterNorm.substring(0, filterNorm.length() - 1);
                        }
                        for (Vehicle v : vehiclesList) {
                            String typeNorm = v.getType().trim().toLowerCase();
                            if (typeNorm.endsWith("s")) {
                                typeNorm = typeNorm.substring(0, typeNorm.length() - 1);
                            }
                            if (typeNorm.equals(filterNorm)) {
                                filteredList.add(v);
                            }
                        }
                        vehiclesList = filteredList;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                request.setAttribute("vehicles", vehiclesList);

                // Detect role and forward to the correct view
                String userRole = (String) request.getSession().getAttribute("role");
                if ("admin".equalsIgnoreCase(userRole)) {
                    request.getRequestDispatcher("/WEB-INF/views/vehicles.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/WEB-INF/views/catalog.jsp").forward(request, response);
                }
                break;

            // Edit vehicle(show form)
            case "edit":
                if (!requireAdmin(request, response)) return;
                int id;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (NumberFormatException e) {
                    response.sendRedirect("vehicle?action=list");
                    return;
                }

                // Get the vehicle record by ID
                Vehicle vehicle = vehicleService.getVehicleById(id);

                // Send vehicle object to editVehicle.jsp
                request.setAttribute("vehicle", vehicle);

                try {
                    com.vehiclerental.service.CategoryService categoryService = new com.vehiclerental.service.CategoryService();
                    request.setAttribute("categories", categoryService.getAll());
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Forward to edit page
                request.getRequestDispatcher("/WEB-INF/views/editVehicle.jsp")
                        .forward(request, response);
                break;

            // Delete vehicle
            case "delete":
                if (!requireAdmin(request, response)) return;
                int deleteId;
                try {
                    deleteId = Integer.parseInt(request.getParameter("id"));
                } catch (NumberFormatException e) {
                    response.sendRedirect("vehicle?action=list");
                    return;
                }

                // Delete vehicle from file
                vehicleService.deleteVehicle(deleteId);

                // Redirect back to vehicle list page
                response.sendRedirect("vehicle?action=list");
                break;

            // Search vehicles
            case "search":
                String keyword = request.getParameter("keyword");
                List<Vehicle> searchResults = vehicleService.searchVehicles(keyword == null ? "" : keyword);
                request.setAttribute("vehicles", searchResults);

                // Role detection for search results too
                String sRole = (String) request.getSession().getAttribute("role");
                if ("admin".equalsIgnoreCase(sRole)) {
                    request.getRequestDispatcher("/WEB-INF/views/vehicles.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/WEB-INF/views/catalog.jsp").forward(request, response);
                }
                break;

            // Default
            default:
                response.sendRedirect("vehicle?action=list");
        }
    }

    // Handles POST requests (add, update)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireAdmin(request, response)) return;

        // Get action from form submission
        String action = request.getParameter("action");

        // If action is null, default to add
        if (action == null) {
            action = "add";
        }

        switch (action) {

            // Add vehicle
            case "add":
                String brand = request.getParameter("brand");
                String type = request.getParameter("type");
                double pricePerDay;
                try {
                    pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
                } catch (NumberFormatException e) {
                    response.sendRedirect("vehicle?action=list&error=invalid_price");
                    return;
                }
                boolean available = Boolean.parseBoolean(request.getParameter("available"));

                // Create Vehicle object from form data
                Vehicle newVehicle = new Vehicle(0, brand, type, pricePerDay, available);

                // Save new vehicle into file
                vehicleService.addVehicle(newVehicle);

                String fuelType = request.getParameter("fuelType");
                int seatingCapacity = 0;
                try {
                    seatingCapacity = Integer.parseInt(request.getParameter("seatingCapacity"));
                } catch (Exception e) {
                }
                boolean hasAc = Boolean.parseBoolean(request.getParameter("hasAc"));
                boolean hasGear = Boolean.parseBoolean(request.getParameter("hasGear"));

                VehicleDetails details = new VehicleDetails(newVehicle.getId(), fuelType, seatingCapacity, hasAc,
                        hasGear);
                detailsService.saveDetails(details);

                // Save dynamic image file upload
                try {
                    Part filePart = request.getPart("imageFile");
                    saveVehicleImage(newVehicle.getId(), filePart, request.getServletContext());
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Redirect to list page after adding
                response.sendRedirect("vehicle?action=list");
                break;

            // Update vehicle
            case "update":
                int id;
                double uPricePerDay;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                    uPricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
                } catch (NumberFormatException e) {
                    response.sendRedirect("vehicle?action=list&error=invalid_input");
                    return;
                }
                String uBrand = request.getParameter("brand");
                String uType = request.getParameter("type");
                boolean uAvailable = Boolean.parseBoolean(request.getParameter("available"));

                // Create updated Vehicle object
                Vehicle updatedVehicle = new Vehicle(id, uBrand, uType, uPricePerDay, uAvailable);

                // Update record in file
                vehicleService.updateVehicle(updatedVehicle);

                String uFuelType = request.getParameter("fuelType");
                int uSeatingCapacity = 0;
                try {
                    uSeatingCapacity = Integer.parseInt(request.getParameter("seatingCapacity"));
                } catch (Exception e) {
                }
                boolean uHasAc = Boolean.parseBoolean(request.getParameter("hasAc"));
                boolean uHasGear = Boolean.parseBoolean(request.getParameter("hasGear"));

                VehicleDetails uDetails = new VehicleDetails(id, uFuelType, uSeatingCapacity, uHasAc, uHasGear);
                detailsService.saveDetails(uDetails);

                // Save dynamic image file upload if uploaded
                try {
                    Part filePart = request.getPart("imageFile");
                    saveVehicleImage(id, filePart, request.getServletContext());
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Redirect back to list page
                response.sendRedirect("vehicle?action=list");
                break;

            // Default
            default:
                response.sendRedirect("vehicle?action=list");
        }
    }

    private void saveVehicleImage(int vehicleId, jakarta.servlet.http.Part filePart, jakarta.servlet.ServletContext servletContext) {
        if (filePart == null || filePart.getSize() == 0) {
            return;
        }

        String filename = vehicleId + ".jpg";

        // 1. Save to running servlet deployment directory
        String deployPath = servletContext.getRealPath("/assets/vehicles");
        if (deployPath != null) {
            try {
                java.io.File deployDir = new java.io.File(deployPath);
                if (!deployDir.exists()) {
                    deployDir.mkdirs();
                }
                java.io.File destFile = new java.io.File(deployDir, filename);
                try (java.io.InputStream input = filePart.getInputStream();
                     java.io.FileOutputStream output = new java.io.FileOutputStream(destFile)) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        output.write(buffer, 0, bytesRead);
                    }
                }
                System.out.println("Saved image to deploy path: " + destFile.getAbsolutePath());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Save to source directory so it persists across rebuilds/re-deploys!
        try {
            String userDir = System.getProperty("user.dir");
            java.io.File srcDir = new java.io.File(userDir, "src/main/webapp/assets/vehicles");
            if (srcDir.exists()) {
                java.io.File destFile = new java.io.File(srcDir, filename);
                try (java.io.InputStream input = filePart.getInputStream();
                     java.io.FileOutputStream output = new java.io.FileOutputStream(destFile)) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        output.write(buffer, 0, bytesRead);
                    }
                }
                System.out.println("Saved image to source path: " + destFile.getAbsolutePath());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
