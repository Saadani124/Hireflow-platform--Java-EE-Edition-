document.addEventListener("DOMContentLoaded", () => {

  // ================= CHATBOT TOGGLE =================
  const chatToggleBtn = document.getElementById('chatToggleBtn');
  const chatbox = document.getElementById('chatbox');
  const closeChat = document.getElementById('closeChat');
  const messages = document.getElementById("messages");

  let chatInitialized = false;

  // OPEN CHAT
  chatToggleBtn.addEventListener('click', () => {
    chatbox.classList.add('active');

    // smooth hide button
    chatToggleBtn.style.opacity = '0';
    setTimeout(() => {
      chatToggleBtn.style.display = 'none';
    }, 200);

    // ✅ KEEP YOUR PART (unchanged)
    if (!chatInitialized && messages) {
      messages.innerHTML = `
        <div class="message ai">
          <div class="bubble">
            Hello! I'm your HireFlow assistant 🤖<br>
            You can click below or ask me anything 👇
          </div>
        </div>
      `;
      chatInitialized = true;
    }
  });

  // CLOSE CHAT
  closeChat.addEventListener('click', () => {
    chatbox.classList.remove('active');

    // show button smoothly again
    chatToggleBtn.style.display = 'flex';

    setTimeout(() => {
      chatToggleBtn.style.opacity = '1';
    }, 10);
  });

  // ================= SEARCH + FILTER =================
  const searchInput = document.getElementById('liveSearch');
  const budgetSlider = document.getElementById('budgetSlider');
  const minVal = document.getElementById('minVal');
  const jobCount = document.getElementById('jobCount');
  const emptyState = document.getElementById('emptyState');
  const cards = document.querySelectorAll('.job-card');

  function filterCards() {
    const q = searchInput ? searchInput.value.toLowerCase() : '';
    const minB = budgetSlider ? parseInt(budgetSlider.value) : 0;
    let visible = 0;

    cards.forEach(c => {
      const title = (c.dataset.title || '').toLowerCase();
      const desc = (c.dataset.desc || '').toLowerCase();
      const budget = parseInt(c.dataset.budget || '0');

      const matchSearch = !q || title.includes(q) || desc.includes(q);
      const matchBudget = budget >= minB;

      if (matchSearch && matchBudget) {
        c.style.display = '';
        visible++;
      } else {
        c.style.display = 'none';
      }
    });

    if (jobCount) jobCount.textContent = visible;
    if (emptyState) {
      emptyState.style.display = visible === 0 ? 'block' : 'none';
    }
  }

  if (searchInput) searchInput.addEventListener('input', filterCards);

  if (budgetSlider) {
    budgetSlider.addEventListener('input', () => {
      if (minVal) minVal.textContent = budgetSlider.value;
      filterCards();
    });
  }

  // ================= APPLY POPUP =================
  window.openApply = function(id, title) {
    const applyIdInput = document.getElementById('applyPostId');
    const popupTitle = document.getElementById('popupJobTitle');
    const overlay = document.getElementById('applyOverlay');

    if (applyIdInput) applyIdInput.value = id;
    if (popupTitle) popupTitle.textContent = title;
    if (overlay) overlay.classList.add('open');
  };

  window.closeApply = function() {
    const overlay = document.getElementById('applyOverlay');
    if (overlay) overlay.classList.remove('open');
  };

  // ================= WITHDRAW POPUP =================
  window.openWithdraw = function(postId) {
    const input = document.getElementById("withdrawPostId");
    const overlay = document.getElementById("withdrawOverlay");

    if (input) input.value = postId;
    if (overlay) overlay.classList.add("open");
  };

  window.closeWithdraw = function() {
    const overlay = document.getElementById("withdrawOverlay");
    if (overlay) overlay.classList.remove("open");
  };

  const withdrawOverlay = document.getElementById('withdrawOverlay');
  if (withdrawOverlay) {
    withdrawOverlay.addEventListener('click', e => {
      if (e.target === withdrawOverlay) window.closeWithdraw();
    });
  }

  // ================= RATING POPUP =================
  window.openRating = function(appId, postId) {
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
  };

  window.closeRating = function() {
    const overlay = document.getElementById('ratingOverlay');
    if (overlay) {
      overlay.style.display = 'none';
      overlay.classList.remove('open');
    }
  };

  // ================= OVERLAY CLICK HANDLERS =================
  const applyOverlay = document.getElementById('applyOverlay');
  if (applyOverlay) {
    applyOverlay.addEventListener('click', e => {
      if (e.target === applyOverlay) window.closeApply();
    });
  }

  const ratingOverlay = document.getElementById('ratingOverlay');
  if (ratingOverlay) {
    ratingOverlay.addEventListener('click', e => {
      if (e.target === ratingOverlay) window.closeRating();
    });
  }

  // ================= STAR RATING SYSTEM =================
  const stars = document.querySelectorAll('.star');
  const ratingValue = document.getElementById('ratingValue');
  const submitBtn = document.getElementById('submitRating');

  if (stars.length > 0) {
    stars.forEach((star, index) => {

      // Click handler
      star.addEventListener('click', function() {
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
      star.addEventListener('mouseenter', function() {
        const value = index + 1;
        stars.forEach((s, i) => {
          s.textContent = i < value ? '★' : '☆';
        });
      });
    });

    // Mouse leave - restore selected rating
    const ratingStars = document.getElementById('ratingStars');
    if (ratingStars) {
      ratingStars.addEventListener('mouseleave', function() {
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
  }

  const suggestions = document.getElementById("chatSuggestions");

  if (suggestions) {

    let buttons = [];

    if (USER_ROLE === "CLIENT") {
      buttons = [
        { text: "⭐ Best Freelancer", value: "best freelancer" },
        { text: "📋 List Applicants", value: "list applicants" },
        { text: "❓ How to hire", value: "how to apply" }
      ];
    } 
    else if (USER_ROLE === "FREELANCER") {
      buttons = [
        { text: "📄 My Applications", value: "list applicants" },
        { text: "❓ How to apply", value: "how to apply" },
        { text: "⭐ How ratings work", value: "how to rate" }
      ];
    }

    buttons.forEach(b => {
      const btn = document.createElement("button");
      btn.textContent = b.text;

      btn.onclick = function () {
        quickAsk(btn, b.value);
      };

      suggestions.appendChild(btn);
    });
  }
  
  
});

function sendMessage() {
  const input = document.getElementById("userInput");
  const msg = input.value.trim();

  if (!msg) return;

  const messages = document.getElementById("messages");

  // ================= USER MESSAGE =================
  messages.innerHTML += `
    <div class="message user">
      <div class="bubble">
        ${msg}
        <div class="time">${getTime()}</div>
      </div>
    </div>
  `;

  input.value = "";
  messages.scrollTop = messages.scrollHeight;

  // ================= FETCH =================
  fetch("ChatServlet", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "message=" + encodeURIComponent(msg)
  })
  .then(res => res.text())
  .then(reply => {

    // ================= CREATE AI BUBBLE =================
    const aiId = "ai-" + Date.now();

    messages.innerHTML += `
      <div class="message ai">
        <div class="bubble">
          <span id="${aiId}"></span>
          <div class="time">${getTime()}</div>
        </div>
      </div>
    `;

    const contentEl = document.getElementById(aiId);

    // ================= CLEAN TEXT =================
    let text = reply
      .replace(/\*\*/g, "")
      .replace(/<br\s*\/?>/gi, "\n")
      .replace(/[\u00A0\u200B]/g, "")
      .replace(/^\s+/, "");

    let i = 0;

    // skip any invisible leading chars
    while (i < text.length && /\s/.test(text[i])) {
      i++;
    }

    // ================= STREAMING =================
    function typeEffect() {
      if (i < text.length) {
        contentEl.textContent += text[i];
        i++;
        messages.scrollTop = messages.scrollHeight;
        setTimeout(typeEffect, 10); // speed control
      }
    }

    typeEffect();
  })
  .catch(err => {
    console.error(err);

    messages.innerHTML += `
      <div class="message ai">
        <div class="bubble">Error occurred</div>
      </div>
    `;
  });
}

function quickAsk(btn, text) {
  const input = document.getElementById("userInput");

  input.value = text;
  sendMessage();

  //Hide ONLY the clicked button
  // smooth fade
    btn.style.opacity = "0";
    btn.style.transform = "scale(0.8)";

    setTimeout(() => {
      btn.style.display = "none";
    }, 200);

}

function getTime() {
  const now = new Date();
  const h = now.getHours().toString().padStart(2, '0');
  const m = now.getMinutes().toString().padStart(2, '0');
  return h + ":" + m;
}

function formatAIResponse(raw) {

  // clean AI junk
  let text = raw
    .replace(/\*\*/g, "")
    .replace(/<br\s*\/?>/gi, "\n")
    .trim();

  const lines = text.split("\n");

  let html = "";
  let currentList = false;

  lines.forEach(line => {
    line = line.trim();

    if (!line) return;

    // SECTION TITLES
    if (line.toLowerCase().includes("jobs")) {
      if (currentList) {
        html += "</ul>";
        currentList = false;
      }
      html += `<div class="section-title">💼 Jobs</div>`;
    }

    else if (line.toLowerCase().includes("freelancers")) {
      if (currentList) {
        html += "</ul>";
        currentList = false;
      }
      html += `<div class="section-title">👤 Freelancers</div>`;
    }

    // LIST ITEMS
    else if (line.startsWith("-")) {
      if (!currentList) {
        html += "<ul class='ai-list'>";
        currentList = true;
      }

      const clean = line.replace("-", "").trim();
      html += `<li>${clean}</li>`;
    }

    // NORMAL TEXT
    else {
      if (currentList) {
        html += "</ul>";
        currentList = false;
      }
      html += `<div class="ai-text">${line}</div>`;
    }
  });

  if (currentList) html += "</ul>";

  return html;
}

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