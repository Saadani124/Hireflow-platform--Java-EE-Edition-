<%@ page contentType="text/html;charset=UTF-8" %>
<%

%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Create Account — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/registerStyle.css">
</head>
<body>

<div class="page-wrap">
  <div class="left-panel">
    <a href="index.jsp" class="logo">Hire<span>Flow</span></a>
    <div class="left-content">
      <h2>Join the <em>marketplace</em></h2>
      <p>Start hiring top talent or find your next dream gig on HireFlow.</p>
      <div class="role-cards">
        <div class="role-card">
          <strong>🏢 Client</strong>
          <span>Post jobs and hire the best freelancers</span>
        </div>
        <div class="role-card">
          <strong>💼 Freelancer</strong>
          <span>Browse open projects and apply instantly</span>
        </div>
      </div>
    </div>
  </div>

  <div class="right-panel">
    <h1>Create Account</h1>
    <p class="sub">Get started — it only takes a minute.</p>

	<div id="errorBox" class="error-banner" style="display:none;"></div>

    <!-- FIX -->
    <form action="AuthServlet" method="post" onsubmit="register(event)">

      <!-- REQUIRED -->
      <input type="hidden" name="action" value="register">

      <div class="grid2">
        <div class="field">
          <label>Full Name</label>
          <!-- FIX: add name -->
          <input type="text" id="name" name="name" placeholder="John Doe" required>
        </div>

        <div class="field">
          <label>Username</label>
          <!-- FIX: add name -->
		  <input type="text" id="username" name="username" placeholder="john_doe" required>
        </div>

        <div class="field full">
          <label>Address</label>
          <!-- KEEP (even if backend doesn’t use it) -->
          <input type="text" id="address" name="address" placeholder="City, Country" required>
        </div>

        <div class="field full">
          <label>Password</label>
          <!-- FIX: add name -->
          <input type="password" id="password" name="password" placeholder="Create a strong password" required>
        </div>

        <div class="field full">
          <label>I am a...</label>
          <!-- FIX: add name -->
          <select id="role" name="role" required>
            <option value="FREELANCER">Freelancer — Looking for work</option>
            <option value="CLIENT">Client — Looking to hire</option>
          </select>
        </div>
      </div>

      <button type="submit" class="submit-btn">Create Account →</button>
    </form>

    <p class="bottom-link">Already have an account? <a href="login.jsp">Sign in instead</a></p>
  </div>
</div>

<script src="js/register.js"></script>
</body>
</html>