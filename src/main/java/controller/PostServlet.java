package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import mvcModel.PostService;
import mvcModel.ApplicationService;
import mvcModel.ActivityLogService;
import entities.Application;
import entities.Post;
import entities.User;

@WebServlet("/PostServlet")
public class PostServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	@EJB
    private PostService postService;
	
	@EJB
	private ApplicationService applicationService;

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
            response.sendRedirect("index.jsp");
            return;
        }

     // ===== HOME =====
        if ("home".equals(action)) {

        	//Taawenni fil filtre
        	String statusFilter = request.getParameter("status");
        	List<Post> posts;
        	if (statusFilter != null && !statusFilter.isEmpty()) {
        	    try {
        	        Post.PostStatus status = Post.PostStatus.valueOf(statusFilter);
        	        posts = postService.getPostsByStatus(user, status);
        	    } catch (Exception e) {
        	        posts = postService.getPosts(user);
        	    }
        	} else {
        	    posts = postService.getPosts(user);
        	}
        	request.setAttribute("currentFilter", statusFilter);
            
            //===== pendingCounts =====
            Map<Integer, Long> pendingCounts = new HashMap<>();
            for (Post p : posts) {
                long count = applicationService.countPendingApplications(p.getPostId());                
                pendingCounts.put(p.getPostId(), count);
            }
            request.setAttribute("pendingCounts", pendingCounts);
            
          //===== accepted freelancer =====
            Map<Integer, Application> acceptedMap = new HashMap<>();

            for (Post p : posts) {
                Application accepted = applicationService.getAcceptedApplication(p.getPostId());
                if (accepted != null) {
                    acceptedMap.put(p.getPostId(), accepted);
                }
            }
            request.setAttribute("acceptedMap", acceptedMap);


            //===== ratings (AFTER acceptedMap is filled) =====
            Map<Integer, Double> ratingsMap = new HashMap<>();

            for (Application a : acceptedMap.values()) {
                int freelancerId = a.getFreelancer().getUserId();

                if (!ratingsMap.containsKey(freelancerId)) {
                    Double r = applicationService.getAverageRating(freelancerId);
                    r = Math.round(r * 10.0) / 10.0;
                    ratingsMap.put(freelancerId, r);
                }
            }

            request.setAttribute("ratingsMap", ratingsMap);


            //===== applied posts =====
            Set<Integer> appliedPostIds = new HashSet<>();
            if ("FREELANCER".equals(user.getRole())) {
                List<Application> myApps = applicationService.getApplicationsByFreelancer(user.getUserId());
                for (Application a : myApps) {
                    appliedPostIds.add(a.getPost().getPostId());
                }
            }
            request.setAttribute("appliedPostIds", appliedPostIds);

            request.setAttribute("posts", posts);
            request.getRequestDispatcher("home.jsp").forward(request, response);
            return;
        
       }    


        // ===== STATS=====
        if ("stats".equals(action)) {

            // CLIENT stats
            if ("CLIENT".equals(user.getRole())) {

                List<Post> posts = postService.getPosts(user);

                long open = posts.stream().filter(p -> p.getStatus() == Post.PostStatus.OPEN).count();
                long progress = posts.stream().filter(p -> p.getStatus() == Post.PostStatus.IN_PROGRESS).count();
                long closed = posts.stream().filter(p -> p.getStatus() == Post.PostStatus.CLOSED).count();

                request.setAttribute("totalJobs", posts.size());
                request.setAttribute("openJobs", open);
                request.setAttribute("inProgressJobs", progress);
                request.setAttribute("closedJobs", closed);
                
                double totalSpent = postService.getTotalSpent(user.getUserId());
                request.setAttribute("totalSpent", totalSpent);
            }

            // FREELANCER stats
            else if ("FREELANCER".equals(user.getRole())) {

                List<Application> apps = applicationService.getApplicationsByFreelancer(user.getUserId());

                long pending = apps.stream().filter(a -> a.getStatus() == Application.ApplicationStatus.PENDING).count();
                long accepted = apps.stream().filter(a -> a.getStatus() == Application.ApplicationStatus.ACCEPTED).count();
                long rejected = apps.stream().filter(a -> a.getStatus() == Application.ApplicationStatus.REJECTED).count();
                
                request.setAttribute("totalApps", apps.size());
                request.setAttribute("pendingApps", pending);
                request.setAttribute("acceptedApps", accepted);
                request.setAttribute("rejectedApps", rejected);
                
                Double avgRating = applicationService.getAverageRating(user.getUserId());
	            // round to 1 decimal (optional but looks better)
	            avgRating = Math.round(avgRating * 10.0) / 10.0;
	            request.setAttribute("avgRating", avgRating);
	            
	            double totalEarnings = applicationService.getTotalEarnings(user.getUserId());
	            request.setAttribute("totalEarnings", totalEarnings);
            }

            // fallback (optional)
            else {
                request.setAttribute("info", "No stats available");
            }

            request.getRequestDispatcher("stats.jsp").forward(request, response);
            return;
        }

        // ===== CREATE POST =====
        if ("create".equals(action)) {
            if (!"CLIENT".equals(user.getRole())) {
                response.sendRedirect("PostServlet?action=home");
                return;
            }

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String budgetStr = request.getParameter("budget");

            if (title == null || title.length() < 3 || budgetStr == null) {
                response.sendRedirect("createPost.jsp?error=invalidData");
                return;
            }

            try {
                double budget = Double.parseDouble(budgetStr);
                if (budget <= 0) throw new Exception();
                
                postService.createPost(title, description, budget, user);
                logService.log(user.getUserId(), user.getUsername(), "CREATE_POST", "Created new job: " + title);
                response.sendRedirect("PostServlet?action=home&msg=created");
            } catch (Exception e) {
                response.sendRedirect("createPost.jsp?error=invalidBudget");
            }
            return;
        }

        // ===== DELETE POST =====
        if ("delete".equals(action)) {

            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                postService.deletePost(postId, user);
            } catch (Exception e) {
                // ignore
            }

            response.sendRedirect("PostServlet?action=home");
        }
        
     // ===== COMPLETE POST =====
        if ("complete".equals(action)) {

            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                postService.completePost(postId, user);
                logService.log(user.getUserId(), user.getUsername(), "COMPLETE_JOB", "Marked job ID " + postId + " as completed");
                response.sendRedirect("PostServlet?action=home&msg=completed");
            } catch (Exception e) {
            }
            response.sendRedirect("PostServlet?action=home");
            return;
        }
        
        //withdrawal
        if ("withdraw".equals(action)) {

            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                postService.withdrawPost(postId, user);
            } catch (Exception e) {
                e.printStackTrace(); //for debug
            }

            response.sendRedirect("PostServlet?action=home");
            return;
        }
    }
}
    