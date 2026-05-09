<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="user" value="${sessionScope.activeUser}" />

<c:if test="${user == null}">
    <c:redirect url="login.jsp"/>
</c:if>

<c:if test="${user.role != 'CLIENT'}">
    <c:redirect url="PostServlet?action=home"/>
</c:if>

<c:set var="msg" value="${param.msg}" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Post a Job — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/createPostStyle.css">
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
        <a href="createPost.jsp" class="nav-item active"><span class="icon">➕</span> Post Job</a>
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
    <span class="topbar-title">Post Job</span>
  </div>

  <div class="content">
    <div class="form-wrap">
      <div class="form-header">
        <h1>What's on your mind?</h1>
        <p>Fill in the details and start receiving proposals from freelancers</p>
      </div>

      <c:if test="${msg == 'created'}">
      <div class="success-banner">
        <span>🎉</span> Job posted successfully! Freelancers can now apply.
      </div>
      </c:if>

      <div class="form-card">

        <form action="PostServlet" method="post" onsubmit="createPost(event)">
          <input type="hidden" name="action" value="create">

          <div class="field">
            <label>Job Title</label>
            <input type="text" id="title" name="title" placeholder="e.g. Build a React Dashboard" required>
          </div>

          <div class="field">
            <label>Description</label>
            <textarea id="description" name="description" placeholder="Describe the project, requirements, deliverables..." required></textarea>
          </div>

          <div class="field">
            <label>Budget (USD)</label>
            <input type="number" id="budget" name="budget" placeholder="e.g. 1500" min="1" required>
            <p class="budget-hint">Set a fair budget to attract quality applicants</p>
          </div>

          <button type="submit" class="submit-btn">Publish Job →</button>
        </form>
      </div>

      <div class="tips">
        <h4>Tips for a great job post</h4>
        <ul>
          <li>Be specific about the scope and deliverables</li>
          <li>Set a realistic budget based on the complexity</li>
          <li>Mention any required skills or tools</li>
          <li>Include deadlines or timeline expectations</li>
        </ul>
      </div>
    </div>
  </div>
</div>
<script src="js/createPost.js"></script>

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