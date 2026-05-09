<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="user" value="${sessionScope.activeUser}" />

<c:if test="${user == null}">
    <c:redirect url="login.jsp"/>
</c:if>

<c:set var="current" value="stats" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Statistics — HireFlow</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/homestyle.css">
<link rel="stylesheet" href="style/statsstyle.css">

</head>
<body>

<!-- SIDEBAR -->
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
        <a href="PostServlet?action=home"
           class="nav-item ${current == 'home' ? 'active' : ''}">
          <span class="icon">🏠</span> Dashboard
        </a>
    
        <c:choose>
          <c:when test="${user.role == 'CLIENT'}">
            <a href="createPost.jsp"
               class="nav-item ${current == 'create' ? 'active' : ''}">
              <span class="icon">➕</span> Post Job
            </a>
          </c:when>
          <c:otherwise>
            <a href="ApplicationServlet?action=my" class="nav-item">
              <span class="icon">📋</span> My Applications
            </a>
          </c:otherwise>
        </c:choose>
    
        <a href="PostServlet?action=stats"
           class="nav-item ${current == 'stats' ? 'active' : ''}">
          <span class="icon">📊</span> Statistics
        </a>
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

<!-- MAIN -->
<div class="main">

  <div class="topbar">
    <span class="topbar-title">Statistics</span>
  </div>

  <div class="content">

    <c:choose>

    <%-- ================= CLIENT ================= --%>
    <c:when test="${user.role == 'CLIENT'}">

      <div class="stats-container">

        <div class="stat-card stat-open">
          <div class="stat-header">
            <div class="stat-title">Open Jobs</div>
            <div class="stat-icon">🟢</div>
          </div>
          <div class="stat-value">${openJobs}</div>
        </div>

        <div class="stat-card stat-progress">
          <div class="stat-header">
            <div class="stat-title">In Progress</div>
            <div class="stat-icon">🔄</div>
          </div>
          <div class="stat-value">${inProgressJobs}</div>
        </div>

        <div class="stat-card stat-completed">
          <div class="stat-header">
            <div class="stat-title">Completed</div>
            <div class="stat-icon">✅</div>
          </div>
          <div class="stat-value">${closedJobs}</div>
        </div>

        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-title">Total Spent</div>
            <div class="stat-icon">💰</div>
          </div>
          <div class="stat-value">$${totalSpent}</div>
        </div>

        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-title">Total Jobs</div>
            <div class="stat-icon">📁</div>
          </div>
          <div class="stat-value">${totalJobs}</div>
        </div>

      </div>

      <!-- CHARTS SECTION -->
      <div class="charts-section" style="margin-top: 30px; background: white; padding: 2rem; border-radius: 14px; border: 1px solid #e8edf2;">
        <h3 style="font-family: 'Syne', sans-serif; margin-bottom: 20px;">Project Status Distribution</h3>
        <div style="max-width: 400px; margin: 0 auto;">
          <canvas id="clientChart" data-open="${openJobs}" data-progress="${inProgressJobs}" data-completed="${closedJobs}"></canvas>
        </div>
      </div>

    </c:when>

    <%--================= FREELANCER ================= --%>
    <c:otherwise>

      <div class="stats-container">

        <div class="stat-card stat-accepted">
          <div class="stat-header">
            <div class="stat-title">Your Rating</div>
            <div class="stat-icon">⭐</div>
          </div>

          <div class="stat-value">
            ${avgRating > 0 ? avgRating : '-'}
          </div>

          <c:choose>

            <c:when test="${avgRating > 0}">
              <div style="font-size:18px; color:#f59e0b; margin-top:6px;">
                <c:forEach begin="1" end="${fullStars}">
                  ⭐
                </c:forEach>
              </div>
            </c:when>

            <c:otherwise>
              <div style="color:#6b7280; font-size:13px; margin-top:6px;">
                No ratings yet
              </div>
            </c:otherwise>

          </c:choose>
        </div>

        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-title">Total Earnings</div>
            <div class="stat-icon">💵</div>
          </div>
          <div class="stat-value">$${totalEarnings}</div>
        </div>

        <div class="stat-card stat-pending">
          <div class="stat-header">
            <div class="stat-title">Pending</div>
            <div class="stat-icon">🕒</div>
          </div>
          <div class="stat-value">${pendingApps}</div>
        </div>

        <div class="stat-card stat-accepted">
          <div class="stat-header">
            <div class="stat-title">Accepted</div>
            <div class="stat-icon">🎯</div>
          </div>
          <div class="stat-value">${acceptedApps}</div>
        </div>

        <div class="stat-card stat-rejected">
          <div class="stat-header">
            <div class="stat-title">Rejected</div>
            <div class="stat-icon">❌</div>
          </div>
          <div class="stat-value">${rejectedApps}</div>
        </div>

      </div>

      <!-- CHARTS SECTION -->
      <div class="charts-section" style="margin-top: 30px; background: white; padding: 2rem; border-radius: 14px; border: 1px solid #e8edf2;">
        <h3 style="font-family: 'Syne', sans-serif; margin-bottom: 20px;">Application Success Rate</h3>
        <div style="max-width: 400px; margin: 0 auto;">
          <canvas id="freelancerChart" data-pending="${pendingApps}" data-accepted="${acceptedApps}" data-rejected="${rejectedApps}"></canvas>
        </div>
      </div>

    </c:otherwise>

    </c:choose>

  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="js/stats.js"></script>

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
</c:if>

</body>
</html>