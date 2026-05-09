<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="user" value="${sessionScope.activeUser}" />

<c:if test="${user == null}">
    <c:redirect url="login.jsp"/>
</c:if>

<c:set var="msg" value="${param.msg}" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Settings — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/createPostStyle.css">
<style>
  .settings-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
  }
  .settings-grid .field.full {
      grid-column: 1 / -1;
  }
  .success-banner {
      background: #d1fae5;
      color: #065f46;
      padding: 12px;
      border-radius: 8px;
      margin-bottom: 20px;
      font-weight: 500;
  }
  .error-banner {
      background: #fee2e2;
      color: #991b1b;
      padding: 12px;
      border-radius: 8px;
      margin-bottom: 20px;
      font-weight: 500;
  }
</style>
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
        <a href="AdminServlet?action=dashboard" class="nav-item"><span class="icon">🛡️</span> Admin</a>
    </c:if>
    <c:if test="${user.role != 'ADMIN'}">
        <a href="PostServlet?action=home" class="nav-item"><span class="icon">🏠</span> Dashboard</a>
        <c:if test="${user.role == 'CLIENT'}">
            <a href="createPost.jsp" class="nav-item"><span class="icon">➕</span> Post Job</a>
        </c:if>
        <c:if test="${user.role == 'FREELANCER'}">
            <a href="ApplicationServlet?action=my" class="nav-item"><span class="icon">📋</span> My Applications</a>
        </c:if>
        <a href="PostServlet?action=stats" class="nav-item"><span class="icon">📊</span> Statistics</a>
    </c:if>
    <a href="SettingsServlet" class="nav-item active"><span class="icon">⚙️</span> Settings</a>
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
    <span class="topbar-title">Settings</span>
  </div>

  <div class="content">
    <div class="form-wrap" style="max-width: 800px;">
      <div class="form-header">
        <h1>Your Profile</h1>
        <p>Update your personal information and profile details.</p>
      </div>

      <c:if test="${msg == 'success'}">
      <div class="success-banner">
        <span>🎉</span> Profile updated successfully!
      </div>
      </c:if>
      
      <c:if test="${msg == 'error'}">
      <div class="error-banner">
        <span>⚠️</span> There was an error updating your profile.
      </div>
      </c:if>

      <div class="form-card">
        <form action="SettingsServlet" method="post">
          <input type="hidden" name="action" value="update">

          <div class="settings-grid">
              <div class="field">
                <label>Full Name</label>
                <input type="text" id="name" name="name" value="${user.name}" required>
              </div>
    
              <div class="field">
                <label>Email</label>
                <input type="email" id="email" name="email" value="${user.email}" placeholder="your@email.com" required>
              </div>

              <div class="field">
                <label>Location / Address</label>
                <input type="text" id="address" name="address" value="${user.address}">
              </div>
              
              <div class="field full">
                <label>New Password (leave blank to keep current)</label>
                <input type="password" id="password" name="password" placeholder="New strong password">
              </div>

              <c:if test="${user.role == 'FREELANCER'}">
                  <div class="field full">
                    <label>Skills (comma separated)</label>
                    <input type="text" id="skills" name="skills" value="${user.skills}" placeholder="e.g. Java, React, Figma, SEO">
                  </div>

                  <div class="field full">
                    <label style="display: flex; justify-content: space-between; align-items: center;">
                      Bio
                      <button type="button" onclick="openBioModal()" style="background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 4px;">
                        <span>✨</span> Generate with AI
                      </button>
                    </label>
                    <textarea id="bio" name="bio" placeholder="Tell clients about yourself, your experience, and your goals..." rows="4">${user.bio}</textarea>
                  </div>
              </c:if>

          </div>

          <button type="submit" class="submit-btn" style="margin-top: 20px;">Save Changes</button>
        </form>
      </div>

    </div>
  </div>
</div>

<!-- AI BIO MODAL -->
<div id="bioModal" class="overlay" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); backdrop-filter: blur(4px); z-index: 10000; align-items: center; justify-content: center;">
  <div class="popup-box" style="background: white; padding: 2rem; border-radius: 16px; width: 100%; max-width: 500px; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
      <h3 style="font-family: 'Syne', sans-serif; font-weight: 800; margin: 0;">✨ AI Bio Generator</h3>
      <button onclick="closeBioModal()" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #94a3b8;">&times;</button>
    </div>
    
    <p style="color: #64748b; font-size: 0.9rem; margin-bottom: 1.5rem;">Answer a few questions to help our AI craft your perfect professional summary.</p>
    
    <div id="bioQuestions">
      <div class="field" style="margin-bottom: 1rem;">
        <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: #475569; text-transform: uppercase;">What is your primary area of expertise?</label>
        <input type="text" id="q1" placeholder="e.g. Full-stack Web Development" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #e2e8f0; outline: none;">
      </div>
      <div class="field" style="margin-bottom: 1rem;">
        <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: #475569; text-transform: uppercase;">Years of experience?</label>
        <input type="text" id="q2" placeholder="e.g. 5+ years" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #e2e8f0; outline: none;">
      </div>
      <div class="field" style="margin-bottom: 1rem;">
        <label style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: #475569; text-transform: uppercase;">A major professional achievement?</label>
        <input type="text" id="q3" placeholder="e.g. Led a team of 10 to launch a successful app" style="width: 100%; padding: 10px; border-radius: 8px; border: 1.5px solid #e2e8f0; outline: none;">
      </div>
    </div>
    
    <div id="aiLoading" style="display: none; text-align: center; padding: 2rem;">
      <div style="width: 40px; height: 40px; border: 4px solid #f3f3f3; border-top: 4px solid #6366f1; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 1rem;"></div>
      <p style="color: #6366f1; font-weight: 600;">Generating your masterpiece...</p>
    </div>

    <div class="popup-actions" style="margin-top: 1.5rem;">
      <button onclick="generateBio()" id="genBtn" style="width: 100%; padding: 12px; background: #6366f1; color: white; border: none; border-radius: 10px; font-weight: 700; cursor: pointer; transition: background 0.2s;">Generate Bio</button>
    </div>
  </div>
</div>

<style>
@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
</style>

<script src="js/settings.js"></script>
</body>
</html>
