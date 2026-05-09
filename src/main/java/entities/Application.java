package entities;

import java.io.Serializable;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(
	    name = "applications",
	    uniqueConstraints = {
	        @UniqueConstraint(columnNames = {"freelancer_id", "post_id"})
	    }
	)// bech nahiw double appli. (freelancer yaaml * apply fard job)

@NamedQuery(name="Application.findAll", query="SELECT a FROM Application a")
public class Application implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="application_id")
	private int applicationId;

	@Column(name="created_at")
	private LocalDateTime createdAt;

	@Enumerated(EnumType.STRING)
	private ApplicationStatus status;

	public enum ApplicationStatus {
		PENDING,
		ACCEPTED,
		REJECTED
	} //kif kif kima l posts

	//bi-directional many-to-one association to User
	@ManyToOne
	@JoinColumn(name="freelancer_id")
	private User freelancer;

	//bi-directional many-to-one association to Post
	@ManyToOne
	@JoinColumn(name="post_id")
	private Post post;
	
	private Integer rating;

	public Application() {
		this.createdAt = LocalDateTime.now(); //nahiw el null dates
		this.status = ApplicationStatus.PENDING; // status par defaut
	}

	public int getApplicationId() {
		return this.applicationId;
	}

	public void setApplicationId(int applicationId) {
		this.applicationId = applicationId;
	}

	public LocalDateTime getCreatedAt() {
		return this.createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public ApplicationStatus getStatus() {
		return this.status;
	}

	public void setStatus(ApplicationStatus status) {
		this.status = status;
	}

	public User getFreelancer() {
		return freelancer;
	}

	public void setFreelancer(User freelancer) {
		this.freelancer = freelancer;
	}

	public Post getPost() {
		return this.post;
	}

	public void setPost(Post post) {
		this.post = post;
	}

	
	public Integer getRating() {
	    return rating;
	}

	public void setRating(Integer rating) {
	    this.rating = rating;
	}
}