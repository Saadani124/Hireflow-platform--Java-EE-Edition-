<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HireFlow — The Freelance Marketplace</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/indexStyle.css">
</head>
<body>

<nav>
  <a href="index.jsp" class="logo">Hire<span>Flow</span></a>
  <div class="nav-links">
    <a href="login.jsp" class="ghost">Sign In</a>
    <a href="register.jsp" class="primary">Get Started</a>
  </div>
</nav>

<section class="hero">
  <div class="hero-inner">
    <div class="hero-badge"><span class="dot"></span> Now live — 25+ open projects</div>
    <h1>Find work.<br>Hire talent.<br><span class="highlight">Move fast.</span></h1>
    <p class="hero-sub">HireFlow connects skilled freelancers with clients who get things done. Post a job in minutes, get proposals fast.</p>
    <div class="cta-row">
      <a href="register.jsp" class="btn-primary">Start for free →</a>
      <a href="login.jsp" class="btn-ghost">I have an account</a>
    </div>
  </div>
</section>

<div class="stats">
  <div class="stat-item"><div class="stat-num">25<span>+</span></div><div class="stat-label">Open Projects</div></div>
  <div class="stat-item"><div class="stat-num">100<span>%</span></div><div class="stat-label">Secure Payments</div></div>
  <div class="stat-item"><div class="stat-num">2</div><div class="stat-label">Roles Supported</div></div>
  <div class="stat-item"><div class="stat-num">0</div><div class="stat-label">Hidden Fees</div></div>
</div>

<section class="features">
  <p class="section-label">Why HireFlow</p>
  <h2>Built for real work</h2>
  <p class="section-sub">Everything you need — nothing you don't.</p>
  <div class="cards">
    <div class="card">
      <div class="card-icon blue">⚡</div>
      <h3>Fast Hiring</h3>
      <p>Post a job and start receiving proposals within minutes from qualified freelancers.</p>
    </div>
    <div class="card">
      <div class="card-icon cyan">🎯</div>
      <h3>Smart Matching</h3>
      <p>Browse open jobs filtered by budget and keyword — find the perfect fit instantly.</p>
    </div>
    <div class="card">
      <div class="card-icon green">🔒</div>
      <h3>Secure & Simple</h3>
      <p>BCrypt-hashed passwords, session management, and role-based access out of the box.</p>
    </div>
  </div>
</section>

<div class="cta-section">
  <h2>Ready to get started?</h2>
  <p>Join HireFlow today. It takes less than a minute.</p>
  <a href="register.jsp" class="btn-white">Create Free Account</a>
</div>

<footer>© 2026 HireFlow — All rights reserved</footer>

</body>
</html>
