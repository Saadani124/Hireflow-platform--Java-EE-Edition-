function register(e) {
  const username = document.getElementById("username").value.trim();
  const password = document.getElementById("password").value.trim();
  const name = document.getElementById("name").value.trim();
  const role = document.getElementById("role").value;

  const errorBox = document.getElementById("errorBox");

  errorBox.style.display = "none";

  if (!username || !password || !name || !role) {
    e.preventDefault();
    errorBox.style.display = "block";
    errorBox.textContent = "All fields are required";
  }
}