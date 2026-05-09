package entities;

import java.io.Serializable;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="posts")
@NamedQuery(name="Post.findAll", query="SELECT p FROM Post p")
public class Post implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="post_id")
    private int postId;

    private double budget;

    @Column(name="created_at")
    private LocalDateTime createdAt;

    @Lob
    private String description;

    @Enumerated(EnumType.STRING)
    private PostStatus status;

    public enum PostStatus {
        OPEN,
        IN_PROGRESS,
        CLOSED
    } //post.setStatus(PostStatus.OPEN); fi oudh hedhi post.setStatus("OPEN"); 


    private String title;

    // APPLICATIONS
    @OneToMany(mappedBy="post", fetch=FetchType.LAZY, cascade=CascadeType.ALL)    
    private List<Application> applications = new ArrayList<>(); //important bch ken fergha tamlch crash

    // CLIENT (OWNER OF POST)
    @ManyToOne
    @JoinColumn(name = "client_id")
    private User client;

    public Post() {
    }

    public int getPostId() {
        return this.postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public double getBudget() {
        return this.budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public PostStatus getStatus() {
        return this.status;
    }

    public void setStatus(PostStatus status) {
        this.status = status;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<Application> getApplications() {
        return this.applications;
    }

    public void setApplications(List<Application> applications) {
        this.applications = applications;
    }

    public Application addApplication(Application application) {
        getApplications().add(application);
        application.setPost(this);
        return application;
    }

    public Application removeApplication(Application application) {
        getApplications().remove(application);
        application.setPost(null);
        return application;
    }

    public User getClient() {
        return this.client;
    }

    public void setClient(User client) {
        this.client = client;
    }
}