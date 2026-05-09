
// ================= ACCEPT / REJECT =================
function openPopup(action, appId, postId) {
  const actionInput = document.getElementById('actionInput');
  if (actionInput) actionInput.value = action;

  document.getElementById('appId').value = appId;
  document.getElementById('postId').value = postId;

  if (action === 'accept') {
    document.getElementById('popupTitle').textContent = 'Accept this freelancer?';
    document.getElementById('popupText').textContent = 'All other applicants will be rejected.';
    document.getElementById('confirmBtn').className = 'btn-confirm-accept';
    document.getElementById('confirmBtn').textContent = 'Yes, Accept';
  } else {
    document.getElementById('popupTitle').textContent = 'Reject this applicant?';
    document.getElementById('popupText').textContent = 'This action cannot be undone.';
    document.getElementById('confirmBtn').className = 'btn-confirm-reject';
    document.getElementById('confirmBtn').textContent = 'Yes, Reject';
  }

  document.getElementById('overlay').classList.add('open');
}

function closePopup() {
  document.getElementById('overlay').classList.remove('open');
}

// ================= RATING SYSTEM =================
function openRating(appId, postId) {
  const overlay = document.getElementById('ratingOverlay');
  const appInput = document.getElementById('ratingAppId');
  const postInput = document.getElementById('ratingPostId');
  const ratingValue = document.getElementById('ratingValue');
  const submitBtn = document.getElementById('submitRating');

  if (appInput) appInput.value = appId;
  if (postInput) postInput.value = postId;
  if (overlay) {
    overlay.style.display = 'flex';
    overlay.classList.add('open');
  }

  // Reset stars
  const stars = document.querySelectorAll('.star');
  stars.forEach(star => {
    star.textContent = '☆';
    star.classList.remove('active');
  });

  if (ratingValue) ratingValue.value = '';
  if (submitBtn) submitBtn.disabled = true;
}

function closeRating() {
  const overlay = document.getElementById('ratingOverlay');
  if (overlay) {
    overlay.style.display = 'none';
    overlay.classList.remove('open');
  }
}

// ================= STAR RATING INITIALIZATION =================
document.addEventListener('DOMContentLoaded', function () {
  const stars = document.querySelectorAll('.star');
  const ratingValue = document.getElementById('ratingValue');
  const submitBtn = document.getElementById('submitRating');
  const ratingOverlay = document.getElementById('ratingOverlay');

  if (stars.length === 0) return;

  stars.forEach((star, index) => {

    // Click handler
    star.addEventListener('click', function () {
      const value = index + 1;

      if (ratingValue) ratingValue.value = value;
      if (submitBtn) submitBtn.disabled = false;

      stars.forEach((s, i) => {
        if (i < value) {
          s.textContent = '★';
          s.classList.add('active');
        } else {
          s.textContent = '☆';
          s.classList.remove('active');
        }
      });
    });

    // Hover effect
    star.addEventListener('mouseenter', function () {
      const value = index + 1;
      stars.forEach((s, i) => {
        s.textContent = i < value ? '★' : '☆';
      });
    });
  });

  // Mouse leave - restore selected rating
  const ratingStars = document.getElementById('ratingStars');
  if (ratingStars) {
    ratingStars.addEventListener('mouseleave', function () {
      const current = ratingValue ? parseInt(ratingValue.value) || 0 : 0;

      stars.forEach((s, i) => {
        if (i < current) {
          s.textContent = '★';
          s.classList.add('active');
        } else {
          s.textContent = '☆';
          s.classList.remove('active');
        }
      });
    });
  }

  // Click outside overlay to close
  if (ratingOverlay) {
    ratingOverlay.addEventListener('click', function (e) {
      if (e.target === ratingOverlay) {
        closeRating();
      }
    });
  }
});

// ================= AI SUMMARY =================
function getAISummary(appId, bio, btn) {
  const container = document.getElementById('summaryContainer_' + appId);
  const list = document.getElementById('summaryList_' + appId);
  const btnText = document.getElementById('btnText_' + appId);
  const btnIcon = document.getElementById('btnIcon_' + appId);
  const bioText = document.getElementById('bioText_' + appId);

  // If programmatically called and already summarized, skip
  if (!btn && container.style.display === 'block') return;

  if (container.style.display === 'block') {
    container.style.display = 'none';
    if (bioText) bioText.style.display = 'block';
    btnText.innerHTML = 'AI Summary';
    btnIcon.innerHTML = '✨';
    return;
  }

  btnText.innerHTML = btn ? 'Summarizing...' : '🪄 AI...';
  btnIcon.innerHTML = '⌛';
  if (btn) btn.disabled = true;

  const formData = new URLSearchParams();
  formData.append('action', 'summarizeBio');
  formData.append('bio', bio);

  fetch('ChatServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: formData.toString()
  })
    .then(r => r.text())
    .then(summary => {
      list.innerHTML = '';
      const lines = summary.split('\n');
      lines.forEach(line => {
        if (line.trim()) {
          const li = document.createElement('li');
          li.textContent = line.replace(/^[•\-\*⚡]\s*/, '').trim();
          list.appendChild(li);
        }
      });
      container.style.display = 'block';
      if (bioText) bioText.style.display = 'none'; // Hide the long bio and show summary
      btnText.innerHTML = 'Show Original';
      btnIcon.innerHTML = '📖';
      if (btn) btn.disabled = false;
    })
    .catch(err => {
      console.error(err);
      btnText.innerHTML = 'Error';
      btnIcon.innerHTML = '❌';
      if (btn) btn.disabled = false;
    });
}

// Auto-summarize on load
document.addEventListener('DOMContentLoaded', function () {
  const cards = document.querySelectorAll('.app-card');
  cards.forEach((card, index) => {
    const btn = card.querySelector('button[onclick^="getAISummary"]');
    if (btn) {
      // Delay slightly to avoid hitting rate limits too fast
      setTimeout(() => {
        btn.click();
      }, index * 800);
    }
  });
});

// ================= EMAIL POPUP =================
function savePopupEmail(userEmail, userName, userAddress) {
  const email = document.getElementById('popupEmail').value;
  const errorDiv = document.getElementById('emailError');

  if (!email || !email.includes('@')) {
    errorDiv.textContent = 'Please enter a valid email address.';
    errorDiv.style.display = 'block';
    return;
  }

  const formData = new URLSearchParams();
  formData.append('action', 'update');
  formData.append('name', userName);
  formData.append('address', userAddress);
  formData.append('email', email);

  fetch('SettingsServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: formData.toString()
  })
    .then(response => {
      if (response.redirected) {
        const url = new URL(response.url);
        if (url.searchParams.get('msg') === 'success') {
          location.reload();
        } else {
          errorDiv.textContent = 'This email is already taken or invalid. Please try another.';
          errorDiv.style.display = 'block';
        }
      }
    })
    .catch(err => {
      errorDiv.textContent = 'Connection error. Please try again.';
      errorDiv.style.display = 'block';
    });
}
