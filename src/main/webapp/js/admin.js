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

function openEditModal(userJson) {
  const user = JSON.parse(userJson);
  fillEditModal(user);
}

function openEditModalFromData(btn) {
  const user = {
    userId: btn.getAttribute('data-userid'),
    name: btn.getAttribute('data-name'),
    email: btn.getAttribute('data-email'),
    address: btn.getAttribute('data-address'),
    role: btn.getAttribute('data-role'),
    bio: btn.getAttribute('data-bio'),
    skills: btn.getAttribute('data-skills')
  };
  fillEditModal(user);
}

function fillEditModal(user) {
  document.getElementById('editUserId').value = user.userId;
  document.getElementById('editName').value = user.name || '';
  document.getElementById('editEmail').value = user.email || '';
  document.getElementById('editAddress').value = user.address || '';
  document.getElementById('editRole').value = user.role;
  document.getElementById('editBio').value = user.bio || '';
  document.getElementById('editSkills').value = user.skills || '';
  
  toggleEditRoleFields(user.role);
  document.getElementById('editModalOverlay').style.display = 'flex';
}

function closeEditModal() {
  document.getElementById('editModalOverlay').style.display = 'none';
}

function toggleEditRoleFields(role) {
  const freelancerFields = document.getElementById('freelancerOnlyFields');
  if (role === 'FREELANCER') {
    freelancerFields.style.display = 'block';
  } else {
    freelancerFields.style.display = 'none';
  }
}
