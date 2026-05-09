package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import mvcModel.PostService;
import mvcModel.UserService;
import mvcModel.ActivityLogService;
import entities.Post;
import entities.User;
import entities.ActivityLog;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private UserService userService;

    @EJB
    private PostService postService;

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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("activeUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("activeUser");
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect("PostServlet?action=home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        if ("dashboard".equals(action)) {
            List<User> allUsers = userService.getAllUsers();
            List<Post> allPosts = postService.getAllPosts();
            List<ActivityLog> recentLogs = logService.getRecentLogs(15);

            // STATS
            long userCount = userService.getUserCount();
            long postCount = postService.getPostCount();
            double totalBudget = postService.getTotalPlatformBudget();
            long logCount = logService.getLogCount();

            request.setAttribute("usersList", allUsers);
            request.setAttribute("postsList", allPosts);
            request.setAttribute("recentLogs", recentLogs);
            
            request.setAttribute("userCount", userCount);
            request.setAttribute("postCount", postCount);
            request.setAttribute("totalBudget", totalBudget);
            request.setAttribute("logCount", logCount);

            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }

        if ("updateUser".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String role = request.getParameter("role");
                String bio = request.getParameter("bio");
                String skills = request.getParameter("skills");
                String password = request.getParameter("password");

                userService.updateUserDetailsAdmin(userId, name, email, password, address, role, bio, skills);
                
                logService.log(admin.getUserId(), admin.getUsername(), "UPDATE_USER", 
                    "Updated user ID " + userId + " (Role: " + role + ")");
                
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("AdminServlet?action=dashboard");
            return;
        }

        if ("deleteUser".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                if (userId != admin.getUserId()) { // prevent self-deletion
                    userService.deleteUser(userId);
                    logService.log(admin.getUserId(), admin.getUsername(), "DELETE_USER", "Deleted user ID " + userId);
                }
            } catch (Exception e) {
                // ignore
            }
            response.sendRedirect("AdminServlet?action=dashboard");
            return;
        }

        if ("deletePost".equals(action)) {
            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                postService.deletePostAdmin(postId);
                logService.log(admin.getUserId(), admin.getUsername(), "DELETE_POST", "Deleted post ID " + postId);
            } catch (Exception e) {
                // ignore
            }
            response.sendRedirect("AdminServlet?action=dashboard");
            return;
        }
    }
}
