function login(e) {
    // OPTIONAL: keep validation only
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    if (!username || !password) {
        e.preventDefault();
        alert("Please fill all fields");
    }
}