package mvcModel;

import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.ArrayList;
import java.util.List;

import entities.Application;
import entities.Post;
import entities.Post.PostStatus;
import entities.User;


@Stateless
@LocalBean
public class PostService {
	
	@PersistenceContext(unitName="hireflow")
	private EntityManager em;

    //CREATE POST
    public void createPost(String title, String description, double budget, User user) {
        Post post = new Post();
        post.setTitle(title);
        post.setDescription(description);
        post.setBudget(budget);
        post.setClient(user);
        post.setStatus(PostStatus.OPEN);

        em.persist(post);
    }

    // GET POSTS (ROLE BASED + SORTED)
    public List<Post> getPosts(User user) {
    	
	        List<Post> posts;
	        if ("CLIENT".equals(user.getRole())) {
	            posts = em.createQuery(
	                "SELECT p FROM Post p WHERE p.client.userId = :id ORDER BY " +
	                "CASE " +
	                "WHEN p.status = entities.Post.PostStatus.OPEN THEN 1 " +
	                "WHEN p.status = entities.Post.PostStatus.IN_PROGRESS THEN 2 " +
	                "WHEN p.status = entities.Post.PostStatus.CLOSED THEN 3 " +
	                "END, p.postId DESC",
	                Post.class)
	                .setParameter("id", user.getUserId())
	                .getResultList();
	
	        } else {
	            posts = em.createQuery(
	                "SELECT p FROM Post p WHERE p.status = :status ORDER BY p.postId DESC",
	                Post.class)
	                .setParameter("status", PostStatus.OPEN)
	                .getResultList();
	        }
	        return posts;
    	}


    // FIND BY ID
    public Post getPostById(int id) {
        return em.find(Post.class, id);
    }

    //DELETE POST (SECURE)
    public boolean deletePost(int postId, User user) {
        Post post = em.find(Post.class, postId);

        if (post == null || post.getClient().getUserId() != user.getUserId()) {
            return false;
        }
        em.remove(post);
        return true;    
    }
    
    // ADMIN: DELETE POST
    public boolean deletePostAdmin(int postId) {
        Post post = em.find(Post.class, postId);
        if (post != null) {
            em.remove(post);
            return true;
        }
        return false;
    }
    
    //===== post completed=====
    public void completePost(int postId, User user) {
        Post post = em.find(Post.class, postId);

        if (post != null && post.getClient().getUserId() == user.getUserId()) {
            post.setStatus(Post.PostStatus.CLOSED);
            em.merge(post);
        }
    }
    
    //===== withdraw application =====
    public void withdrawPost(int postId, User user) {
        Post post = em.find(Post.class, postId);
        if (post == null) return;

        // SECURITY: only owner
        if (post.getClient().getUserId() != user.getUserId()) return;

        // 1. Set post back to OPEN
        post.setStatus(Post.PostStatus.OPEN);

        // 2. Reject ALL applications
        List<Application> apps = em.createQuery(
            "SELECT a FROM Application a WHERE a.post.postId = :postId",
            Application.class
        ).setParameter("postId", postId)
         .getResultList();

        for (Application a : apps) {
            a.setStatus(Application.ApplicationStatus.REJECTED);
            em.merge(a);
        }
        em.merge(post);
    }
    
    //get posts by status ( taawenna fil filtre )
    public List<Post> getPostsByStatus(User user, Post.PostStatus status) {
        if ("CLIENT".equals(user.getRole())) {
            return em.createQuery(
                "SELECT p FROM Post p WHERE p.client.userId = :id AND p.status = :status ORDER BY p.postId DESC",
                Post.class)
                .setParameter("id", user.getUserId())
                .setParameter("status", status)
                .getResultList();
        } else {
            return em.createQuery(
                "SELECT p FROM Post p WHERE p.status = :status ORDER BY p.postId DESC",
                Post.class)
                .setParameter("status", status)
                .getResultList();
        }
    }
    
    // TOTAL SPENT (CLIENT)
    public double getTotalSpent(int clientId) {
        Double total = em.createQuery(
            "SELECT SUM(p.budget) FROM Post p " +
            "WHERE p.client.userId = :id AND p.status = :status",
            Double.class)
            .setParameter("id", clientId)
            .setParameter("status", PostStatus.CLOSED)
            .getSingleResult();
        return total != null ? total : 0.0;
    }

    public List<Post> getAllPosts() {
        try {
            return em.createQuery("SELECT p FROM Post p", Post.class)
                     .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public long getPostCount() {
        return em.createQuery("SELECT COUNT(p) FROM Post p", Long.class).getSingleResult();
    }

    public double getTotalPlatformBudget() {
        Double total = em.createQuery("SELECT SUM(p.budget) FROM Post p", Double.class).getSingleResult();
        return total != null ? total : 0.0;
    }
}