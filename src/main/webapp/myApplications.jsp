<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="user" value="${sessionScope.activeUser}" />
<c:if test="${user == null}">
    <c:redirect url="login.jsp"/>
</c:if>

<c:set var="applications" value="${requestScope.applications}" />
<c:if test="${applications == null}">
    <c:set var="applications" value="${emptyList}" />
</c:if>

<!-- Calculate stats -->
<c:set var="pending" value="0" />
<c:set var="accepted" value="0" />
<c:set var="rejected" value="0" />

<c:forEach var="a" items="${applications}">
    <c:choose>
        <c:when test="${a.status.toString() == 'PENDING'}">
            <c:set var="pending" value="${pending + 1}" />
        </c:when>
        <c:when test="${a.status.toString() == 'ACCEPTED'}">
            <c:set var="accepted" value="${accepted + 1}" />
        </c:when>
        <c:when test="${a.status.toString() == 'REJECTED'}">
            <c:set var="rejected" value="${rejected + 1}" />
        </c:when>
    </c:choose>
</c:forEach>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Applications — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/myAppStyle.css">
</head>
<body>

<aside class="sidebar">

  <a href="PostServlet?action=home" class="sidebar-logo">Hire<span>Flow</span></a>

  <div class="sidebar-user">
    <div class="avatar-circle">${fn:toUpperCase(fn:substring(user.username,0,1))}</div>
    <div class="user-info">
      <div class="uname">${user.name != null ? user.name : user.username}</div>
      <div class="urole">${user.role}</div>
    </div>
  </div>

  <nav class="nav-section">
    <div class="nav-label">Main</div>
    <c:if test="${user.role == 'ADMIN'}">
        <a href="AdminServlet?action=dashboard" class="nav-item">
          <span class="icon">🛡️</span> Admin
        </a>
    </c:if>
    <c:if test="${user.role != 'ADMIN'}">
        <a href="PostServlet?action=home" class="nav-item"><span class="icon">🏠</span> Dashboard</a>
        <a href="ApplicationServlet?action=my" class="nav-item active"><span class="icon">📋</span> My Applications</a>
        <a href="PostServlet?action=stats" class="nav-item"><span class="icon">📊</span> Statistics</a>
    </c:if>
    <a href="SettingsServlet" class="nav-item">
      <span class="icon">⚙️</span> Settings
    </a>
  </nav>

  <div class="sidebar-bottom">
    <form action="AuthServlet" method="post">
      <input type="hidden" name="action" value="logout">
      <button class="logout-btn" type="submit"><span>🚪</span> Sign Out</button>
    </form>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <span class="topbar-title">My Applications</span>
    <div class="topbar-stats">
      <div class="mini-stat">
        <span class="mini-stat-num">${fn:length(applications)}</span>
        <span class="mini-stat-label">Total</span>
      </div>
    </div>
  </div>

  <div class="content">

    <c:if test="${not empty applications}">
    <!-- Stats Row -->
    <div class="stats-row">
      <div class="stat-card yellow">
        <div class="snum">${pending}</div>
        <div class="slabel">Pending</div>
      </div>
      <div class="stat-card green">
        <div class="snum">${accepted}</div>
        <div class="slabel">Accepted</div>
      </div>
      <div class="stat-card red">
        <div class="snum">${rejected}</div>
        <div class="slabel">Rejected</div>
      </div>
    </div>
    </c:if>

    <c:choose>

    <c:when test="${empty applications}">
    <div class="empty">
      <div class="empty-icon">📭</div>
      <h3>No applications yet</h3>
      <p>You haven't applied to any jobs.</p>
      <a href="PostServlet?action=home" class="find-jobs-btn">Find Jobs</a>
    </div>
    </c:when>

    <c:otherwise>

    <div class="app-grid">

