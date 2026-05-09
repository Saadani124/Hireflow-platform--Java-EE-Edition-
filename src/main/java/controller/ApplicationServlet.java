package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mvcModel.ApplicationService;
import mvcModel.PostService;
import mvcModel.ActivityLogService;
import entities.Application;
import entities.Post;
import entities.User;

@WebServlet("/ApplicationServlet")
public class ApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

	@EJB
    private ApplicationService applicationService;

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

        User user = (User) session.getAttribute("activeUser");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("PostServlet?action=home");
            return;
        }

        // ===== APPLY =====
        if ("apply".equals(action)) {

            if (!"FREELANCER".equals(user.getRole())) {
                response.sendRedirect("PostServlet?action=home");
                return;
            }

            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                applicationService.applyToPost(postId, user);
                logService.log(user.getUserId(), user.getUsername(), "APPLY", "Applied to job ID " + postId);
            } catch (Exception e) {
                // ignore
            }

            response.sendRedirect("PostServlet?action=home");
            return;
        }

        // ===== VIEW APPLICATIONS =====
        if ("view".equals(action)) {

            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                Post post = postService.getPostById(postId);

                if (post == null || post.getClient().getUserId() != user.getUserId()) {
                    response.sendRedirect("PostServlet?action=home");
                    return;
                }

                List<Application> apps = applicationService.getApplicationsByPost(postId);

                request.setAttribute("post", post);
                request.setAttribute("applications", apps);
                
                Map<Integer, Double> ratingsMap = new HashMap<>();

                for (Application a : apps) {
                    int freelancerId = a.getFreelancer().getUserId();
                    if (!ratingsMap.containsKey(freelancerId)) {
                        Double r = applicationService.getAverageRating(freelancerId);
                        r = Math.round(r * 10.0) / 10.0;
                        ratingsMap.put(freelancerId, r);
                    }
                }
                request.setAttribute("ratingsMap", ratingsMap);
                
                request.getRequestDispatcher("applications.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect("PostServlet?action=home");
            }
            return;
        }

        // ===== ACCEPT =====
        if ("accept".equals(action)) {

            try {
                int appId = Integer.parseInt(request.getParameter("applicationId"));
                int postId = Integer.parseInt(request.getParameter("postId"));

                applicationService.updateStatus(appId, "ACCEPTED", user);
                logService.log(user.getUserId(), user.getUsername(), "ACCEPT_APPLICATION", "Accepted application ID " + appId + " for job ID " + postId);
                response.sendRedirect("ApplicationServlet?action=view&postId=" + postId + "&msg=updated");

            } catch (Exception e) {
                response.sendRedirect("PostServlet?action=home");
            }
            return;
        }

        // ===== REJECT =====
        if ("reject".equals(action)) {

            try {
                int appId = Integer.parseInt(request.getParameter("applicationId"));
                int postId = Integer.parseInt(request.getParameter("postId"));

                applicationService.updateStatus(appId, "REJECTED", user);
                logService.log(user.getUserId(), user.getUsername(), "REJECT_APPLICATION", "Rejected application ID " + appId + " for job ID " + postId);

                response.sendRedirect("ApplicationServlet?action=view&postId=" + postId + "&msg=updated");

            } catch (Exception e) {
                response.sendRedirect("PostServlet?action=home");
            }
            return;
        }
        
        // ===== RATING SYSTEM =====
        if ("rate".equals(action)) {

            try {
                // Validate rating value
                String ratingStr = request.getParameter("rating");
                if (ratingStr == null || ratingStr.isEmpty()) {
                    String postIdStr = request.getParameter("postId");
                    if (postIdStr != null) {
                        response.sendRedirect("ApplicationServlet?action=view&postId=" + postIdStr);
                    } else {
                        response.sendRedirect("PostServlet?action=home");
                    }
                    return;
                }
                
                int appId = Integer.parseInt(request.getParameter("applicationId"));
                int rating = Integer.parseInt(ratingStr);
                
                // Validate rating range (1-5)
                if (rating < 1 || rating > 5) {
                    response.sendRedirect("PostServlet?action=home&error=invalidRating");
                    return;
                }
                
                // Get application to verify permissions
                Application application = applicationService.getApplicationById(appId);
                
                if (application == null) {
                    response.sendRedirect("PostServlet?action=home&error=appNotFound");
                    return;
                }
                
                // Verify user is the CLIENT who owns the post
                if (!"CLIENT".equals(user.getRole()) || 
                    application.getPost().getClient().getUserId() != user.getUserId()) {
                    response.sendRedirect("PostServlet?action=home&error=unauthorized");
                    return;
                }
                
                // Verify job is CLOSED
                if (application.getPost().getStatus() != Post.PostStatus.CLOSED) {
                    response.sendRedirect("PostServlet?action=home&error=jobNotCompleted");
                    return;
                }
                
                // Verify application is ACCEPTED
                if (application.getStatus() != Application.ApplicationStatus.ACCEPTED) {
                    response.sendRedirect("PostServlet?action=home&error=notAccepted");
                    return;
                }
                
                // Verify not already rated
                if (application.getRating() != null) {
                    response.sendRedirect("PostServlet?action=home&error=alreadyRated");
                    return;
                }
                
                // All validations passed - save the rating
                applicationService.rateApplication(appId, rating);
                
                // Redirect to home with success message
                response.sendRedirect("PostServlet?action=home&msg=ratingSubmitted");
                return;
                
            } catch (NumberFormatException e) {
                // Invalid number format
                response.sendRedirect("PostServlet?action=home&error=invalidInput");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("PostServlet?action=home&error=ratingFailed");
                return;
            }
        }

        // ===== MY APPLICATIONS =====
        if ("my".equals(action)) {

            List<Application> apps = applicationService.getApplicationsByUser(user.getUserId());

            request.setAttribute("applications", apps);
            request.getRequestDispatcher("myApplications.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("PostServlet?action=home");
    }
}