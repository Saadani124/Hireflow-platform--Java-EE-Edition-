<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="user" value="${sessionScope.activeUser}" />
<c:if test="${user == null}">
    <c:redirect url="login.jsp"/>
</c:if>

<c:set var="posts" value="${requestScope.posts}" />
<c:if test="${posts == null}">
    <c:set var="posts" value="${emptyList}" />
</c:if>

<c:set var="search" value="${param.search != null ? param.search : ''}" />

<c:set var="minBudget" value="999999999" />
<c:set var="maxBudget" value="0" />

<c:forEach var="p" items="${posts}">
    <c:if test="${p.budget < minBudget}">
        <c:set var="minBudget" value="${p.budget}" />
    </c:if>
    <c:if test="${p.budget > maxBudget}">
        <c:set var="maxBudget" value="${p.budget}" />
    </c:if>
</c:forEach>

<c:if test="${empty posts}">
    <c:set var="minBudget" value="0" />
    <c:set var="maxBudget" value="10000" />
</c:if>

<c:set var="msg" value="${param.msg}" />

<c:set var="pendingCounts" value="${requestScope.pendingCounts}" />
<c:set var="acceptedMap" value="${requestScope.acceptedMap}" />
<c:set var="appliedPostIds" value="${requestScope.appliedPostIds}" />
<c:set var="ratingsMap" value="${requestScope.ratingsMap}" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>HireFlow — Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style/homestyle.css">
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
        <a href="PostServlet?action=home" class="nav-item active">
          <span class="icon">🏠</span> Dashboard
        </a>
    
        <c:if test="${user.role == 'CLIENT'}">
        <a href="createPost.jsp" class="nav-item">
          <span class="icon">➕</span> Post Job
        </a>
        </c:if>
    
        <c:if test="${user.role == 'FREELANCER'}">
        <a href="ApplicationServlet?action=my" class="nav-item">
          <span class="icon">📋</span> My Applications
        </a>
        </c:if>
        
        <a href="PostServlet?action=stats" class="nav-item">
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
      <button class="logout-btn" type="submit">
        <span>🚪</span> Sign Out
      </button>
    </form>
  </div>
</aside>

<div class="main">

  <div class="topbar">
  <span class="topbar-title">Dashboard</span>
    <div class="search-wrap">
      <span class="search-icon">🔍</span>
      <input type="text" id="liveSearch" placeholder="Search jobs by title or keyword..." value="${search}">
    </div>
    <div class="topbar-right">
      <span class="live-dot">Live</span>
      <div class="badge-count"><strong id="jobCount">${fn:length(posts)}</strong> jobs</div>
    </div>
  </div>

  <div class="content">

    <div class="page-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">

  <!-- LEFT: TITLE + SUBTITLE -->
  <div>
    <h1 style="margin:0;">
      <c:choose>
        <c:when test="${user.role == 'CLIENT'}">
          Your Posted Jobs
        </c:when>
        <c:otherwise>
          Find Your Next Project
        </c:otherwise>
      </c:choose>
    </h1>

    <p style="margin:4px 0 0; color:#6b7280;">
      <c:choose>
        <c:when test="${user.role == 'CLIENT'}">
          Track and manage your jobs
        </c:when>
        <c:otherwise>
          Browse open jobs and apply instantly
        </c:otherwise>
      </c:choose>
    </p>
  </div>

  <!-- RIGHT: FILTERS -->
  <c:if test="${user.role == 'CLIENT'}">
  <c:set var="currentFilter" value="${requestScope.currentFilter}" />

  <div style="display:flex; gap:10px; flex-wrap:wrap;">

    <a href="PostServlet?action=home"
       class="btn-filter ${currentFilter == null ? 'active' : ''}">
      All
    </a>

    <a href="PostServlet?action=home&status=OPEN"
       class="btn-filter ${currentFilter == 'OPEN' ? 'active' : ''}">
      🟢 Open
    </a>

    <a href="PostServlet?action=home&status=IN_PROGRESS"
       class="btn-filter ${currentFilter == 'IN_PROGRESS' ? 'active' : ''}">
      🔄 In Progress
    </a>

    <a href="PostServlet?action=home&status=CLOSED"
       class="btn-filter ${currentFilter == 'CLOSED' ? 'active' : ''}">
      ✅ Completed
    </a>

  </div>
  </c:if>

