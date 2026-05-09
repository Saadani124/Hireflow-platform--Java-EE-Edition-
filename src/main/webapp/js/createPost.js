function createPost(e) {

  const title = document.getElementById("title").value;
  const description = document.getElementById("description").value;
  const budget = document.getElementById("budget").value;

  if (!title || !description || !budget) {
    e.preventDefault();
    alert("All fields are required");
  }
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