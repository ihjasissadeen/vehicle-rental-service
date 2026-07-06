package com.vehiclerental.servlet;

import com.vehiclerental.model.Category;
import com.vehiclerental.service.CategoryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {

    private CategoryService service = new CategoryService();

    // Category management is an admin-only area
    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect("adminLogin.html");
            return false;
        }
        return true;
    }

    // HANDLE POST (add/update)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireAdmin(request, response)) return;

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String desc = request.getParameter("desc");

            service.addCategory(name, desc);
            response.sendRedirect("category?action=list");
        }
        else if ("update".equals(action)) {
            int id;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendRedirect("category?action=list");
                return;
            }
            String name = request.getParameter("name");
            String desc = request.getParameter("desc");

            service.update(id, name, desc);
            response.sendRedirect("category?action=list");
        }
    }

    // HANDLE GET (view pages & actions)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                List<Category> categories = service.getAll();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/views/categoryList.jsp").forward(request, response);
                break;

            case "addForm":
                request.getRequestDispatcher("/WEB-INF/views/addCategory.jsp").forward(request, response);
                break;

            case "editForm":
                int id;
                try {
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (NumberFormatException e) {
                    response.sendRedirect("category?action=list");
                    return;
                }
                Category category = service.getById(id);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/WEB-INF/views/editCategory.jsp").forward(request, response);
                break;

            case "delete":
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    service.delete(deleteId);
                    response.sendRedirect("category?action=list");
                } catch (NumberFormatException e) {
                    response.sendRedirect("category?action=list");
                } catch (IllegalStateException e) {
                    // Catch referential integrity exceptions and report to user!
                    request.setAttribute("error", e.getMessage());
                    request.setAttribute("categories", service.getAll());
                    request.getRequestDispatcher("/WEB-INF/views/categoryList.jsp").forward(request, response);
                }
                break;

            default:
                response.sendRedirect("category?action=list");
        }
    }
}