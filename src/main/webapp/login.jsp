<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="error" value="${requestScope.error}" />
<c:set var="hasError" value="${error != null and not empty error}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign In — HireFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style/loginStyle.css">
</head>
<body>

<div class="left-panel">
    <a href="index.jsp" class="logo">Hire<span>Flow</span></a>
    <div class="panel-content">
        <h2>The future of work has an <em>electric</em> pulse.</h2>
        <p>Connect with world-class talent or find your next project — all in one platform built for speed.</p>
    </div>
    <div class="proof">
        <div class="avatars">
            <div class="avatar" style="background:#3b82f6">A</div>
            <div class="avatar" style="background:#06b6d4">M</div>
            <div class="avatar" style="background:#8b5cf6">S</div>
        </div>
        <div class="proof-text"><strong>20k+ experts</strong> hired this month</div>
    </div>
</div>

<div class="right-panel">
    <div class="form-box">
        <h1>Welcome back</h1>
        <p class="sub">Sign in to your HireFlow dashboard.</p>

        <c:if test="${hasError}">
        <div class="error-banner">
            <span class="error-icon">⚠</span>
            ${error}
        </div>
        </c:if>

        <form action="AuthServlet" method="post" onsubmit="login(event)" novalidate>

            <!-- FIX: required for servlet -->
            <input type="hidden" name="action" value="login">

            <div class="field-group">
                <label for="username">Username</label>
                <div class="input-wrap">
                    <input type="text" id="username" name="username"
                           placeholder="Username"
                           class="${hasError ? 'error-input' : ''}"
                           value="${param.username != null ? param.username : ''}">
                </div>
            </div>

            <div class="field-group">
                <div class="row-between">
                    <label for="password">Password</label>
                </div>
                <div class="input-wrap">
                    <input type="password" id="password" name="password"
                           placeholder="******"
                           class="${hasError ? 'error-input' : ''}">
                </div>
            </div>

            <button type="submit" class="submit-btn">Sign In to Dashboard →</button>
        </form>

        <p class="bottom-link">New to HireFlow? <a href="register.jsp">Create an account</a></p>
    </div>
</div>

<script src="js/login.js"></script>

</body>
</html>