</div>

    <c:if test="${user.role == 'FREELANCER'}">
    <div class="filter-row">
      <div class="filter-label">Budget Range</div>
      <div class="slider-wrap">
        <div class="slider-header">
          <span class="filter-label">Min</span>
          <span class="slider-val" id="sliderVal">$<span id="minVal">${minBudget}</span></span>
        </div>
        <input type="range" id="budgetSlider"
               min="${minBudget}" max="${maxBudget}"
               value="${minBudget}" step="50">
      </div>
      <div class="filter-sep"></div>
      <div class="filter-label" id="maxLabel">Max: $${maxBudget}</div>
    </div>
    </c:if>

    <div class="jobs-grid" id="jobsGrid">

    <c:forEach var="p" items="${posts}">
      <c:set var="acceptedApp" value="${acceptedMap[p.postId]}" />

      <div class="job-card"
           data-title="${fn:toLowerCase(p.title)}"
           data-desc="${fn:toLowerCase(p.description)}"
           data-budget="${p.budget}">

        <div class="card-top">
          <div class="card-title">${p.title}</div>
          <span class="status-pill 
			  ${p.status.toString() == 'OPEN' ? 's-open' :
			      p.status.toString() == 'IN_PROGRESS' ? 's-progress' :
			      's-closed'}">
			
			  <c:choose>
			    <c:when test="${p.status.toString() == 'CLOSED'}">
			      ✅ Completed
			    </c:when>
			    <c:when test="${p.status.toString() == 'IN_PROGRESS'}">
			      🔄 In Progress
			    </c:when>
			    <c:otherwise>
			      🟢 Open
			    </c:otherwise>
			  </c:choose>
			
		</span>
        </div>

        <div class="card-desc">${p.description}</div>

        <c:if test="${acceptedApp != null}">
          <div class="assigned">
            👤 Assigned to:   
            <strong class="nameassigned">${acceptedApp.freelancer.username}</strong>

            <c:if test="${ratingsMap != null}">
              <c:set var="r" value="${ratingsMap[acceptedApp.freelancer.userId]}" />
              <c:if test="${r != null and r > 0}">
                <span style="color:#f59e0b; margin-left:6px;font-weight: bolder;">
                  ⭐ ${r}
                </span>
              </c:if>
            </c:if>

          </div>
        </c:if>

        <div class="card-footer">
		  <span class="budget">$${p.budget}</span>

		  <!-- ================= CLIENT ================= -->
		  <c:if test="${user.role == 'CLIENT'}">

		    <c:if test="${p.status.toString() == 'OPEN'}">
			  <c:set var="count" value="${pendingCounts != null and pendingCounts[p.postId] != null ? pendingCounts[p.postId] : 0}" />
			  
			  <a href="ApplicationServlet?action=view&postId=${p.postId}" class="view-btn">
			    View Proposals <c:if test="${count > 0}">(${count})</c:if>
			  </a>
			</c:if>

		    <c:if test="${p.status.toString() == 'IN_PROGRESS'}">

			  <form action="PostServlet" method="post" style="display:inline;">
			    <input type="hidden" name="action" value="complete">
			    <input type="hidden" name="postId" value="${p.postId}">
			    <button type="submit" class="apply-btn">Mark as Completed</button>
			  </form>

			  <form action="PostServlet" method="post" style="display:inline; margin-left:6px;">
			    <input type="hidden" name="action" value="withdraw">
			    <input type="hidden" name="postId" value="${p.postId}">
			    <button type="button" class="btn-reject"
				  onclick="openWithdraw(${p.postId})">
				  Withdraw
				</button>
			  </form>

			</c:if>

			<%-- Rating button for completed jobs --%>
			<c:if test="${p.status.toString() == 'CLOSED' and acceptedApp != null and acceptedApp.rating == null}">
			  <button type="button" class="apply-btn" style="margin-left:6px;"
			    onclick="openRating(${acceptedApp.applicationId}, ${p.postId})">
			    ⭐ Rate Freelancer
			  </button>
			</c:if>

		  </c:if>

		  <!-- ================= FREELANCER ================= -->
		  <c:if test="${user.role == 'FREELANCER'}">

			  <c:if test="${p.status.toString() == 'OPEN'}">

			    <c:set var="alreadyApplied" value="${appliedPostIds != null and appliedPostIds.contains(p.postId)}" />

			    <c:choose>
			      <c:when test="${alreadyApplied}">
			        <span style="color:#6b7280; font-size:13px; font-weight:500;">
			          ✔ Already Applied
			        </span>
			      </c:when>

			      <c:otherwise>
			        <form action="ApplicationServlet" method="post" style="display:inline;">
			          <input type="hidden" name="action" value="apply">
			          <input type="hidden" name="postId" value="${p.postId}">
			          <button type="submit" class="apply-btn">Apply Now</button>
			        </form>
			      </c:otherwise>
			    </c:choose>

			  </c:if>

			</c:if>

		</div>
      </div>

    </c:forEach>
    </div>

    <div class="empty" id="emptyState" style="display:none">
      <div class="empty-icon">📭</div>
      <h3>No jobs match your filters</h3>
      <p>Try adjusting your search or budget range</p>
    </div>

  </div>
