<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

      <c:set var="user" value="${sessionScope.activeUser}" />
      <c:if test="${user == null}">
        <c:redirect url="login.jsp" />
      </c:if>

      <c:set var="post" value="${requestScope.post}" />
      <c:set var="applications" value="${requestScope.applications}" />
      <c:if test="${applications == null}">
        <c:set var="applications" value="${emptyList}" />
      </c:if>

      <c:set var="isLocked" value="${post != null and post.status.toString() == 'IN_PROGRESS'}" />

      <!-- counters -->
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
        <title>Proposals — HireFlow</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap"
          rel="stylesheet">
        <link rel="stylesheet" href="style/applicationsstyle.css">
        <style>
          @keyframes fadeIn {
            from {
              opacity: 0;
              transform: translateY(-5px);
            }

            to {
              opacity: 1;
              transform: translateY(0);
            }
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
              <a href="AdminServlet?action=dashboard" class="nav-item">
                <span class="icon">🛡️</span> Admin
              </a>
            </c:if>
            <c:if test="${user.role != 'ADMIN'}">
              <a href="PostServlet?action=home" class="nav-item active"><span class="icon">🏠</span> Dashboard</a>
              <a href="createPost.jsp" class="nav-item"><span class="icon">➕</span> Post Job</a>
              <a href="stats.jsp" class="nav-item"><span class="icon">📊</span> Statistics</a>
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
            <a href="PostServlet?action=home" class="back-btn">← Back to Jobs</a>
            <span class="topbar-title"> Proposals for "${post != null ? post.title : ""}"</span>
          </div>

          <div class="content">

            <c:if test="${param.msg == 'updated'}">
              <div style="margin-bottom:15px; padding:10px; background:#d1fae5; color:#065f46; border-radius:6px;">
                Application updated successfully
              </div>
            </c:if>

            <c:if test="${post != null}">
              <div class="post-header">
                <h1>${post.title}</h1>
                <div class="post-meta">
                  <span class="meta-pill mp-blue">$${post.budget}</span>
                  <span class="meta-pill mp-gray">${post.status}</span>
                  <span class="meta-pill mp-green">${fn:length(applications)} Proposals</span>
                </div>
              </div>
            </c:if>

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

            <c:choose>
              <c:when test="${empty applications}">
                <div class="empty">
                  <div class="empty-icon">📭</div>
                  <h3>No proposals yet</h3>
                  <p>Freelancers haven't applied yet. Check back soon.</p>
                </div>
              </c:when>

              <c:otherwise>
                <div class="apps-grid"
                  style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem;">

                  <c:forEach var="app" items="${applications}">

                    <%--=====PENDING /REJECTED APPLICATIONS (DEFAULT VIEW)=====--%>
                      <c:if test="${app.status.toString() != 'ACCEPTED'}">
                        <div class="app-card"
                          style="background: white; border: 1px solid #e2e8f0; border-radius: 16px; padding: 1.5rem; display: flex; flex-direction: column; gap: 1rem; position: relative; overflow: hidden; transition: all 0.3s ease; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">
                          <div class="app-top" style="display: flex; gap: 1rem; align-items: center;">
                            <div class="app-avatar"
                              style="width: 52px; height: 52px; border-radius: 14px; background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; font-weight: 800; box-shadow: 0 4px 12px rgba(37,99,235,0.2);">
                              ${fn:toUpperCase(fn:substring(app.freelancer.username,0,1))}
                            </div>
                            <div class="app-user">
                              <h3
                                style="margin: 0; font-family: 'Syne', sans-serif; font-size: 1.15rem; color: #1e293b;">
                                ${app.freelancer.username}</h3>
                              <span style="font-size: 0.85rem; color: #64748b; font-weight: 500;">${app.freelancer.name
                                != null ? app.freelancer.name : "Professional Freelancer"}</span>
                            </div>
                          </div>

                          <div class="app-body">
                            <c:if test="${app.freelancer.bio != null}">
                              <div
                                style="background: #f8fafc; padding: 1.2rem; border-radius: 12px; border: 1px solid #e2e8f0; margin-bottom: 1rem; position: relative;">
                                <div
                                  style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                  <span
                                    style="font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em;">Professional
                                    Summary</span>
                                  <button type="button"
                                    onclick="getAISummary('${app.applicationId}', \`${fn:replace(app.freelancer.bio, '`', '\\`')}\`, this)"
                                    style="background: #eff6ff; color: #2563eb; border: 1px solid #dbeafe; padding: 5px 12px; border-radius: 8px; font-size: 10px; font-weight: 700; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 4px;">
                                    <span id="btnIcon_${app.applicationId}">✨</span> <span
                                      id="btnText_${app.applicationId}">AI Summary</span>
                                  </button>
                                </div>

                                <div id="bioText_${app.applicationId}"
                                  style="margin: 0; font-size: 0.9rem; color: #334155; line-height: 1.6;">
                                  <c:set var="hasBullet"
                                    value="${fn:contains(app.freelancer.bio, '•') or fn:contains(app.freelancer.bio, '⚡') or fn:contains(app.freelancer.bio, '-') or fn:contains(app.freelancer.bio, '*')}" />
                                  <c:choose>
                                    <c:when test="${hasBullet}">
                                      <ul style="margin: 0; padding-left: 1.2rem; list-style-type: '• ';">
                                        <c:set var="delim" value="•" />
                                        <c:if test="${fn:contains(app.freelancer.bio, '⚡')}">
                                          <c:set var="delim" value="⚡" />
                                        </c:if>
                                        <c:if
                                          test="${not fn:contains(app.freelancer.bio, '•') and fn:contains(app.freelancer.bio, '-')}">
                                          <c:set var="delim" value="-" />
                                        </c:if>

                                        <c:forEach var="line" items="${fn:split(app.freelancer.bio, delim)}">
                                          <c:if test="${not empty fn:trim(line)}">
                                            <li>${fn:trim(line)}</li>
                                          </c:if>
                                        </c:forEach>
                                      </ul>
                                    </c:when>
                                    <c:otherwise>
                                      <ul style="margin: 0; padding-left: 1.2rem; list-style-type: '• ';">
                                        <c:forEach var="sentence" items="${fn:split(app.freelancer.bio, '.')}">
                                          <c:if test="${not empty fn:trim(sentence)}">
                                            <li>${fn:trim(sentence)}.</li>
                                          </c:if>
                                        </c:forEach>
                                      </ul>
                                    </c:otherwise>
                                  </c:choose>
                                </div>

                                <div id="summaryContainer_${app.applicationId}"
                                  style="display: none; margin-top: 14px; padding-top: 14px; border-top: 1px dashed #cbd5e1; animation: fadeIn 0.3s ease;">
                                  <ul id="summaryList_${app.applicationId}"
                                    style="margin: 0; padding-left: 1.2rem; font-size: 0.88rem; color: #1e293b; line-height: 1.5; list-style-type: '• ';">
                                  </ul>
                                </div>
                              </div>
                            </c:if>

                            <c:if test="${app.freelancer.skills != null}">
                              <div style="margin-bottom: 0.5rem;">
                                <span
                                  style="display: block; font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 10px;">Core
                                  Expertise</span>
                                <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                  <c:forEach var="skill" items="${fn:split(app.freelancer.skills, ',')}">
                                    <span
                                      style="background: #fff; color: #2563eb; padding: 5px 12px; border-radius: 100px; font-size: 11px; font-weight: 700; border: 1px solid #dbeafe; box-shadow: 0 2px 4px rgba(37,99,235,0.05);">
                                      ${fn:trim(skill)}
                                    </span>
                                  </c:forEach>
                                </div>
                              </div>
                            </c:if>
                          </div>

                          <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: 1rem; border-top: 1px solid #f1f5f9;">
                            <span class="status-badge 
              ${app.status.toString() == 'PENDING' ? 'sb-pending' 
                   : app.status.toString() == 'ACCEPTED' ? 'sb-accepted' 
                   : 'sb-rejected'}">
                              ${app.status}
                            </span>

                            <c:if test="${app.status.toString() == 'PENDING' and not isLocked}">
                              <div class="app-actions" style="display: flex; gap: 10px;">
                                <button type="button" class="btn-accept"
                                  style="padding: 10px 20px; font-size: 0.85rem; border-radius: 10px; display: flex; align-items: center; gap: 6px;"
                                  onclick="openPopup('accept', ${app.applicationId}, ${post.postId})">
                                  <span style="font-size: 1rem;">✓</span> Accept
                                </button>

                                <button type="button" class="btn-reject"
                                  style="padding: 10px 20px; font-size: 0.85rem; border-radius: 10px; display: flex; align-items: center; gap: 6px;"
                                  onclick="openPopup('reject', ${app.applicationId}, ${post.postId})">
                                  <span style="font-size: 1rem;">✗</span> Reject
                                </button>
                              </div>
                            </c:if>
                          </div>
                        </div>
                      </c:if>

                      <%--=====ACCEPTED APPLICATION (CLIENT VIEW)=====--%>
                        <c:if test="${user.role == 'CLIENT' and app.status.toString() == 'ACCEPTED'}">
                          <div class="job-card">
                            <div class="card-top">
                              <div class="card-title">
                                ${app.freelancer.username}

                                <c:set var="r" value="${ratingsMap[app.freelancer.userId]}" />

                                <c:if test="${r != null and r > 0}">
                                  <span style="font-size:13px; color:#f59e0b; margin-left:6px;">
                                    ⭐ ${r}
                                  </span>
                                </c:if>

                              </div>
                              <span class="status-pill s-closed">
                                ACCEPTED
                              </span>
                            </div>

                            <div class="card-desc">
                              Applied to: <strong>${app.post.title}</strong>
                            </div>

                            <div class="card-footer">
                              <c:if test="${app.post.status.toString() == 'CLOSED'}">
                                <c:choose>
                                  <c:when test="${app.rating == null}">
                                    <button class="apply-btn"
                                      onclick="openRating(${app.applicationId}, ${post.postId})">
                                      ⭐ Rate Freelancer
                                    </button>
                                  </c:when>
                                  <c:otherwise>
                                    <div style="font-size:16px; color:#f59e0b;">
                                      <c:forEach begin="1" end="${app.rating}">
                                        ⭐
                                      </c:forEach>
                                    </div>
                                  </c:otherwise>
                                </c:choose>
                              </c:if>
                            </div>
                          </div>
                        </c:if>

                  </c:forEach>
                </div>
              </c:otherwise>
            </c:choose>

          </div>
        </div>

        <div class="overlay" id="overlay">
          <div class="popup-box">
            <h3 id="popupTitle">Confirm Action</h3>
            <p id="popupText">Are you sure?</p>
            <form method="post" action="ApplicationServlet">
              <input type="hidden" name="action" id="actionInput">
              <input type="hidden" name="applicationId" id="appId">
              <input type="hidden" name="postId" id="postId">
              <div class="popup-actions">
                <button type="submit" id="confirmBtn" class="btn-confirm-accept">Confirm</button>
                <button type="button" class="btn-cancel" onclick="closePopup()">Cancel</button>
              </div>
            </form>
          </div>
        </div>

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

        <script src="js/applications.js"></script>

        <c:if test="${user.email == null or empty user.email}">
          <div class="overlay open" id="emailOverlay"
            style="display: flex; z-index: 9999; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); align-items: center; justify-content: center;">
            <div class="popup-box"
              style="background: white; padding: 2rem; border-radius: 12px; text-align: center; max-width: 400px; width: 90%;">
              <h3>Welcome to HireFlow!</h3>
              <p style="margin-bottom: 20px; color: #64748b;">Please provide your email address to continue using the
                platform.</p>
              <div id="emailError" style="color: #ef4444; font-size: 13px; margin-bottom: 10px; display: none;"></div>
              <form id="emailForm">
                <div class="field" style="text-align: left; margin-bottom: 20px;">
                  <label
                    style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: #475569; text-transform: uppercase;">Email
                    Address</label>
                  <input type="email" id="popupEmail" name="email" placeholder="e.g. name@example.com" required
                    style="width: 100%; padding: .82rem 1rem; border-radius: 10px; border: 1.5px solid #e2e8f0; outline: none; font-family: inherit;">
                </div>
                <div class="popup-actions">
                  <button type="button" class="btn-confirm"
                    data-email="${fn:escapeXml(user.email)}"
                    data-name="${fn:escapeXml(user.name)}"
                    data-address="${fn:escapeXml(user.address)}"
                    onclick="savePopupEmail(this.getAttribute('data-email'), this.getAttribute('data-name'), this.getAttribute('data-address'))"
                    style="width: 100%; padding: .9rem; background: #2563eb; color: white; border: none; border-radius: 10px; font-weight: 700; cursor: pointer;">Save
                    and Continue</button>
                </div>
              </form>
            </div>
          </div>
        </c:if>

      </body>

      </html>