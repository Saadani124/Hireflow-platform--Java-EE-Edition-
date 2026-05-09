package entities;

import java.io.Serializable;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name="users")
@NamedQuery(name="User.findAll", query="SELECT u FROM User u")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="user_id")
    private int userId;

    private String address;

    @Column(name="created_at")
    private LocalDateTime createdAt;

    private String name;

    private String password;

    private String role;
    
    @Lob
    private String bio;
    
    private String skills;

    
    @Column(unique = true)
    private String username;

    @Column(unique = true)
    private String email;

    // APPLICATIONS (freelancer applies)
    @OneToMany(mappedBy="freelancer", fetch=FetchType.LAZY, cascade=CascadeType.ALL)
    private List<Application> applications;

    // APPLICATIONS (client post job)
    @OneToMany(mappedBy="client", fetch=FetchType.LAZY, cascade=CascadeType.ALL)
    private List<Post> posts;

    public User() {
    }

    public int getUserId() {
        return this.userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAddress() {
        return this.address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return this.role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }


    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<Application> getApplications() {
        return this.applications;
    }

    public void setApplications(List<Application> applications) {
        this.applications = applications;
    }

    public Application addApplication(Application application) {
        getApplications().add(application);
        application.setFreelancer(this);
        return application;
    }

    public Application removeApplication(Application application) {
        getApplications().remove(application);
        application.setFreelancer(null);
        return application;
    }

    public List<Post> getPosts() {
        return this.posts;
    }

    public void setPosts(List<Post> posts) {
        this.posts = posts;
    }

    public Post addPost(Post post) {
        getPosts().add(post);
        post.setClient(this);
        return post;
    }

    public Post removePost(Post post) {
        getPosts().remove(post);
        post.setClient(null);
        return post;
    }
}