</div>

<div class="overlay" id="applyOverlay">
  <div class="popup-box">
    <h3>Apply to this job?</h3>
    <p id="popupJobTitle" style="color:#1e293b;font-weight:600;margin-bottom:.3rem;"></p>
    <p>Your application will be sent to the client for review.</p>
    <form method="post" action="ApplicationServlet">
      <input type="hidden" name="action" value="apply">
      <input type="hidden" name="postId" id="applyPostId">
      <div class="popup-actions">
        <button type="submit" class="btn-confirm">Yes, Apply</button>
        <button type="button" class="btn-cancel" onclick="closeApply()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<div class="overlay" id="withdrawOverlay">
  <div class="popup-box">
    <h3>Withdraw this job?</h3>
    <p>This will reopen the job and reject all proposals.</p>

    <form method="post" action="PostServlet">
      <input type="hidden" name="action" value="withdraw">
      <input type="hidden" name="postId" id="withdrawPostId">

      <div class="popup-actions">
        <button type="submit" class="btn-confirm">Yes, Withdraw</button>
        <button type="button" class="btn-cancel" onclick="closeWithdraw()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<!-- RATING POPUP -->
<div class="overlay" id="ratingOverlay">
  <div class="popup-box">
    <h3>Rate Freelancer</h3>
    <p>How would you rate this freelancer's work?</p>

    <form method="post" action="ApplicationServlet">
      <input type="hidden" name="action" value="rate">
      <input type="hidden" name="applicationId" id="ratingAppId">
      <input type="hidden" name="postId" id="ratingPostId">
      
      <div class="rating-stars" id="ratingStars">
        <span class="star" data-value="1">☆</span>
        <span class="star" data-value="2">☆</span>
        <span class="star" data-value="3">☆</span>
        <span class="star" data-value="4">☆</span>
        <span class="star" data-value="5">☆</span>
      </div>
      <input type="hidden" name="rating" id="ratingValue" required>

      <div class="popup-actions">
        <button type="submit" class="btn-confirm-accept" id="submitRating" disabled>Submit Rating</button>
        <button type="button" class="btn-cancel" onclick="closeRating()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<c:if test="${msg == 'applied'}">
<div class="toast success"><span class="dot">●</span> Application sent successfully!</div>
</c:if>

<c:if test="${msg == 'alreadyApplied'}">
<div class="toast info"><span class="dot">●</span> You already applied to this job.</div>
</c:if>

<!-- Floating Robot Button -->
<button id="chatToggleBtn">🤖</button>

<!-- Chatbox -->
<div id="chatbox">
  <div id="chatHeader">
    <div class="chat-header-content">
      <div class="chat-avatar">🤖</div>
      <div class="chat-title-area">
        <h4>HireFlow Assistant</h4>
        <div class="chat-status">
          <span class="status-dot"></span>
          <span>Online</span>
        </div>
      </div>
    </div>
    <button id="closeChat">✕</button>
  </div>

  <div id="messages"></div>
  
  <div id="chatSuggestions"></div>

  <div id="chatInputArea">
    <input type="text" id="userInput" placeholder="Type your message..." onkeypress="if(event.key==='Enter') sendMessage()" />
    <button onclick="sendMessage()">➤</button>
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
</c:if>

<script>
  const USER_ROLE = "${user.role}";
</script>

<script src='js/home.js'></script>
</body>
</html>