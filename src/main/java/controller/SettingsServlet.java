package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import mvcModel.UserService;
import entities.User;

@WebServlet("/SettingsServlet")
public class SettingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserService userService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("activeUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Refresh user data from DB to ensure it's up to date
        User sessionUser = (User) session.getAttribute("activeUser");
        User freshUser = userService.findByUsername(sessionUser.getUsername());
        if (freshUser != null) {
            session.setAttribute("activeUser", freshUser);
        }

        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("activeUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("activeUser");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            
            String bio = request.getParameter("bio");
            String skills = request.getParameter("skills");

            boolean updated = userService.updateUser(user.getUserId(), name, email, password, address, bio, skills);

            if (updated) {
                // Refresh session user
                User updatedUser = userService.findByUsername(user.getUsername());
                session.setAttribute("activeUser", updatedUser);
                response.sendRedirect("SettingsServlet?msg=success");
            } else {
                response.sendRedirect("SettingsServlet?msg=error");
            }
        } else {
            response.sendRedirect("SettingsServlet");
        }
    }
}
