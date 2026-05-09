<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

      <c:set var="user" value="${sessionScope.activeUser}" />

      <c:if test="${user == null || user.role != 'ADMIN'}">
        <c:redirect url="login.jsp" />
      </c:if>

      <c:set var="usersList" value="${requestScope.usersList}" />
      <c:set var="postsList" value="${requestScope.postsList}" />

      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard — HireFlow</title>
        <link
          href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&family=DM+Sans:wght@300;400;500&display=swap"
          rel="stylesheet">
        <link rel="stylesheet" href="style/homestyle.css">
        <style>
          .admin-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
          }

          .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
          }

          .admin-table th,
          .admin-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
          }

          .admin-table th {
            background-color: #f8fafc;
            font-weight: 600;
            color: #475569;
          }

          .admin-table tr:hover {
            background-color: #f1f5f9;
          }

          .btn-danger {
            background-color: #ef4444;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
          }

          .btn-danger:hover {
            background-color: #dc2626;
          }
        </style>
      </head>

      <body>

        <aside class="sidebar">
          <a href="AdminServlet?action=dashboard" class="sidebar-logo">Hire<span>Flow</span></a>

          <div class="sidebar-user">
            <div class="avatar-circle">${fn:toUpperCase(fn:substring(user.username,0,1))}</div>
            <div class="user-info">
              <div class="uname">${user.name != null ? user.name : user.username}</div>
              <div class="urole">${user.role}</div>
            </div>
          </div>

          <nav class="nav-section">
            <div class="nav-label">Main</div>
            <a href="AdminServlet?action=dashboard" class="nav-item active">
              <span class="icon">🛡️</span> Dashboard
            </a>
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
            <span class="topbar-title">Admin Dashboard</span>
          </div>

          <div class="content">
            <h1>Admin Dashboard</h1>
            <p style="color:#64748b; margin-bottom: 2rem;">Welcome back, ${admin.name != null ? admin.name : admin.username}. Here's what's happening on HireFlow.</p>

            <div class="stats-row" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
              <div class="stat-card" style="background: white; padding: 1.5rem; border-radius: 16px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">
                <div style="font-size: 0.85rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem;">Total Users</div>
                <div style="font-size: 1.8rem; font-weight: 800; color: #1e293b;">${userCount}</div>
              </div>
              <div class="stat-card" style="background: white; padding: 1.5rem; border-radius: 16px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">
                <div style="font-size: 0.85rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem;">Active Jobs</div>
                <div style="font-size: 1.8rem; font-weight: 800; color: #1e293b;">${postCount}</div>
              </div>
              <div class="stat-card" style="background: white; padding: 1.5rem; border-radius: 16px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">
                <div style="font-size: 0.85rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem;">Total Budget</div>
                <div style="font-size: 1.8rem; font-weight: 800; color: #2563eb;">$${totalBudget}</div>
              </div>
              <div class="stat-card" style="background: white; padding: 1.5rem; border-radius: 16px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);">
                <div style="font-size: 0.85rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem;">Actions Logged</div>
                <div style="font-size: 1.8rem; font-weight: 800; color: #1e293b;">${logCount}</div>
              </div>
            </div>

            <div class="admin-section">
              <h2>Platform Users</h2>
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="u" items="${usersList}">
                    <tr>
                      <td>${u.userId}</td>
                      <td>${u.username}</td>
                      <td>${u.name != null ? u.name : "-"}</td>
                      <td>
                        <span class="role-pill" 
                              style="padding: 4px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 700; 
                              background: ${u.role == 'ADMIN' ? '#fef2f2' : u.role == 'CLIENT' ? '#eff6ff' : '#f0fdf4'}; 
                              color: ${u.role == 'ADMIN' ? '#b91c1c' : u.role == 'CLIENT' ? '#1d4ed8' : '#15803d'};">
                          ${u.role}
                        </span>
                      </td>
                      <td>${u.email != null ? u.email : "-"}</td>
                      <td style="display: flex; gap: 8px;">
                        <button type="button" class="btn-edit"
                                data-userid="${u.userId}"
                                data-username="${fn:escapeXml(u.username)}"
                                data-name="${fn:escapeXml(u.name)}"
                                data-email="${fn:escapeXml(u.email)}"
                                data-address="${fn:escapeXml(u.address)}"
                                data-role="${u.role}"
                                data-bio="${fn:escapeXml(u.bio)}"
                                data-skills="${fn:escapeXml(u.skills)}"
                                style="padding: 6px 12px; font-size: 0.75rem; background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; border-radius: 8px; cursor: pointer; font-weight: 600;"
                                onclick="openEditModalFromData(this)">Edit</button>
                        
                        <c:if test="${u.userId != admin.getUserId()}">
                          <form action="AdminServlet" method="post" style="display:inline;"
                            onsubmit="return confirm('Are you sure you want to delete this user?');">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="userId" value="${u.userId}">
                            <button type="submit" class="btn-danger" style="padding: 6px 12px; font-size: 0.75rem;">Delete</button>
                          </form>
                        </c:if>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            <div class="admin-section">
              <h2>Recent Activity Logs</h2>
              <div class="logs-container" style="background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0; max-height: 400px; overflow-y: auto;">
                <table class="admin-table">
                  <thead style="position: sticky; top: 0; z-index: 1;">
                    <tr>
                      <th>Time</th>
                      <th>User</th>
                      <th>Action</th>
                      <th>Details</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="log" items="${recentLogs}">
                      <tr>
                        <td style="font-size: 0.8rem; color: #64748b; white-space: nowrap;">${log.timestamp}</td>
                        <td><strong>${log.username}</strong></td>
                        <td>
                          <span style="font-size: 10px; font-weight: 800; padding: 3px 8px; border-radius: 4px; background: #e2e8f0; color: #475569;">
                            ${log.action}
                          </span>
                        </td>
                        <td style="font-size: 0.85rem; color: #334155;">${log.details}</td>
                      </tr>
                    </c:forEach>
                    <c:if test="${empty recentLogs}">
                      <tr><td colspan="4" style="text-align: center; padding: 2rem; color: #94a3b8;">No activity logged yet.</td></tr>
                    </c:if>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="admin-section">
              <h2>All Job Posts</h2>
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Client</th>
                    <th>Status</th>
                    <th>Budget</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="p" items="${postsList}">
                    <tr>
                      <td>${p.postId}</td>
                      <td>${p.title}</td>
                      <td>${p.client.username}</td>
                      <td>${p.status}</td>
                      <td>$${p.budget}</td>
                      <td>
                        <form action="AdminServlet" method="post" style="display:inline;"
                          onsubmit="return confirm('Are you sure you want to delete this post?');">
                          <input type="hidden" name="action" value="deletePost">
                          <input type="hidden" name="postId" value="${p.postId}">
                          <button type="submit" class="btn-danger">Delete</button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            </div>
          </div>
        </div>

        <!-- EMAIL POPUP -->
        <c:if test="${user.email == null or empty user.email}">
          <div class="overlay open" id="emailOverlay"
            style="display: flex; z-index: 9999; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); align-items: center; justify-content: center;">
            <div class="popup-box"
              style="background: white; padding: 2rem; border-radius: 12px; text-align: center; max-width: 400px; width: 90%;">
              <h3>Welcome back, Admin!</h3>
              <p style="margin-bottom: 20px; color: #64748b;">Please provide your email address to continue.</p>
              <div id="emailError" style="color: #ef4444; font-size: 13px; margin-bottom: 10px; display: none;"></div>
              <form id="emailForm">
                <div class="field" style="text-align: left; margin-bottom: 20px;">
                  <label
                    style="display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: #475569; text-transform: uppercase;">Email
                    Address</label>
                  <input type="email" id="popupEmail" name="email" placeholder="e.g. admin@hireflow.com" required
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

        <!-- EDIT USER MODAL -->
        <div class="overlay" id="editModalOverlay" style="display: none; z-index: 10000; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); align-items: center; justify-content: center;">
          <div class="popup-box" style="background: white; padding: 2rem; border-radius: 16px; text-align: left; max-width: 600px; width: 95%; max-height: 90vh; overflow-y: auto;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
              <h2 style="margin: 0; font-family: 'Syne', sans-serif;">Edit User Details</h2>
              <button onclick="closeEditModal()" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #94a3b8;">×</button>
            </div>
            
            <form action="AdminServlet" method="post">
              <input type="hidden" name="action" value="updateUser">
              <input type="hidden" name="userId" id="editUserId">
              
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                <div class="field">
                  <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">Full Name</label>
                  <input type="text" name="name" id="editName" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0;">
                </div>
                <div class="field">
                  <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">Email</label>
                  <input type="email" name="email" id="editEmail" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0;">
                </div>
              </div>

              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                <div class="field">
                  <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">Address</label>
                  <input type="text" name="address" id="editAddress" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0;">
                </div>
                <div class="field">
                  <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">Role</label>
                  <select name="role" id="editRole" onchange="toggleEditRoleFields(this.value)" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0;">
                    <option value="CLIENT">Client</option>
                    <option value="FREELANCER">Freelancer</option>
                    <option value="ADMIN">Admin</option>
                  </select>
                </div>
              </div>

              <div id="freelancerOnlyFields" style="display: none;">
                <div class="field" style="margin-bottom: 1rem;">
                  <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">Bio</label>
                  <textarea name="bio" id="editBio" rows="3" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0; font-family: inherit;"></textarea>
                </div>
                <div class="field" style="margin-bottom: 1rem;">
                  <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">Skills (comma separated)</label>
                  <input type="text" name="skills" id="editSkills" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0;">
                </div>
              </div>

              <div class="field" style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; margin-bottom: 5px;">New Password (leave blank to keep current)</label>
                <input type="password" name="password" placeholder="••••••••" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #e2e8f0;">
              </div>

              <div style="display: flex; gap: 1rem;">
                <button type="submit" style="flex: 1; padding: 1rem; background: #2563eb; color: white; border: none; border-radius: 10px; font-weight: 700; cursor: pointer;">Save Changes</button>
                <button type="button" onclick="closeEditModal()" style="flex: 1; padding: 1rem; background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; border-radius: 10px; font-weight: 700; cursor: pointer;">Cancel</button>
              </div>
            </form>
          </div>
        </div>

        <script src="js/admin.js?v=<%= System.currentTimeMillis() %>"></script>

      </body>

      </html>