<c:forEach var="a" items="${applications}">

  <c:set var="statusClass" value="status-pending" />
  <c:set var="statusText" value="PENDING" />
  <c:set var="statusIcon" value="⏳" />

  <c:if test="${a.status.toString() == 'ACCEPTED'}">
    <c:set var="statusClass" value="status-accepted" />
    <c:set var="statusText" value="ACCEPTED" />
    <c:set var="statusIcon" value="✓" />
  </c:if>

  <c:if test="${a.status.toString() == 'REJECTED'}">
    <c:set var="statusClass" value="status-rejected" />
    <c:set var="statusText" value="REJECTED" />
    <c:set var="statusIcon" value="✗" />
  </c:if>

  <!-- Check if job is completed -->
  <c:set var="isCompleted" value="${a.post.status.toString() == 'CLOSED'}" />

  <div class="app-card ${statusClass}">
    
    <!-- Card Header -->
    <div class="card-header">
      <div class="card-title-section">
        <h3 class="card-title">${a.post.title}</h3>
        <p class="card-subtitle">
          Applied ${a.createdAt != null ? a.createdAt : "recently"}
        </p>
      </div>
      <div class="status-badge ${statusClass}">
        <span class="status-icon">${statusIcon}</span>
        <span class="status-text">${statusText}</span>
      </div>
    </div>

    <!-- Card Body -->
    <div class="card-body">
      <p class="card-desc">${a.post.description}</p>
    </div>

    <!-- Card Footer -->
    <div class="card-footer">
      <div class="footer-left">
        <div class="budget-section">
          <span class="budget-label">Budget</span>
          <span class="budget-amount">$${a.post.budget}</span>
        </div>
      </div>
      
      <div class="footer-right">

        <c:choose>

        <c:when test="${a.rating != null}">
          <div class="rating-display">
            <span class="rating-stars">
              <c:forEach begin="1" end="${a.rating}">⭐</c:forEach>
            </span>
            <span class="rating-value">${a.rating}/5</span>
          </div>
        </c:when>

        <c:when test="${isCompleted and a.status.toString() == 'ACCEPTED'}">
          <div class="job-complete-badge">
            <span class="complete-icon">✓</span>
            <span class="complete-text">Completed</span>
          </div>
        </c:when>

        </c:choose>

      </div>
    </div>

  </div>

</c:forEach>

</div>

    </c:otherwise>
    </c:choose>

  </div>
</div>

<!-- EMAIL POPUP -->
<c:if test="${user.email == null or empty user.email}">
<div class="overlay open" id="emailOverlay" style="display: flex; z-index: 9999; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); align-items: center; justify-content: center;">
  <div class="popup-box" style="background: white; padding: 2rem; border-radius: 12px; text-align: center; max-width: 400px; width: 90%;">
    <h3>Welcome to HireFlow!</h3>
    <p style="margin-bottom: 20px; color: #64748b;">Please provide your email address to continue using the platform.</p>
    
    <div id="emailError" style="color: #ef4444; font-size: 13px; margin-bottom: 10px; display: none;"></div>
    
    <form id="emailForm">
      <div class="field" style="text-align: left; margin-bottom: 20px;">
        <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: #475569; text-transform: uppercase;">Email Address</label>
        <input type="email" id="popupEmail" name="email" placeholder="e.g. name@example.com" required 
               style="width: 100%; padding: .82rem 1rem; border-radius: 10px; border: 1.5px solid #e2e8f0; outline: none; font-family: inherit;">
      </div>
      <div class="popup-actions">
        <button type="button" class="btn-confirm" 
                data-email="${fn:escapeXml(user.email)}"
                data-name="${fn:escapeXml(user.name)}"
                data-address="${fn:escapeXml(user.address)}"
                onclick="savePopupEmail(this.getAttribute('data-email'), this.getAttribute('data-name'), this.getAttribute('data-address'))" 
                style="width: 100%; padding: .9rem; background: #2563eb; color: white; border: none; border-radius: 10px; font-weight: 700; cursor: pointer;">Save and Continue</button>
      </div>
    </form>
  </div>
</div>

<script src="js/myApplications.js"></script>
</c:if>
</body>
</html>
