package mvcModel;

import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import entities.ActivityLog;

@Stateless
@LocalBean
public class ActivityLogService {

    @PersistenceContext(unitName="hireflow")
    private EntityManager em;

    public void log(int userId, String username, String action, String details) {
        ActivityLog log = new ActivityLog();
        log.setUserId(userId);
        log.setUsername(username);
        log.setAction(action);
        log.setDetails(details);
        em.persist(log);
    }

    public List<ActivityLog> getRecentLogs(int limit) {
        return em.createQuery("SELECT l FROM ActivityLog l ORDER BY l.timestamp DESC", ActivityLog.class)
                 .setMaxResults(limit)
                 .getResultList();
    }

    public long getLogCount() {
        return em.createQuery("SELECT COUNT(l) FROM ActivityLog l", Long.class).getSingleResult();
    }
}
