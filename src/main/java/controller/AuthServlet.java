package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import mvcModel.UserService;
import mvcModel.ActivityLogService;
import entities.User;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@EJB
    private UserService userService;

    @EJB
    private ActivityLogService logService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // ===== REGISTER =====
        if ("register".equals(action)) {

            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (userService.register(username, password, name, role)) {
                User newUser = userService.findByUsername(username);
                if (newUser != null) {
                    logService.log(newUser.getUserId(), newUser.getUsername(), "REGISTER", "New user joined as " + role);
                }
                response.sendRedirect("login.jsp?msg=registered");
            } else {
                response.sendRedirect("register.jsp?error=exists");
            }
            return;
        }

        // ===== LOGIN =====
        if ("login".equals(action)) {

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userService.login(username, password);

            if (user != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("activeUser", user);
                
                logService.log(user.getUserId(), user.getUsername(), "LOGIN", "User logged into the platform");
                
                if ("ADMIN".equals(user.getRole())) {
                    request.getRequestDispatcher("/AdminServlet?action=dashboard").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/PostServlet?action=home");
                }
            } else {
                request.setAttribute("error", "Invalid credentials");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            return;
        }

        // ===== LOGOUT =====
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();

            response.sendRedirect("login.jsp");
        }
    }
}