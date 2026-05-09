package mvcModel;

import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import utils.PasswordUtil;

import java.util.List;

import entities.User;

@Stateless
@LocalBean
public class UserService {
    
    @PersistenceContext(unitName="hireflow")
    private EntityManager em;

    // REGISTER USER
    public boolean register(String username, String password, String name, String role) {
        
        // check if username exists
        List<User> existing = em.createQuery(
            "SELECT u FROM User u WHERE u.username = :username", User.class)
            .setParameter("username", username)
            .getResultList();

        if (!existing.isEmpty()) {
            return false;
        }

        User user = new User();
        user.setUsername(username);

        String hashedPassword = PasswordUtil.hashPassword(password);
        user.setPassword(hashedPassword);

        user.setName(name);
        user.setRole(role);

        em.persist(user);
        return true;
    }

    public User login(String username, String password) {
        //System.out.println("SERVICE username: " + username);

        List<User> users = em.createQuery(
            "SELECT u FROM User u WHERE u.username = :username", User.class)
            .setParameter("username", username)
            .getResultList();

        //System.out.println("Users found: " + users.size());

        if (users.isEmpty()) return null;

        User user = users.get(0);

        //System.out.println("DB password: " + user.getPassword());
        //System.out.println("Input hashed: " + PasswordUtil.hashPassword(password));
        //System.out.println(PasswordUtil.hashPassword("saad"));

        if (PasswordUtil.checkPassword(password, user.getPassword())) {
            //System.out.println("PASSWORD MATCH ✔");
            return user;
        }
        //System.out.println("PASSWORD FAIL ❌");
        return null;
    }
    
    // FIND USER BY USERNAME
    public User findByUsername(String username) {
        List<User> users = em.createQuery(
            "SELECT u FROM User u WHERE u.username = :username", User.class)
            .setParameter("username", username)
            .getResultList();

        return users.isEmpty() ? null : users.get(0);
    }
    
    // UPDATE USER INFO
    public boolean updateUser(int userId, String name, String email, String password, String address, String bio, String skills) {
        User user = em.find(User.class, userId);
        if (user == null) return false;
        
        if (email != null && !email.trim().isEmpty()) {
            List<User> others = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.userId <> :id", User.class)
                .setParameter("email", email)
                .setParameter("id", userId)
                .getResultList();
            if (!others.isEmpty()) return false;
            user.setEmail(email);
        }

        user.setName(name);
        user.setAddress(address);

        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(password));
        }
        if ("FREELANCER".equals(user.getRole())) {
            user.setBio(bio);
            user.setSkills(skills);
        }
        
        em.merge(user);
        return true;
    }
    
    // ADMIN: UPDATE EVERYTHING
    public boolean updateUserDetailsAdmin(int userId, String name, String email, String password, String address, String role, String bio, String skills) {
        User user = em.find(User.class, userId);
        if (user == null) return false;

        user.setName(name);
        user.setEmail(email);
        user.setAddress(address);
        user.setRole(role);
        user.setBio(bio);
        user.setSkills(skills);

        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(password));
        }

        em.merge(user);
        return true;
    }

    // ADMIN: GET ALL USERS
    public List<User> getAllUsers() {
        return em.createQuery("SELECT u FROM User u", User.class).getResultList();
    }
    
    public long getUserCount() {
        return em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
    }
    
    // ADMIN: DELETE USER
    public boolean deleteUser(int userId) {
        User user = em.find(User.class, userId);
        if (user != null) {
            em.remove(user);
            return true;
        }
        return false;
    }

    public boolean isEmailUnique(String email, int excludeUserId) {
        List<User> users = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.userId <> :id", User.class)
            .setParameter("email", email)
            .setParameter("id", excludeUserId)
            .getResultList();
        return users.isEmpty();
    }
}