package mvcModel;

import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

import entities.Application;
import entities.Application.ApplicationStatus;
import entities.Post;
import entities.Post.PostStatus;
import entities.User;


@Stateless
@LocalBean
public class ApplicationService {

	@PersistenceContext(unitName="hireflow")
	private EntityManager em;

    //APPLY TO POST
    public boolean applyToPost(int postId, User freelancer) {
        //prevent duplicate application
        List<Application> existing = em.createQuery(
            "SELECT a FROM Application a WHERE a.freelancer.userId = :uid AND a.post.postId = :pid",
            Application.class)
            .setParameter("uid", freelancer.getUserId())
            .setParameter("pid", postId)
            .getResultList();

        if (!existing.isEmpty()) {
            return false;
        }
        Post post = em.find(Post.class, postId);
        if (post == null) return false;
        
        if (post.getStatus() == PostStatus.CLOSED) {
            return false;
        }
		// prevent applying to own post
		if (post.getClient().getUserId() == freelancer.getUserId()) {
		    return false;
		}
        Application app = new Application();
        app.setFreelancer(freelancer);
        app.setPost(post);
        app.setStatus(ApplicationStatus.PENDING);

        em.persist(app);
        return true;
    }

    //GET APPLICATIONS BY POST
    public List<Application> getApplicationsByPost(int postId) {
        List<Application> apps = em.createQuery(
            "SELECT a FROM Application a WHERE a.post.postId = :pid", Application.class)
            .setParameter("pid", postId)
            .getResultList();
        return apps;
    }
    
 // GET APPLICATIONS BY USER
    public List<Application> getApplicationsByUser(int userId) {

        return em.createQuery(
            "SELECT a FROM Application a WHERE a.freelancer.userId = :uid",
            Application.class)
            .setParameter("uid", userId)
            .getResultList();
    }

    // UPDATE STATUS (ACCEPT / REJECT)
    public void updateStatus(int appId, String status, User user) {

        Application app = em.find(Application.class, appId);
        if (app == null) return;
        Post post = app.getPost();

        //only client can update
        if (post.getClient().getUserId() != user.getUserId()) return;

        if ("ACCEPTED".equals(status)) {
            // 1. Accept selected application
            app.setStatus(Application.ApplicationStatus.ACCEPTED);

            // 2. Reject all others
            List<Application> allApps = em.createQuery(
                "SELECT a FROM Application a WHERE a.post.postId = :postId",
                Application.class
            ).setParameter("postId", post.getPostId())
             .getResultList();

            for (Application a : allApps) {
                if (a.getApplicationId() != appId) {
                    a.setStatus(Application.ApplicationStatus.REJECTED);
                    em.merge(a);
                }
            }
            // 3. Set post to IN_PROGRESS
            post.setStatus(Post.PostStatus.IN_PROGRESS);
            em.merge(post);

        } else if ("REJECTED".equals(status)) {
            app.setStatus(Application.ApplicationStatus.REJECTED);
        }

        em.merge(app);
    }
    
    //kadeh mn kaaba pending
    public long countPendingApplications(int postId) {
        return em.createQuery(
            "SELECT COUNT(a) FROM Application a WHERE a.post.postId = :postId AND a.status = :status",
            Long.class
        )
        .setParameter("postId", postId)
        .setParameter("status", Application.ApplicationStatus.PENDING)
        .getSingleResult();
    }
    
    //nzid esm l freelancer assigned
    public Application getAcceptedApplication(int postId) {
        try {
            return em.createQuery(
                "SELECT a FROM Application a WHERE a.post.postId = :postId AND a.status = :status",
                Application.class
            )
            .setParameter("postId", postId)
            .setParameter("status", Application.ApplicationStatus.ACCEPTED)
            .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }
    
    //apps mtaa kol freelancer
    public List<Application> getApplicationsByFreelancer(int userId) {
        return em.createQuery(
            "SELECT a FROM Application a WHERE a.freelancer.userId = :userId",
            Application.class
        )
        .setParameter("userId", userId)
        .getResultList();
    }
    
    //rating system
    public void rateApplication(int applicationId, int rating) {
        Application app = em.find(Application.class, applicationId);
        if (app == null) return;

        // 🔒 Only ACCEPTED applications
        if (app.getStatus() != Application.ApplicationStatus.ACCEPTED) return;
        
        // 🔒 Only when job is COMPLETED
        if (app.getPost().getStatus() != Post.PostStatus.CLOSED) return;
       
        // 🔒 Rating range
        if (rating < 1 || rating > 5) return;
        app.setRating(rating);
        em.merge(app);
    }
    
    
    public Application getApplicationById(int id) {
        try {
            return em.find(Application.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    //Stars stats
    public Double getAverageRating(int freelancerId) {
        Double avg = em.createQuery(
            "SELECT AVG(a.rating) FROM Application a " +
            "WHERE a.freelancer.userId = :id AND a.rating IS NOT NULL",
            Double.class)
            .setParameter("id", freelancerId)
            .getSingleResult();

        return avg != null ? avg : 0.0;
    }
    
    // TOTAL EARNINGS (FREELANCER)
    public double getTotalEarnings(int freelancerId) {
        Double total = em.createQuery(
            "SELECT SUM(a.post.budget) FROM Application a " +
            "WHERE a.freelancer.userId = :id AND a.status = :status AND a.post.status = :postStatus",
            Double.class)
            .setParameter("id", freelancerId)
            .setParameter("status", ApplicationStatus.ACCEPTED)
            .setParameter("postStatus", PostStatus.CLOSED)
            .getSingleResult();
        return total != null ? total : 0.0;
    }

    public List<Application> getAllApplications() {
        return em.createQuery("SELECT a FROM Application a", Application.class)
                 .getResultList();
    }
}