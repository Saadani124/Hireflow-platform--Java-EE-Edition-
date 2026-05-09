
function openBioModal() {
    document.getElementById('bioModal').style.display = 'flex';
}

function closeBioModal() {
    document.getElementById('bioModal').style.display = 'none';
    document.getElementById('bioQuestions').style.display = 'block';
    document.getElementById('aiLoading').style.display = 'none';
    document.getElementById('genBtn').style.display = 'block';
}

function generateBio() {
    const q1 = document.getElementById('q1').value;
    const q2 = document.getElementById('q2').value;
    const q3 = document.getElementById('q3').value;
    const skillsInput = document.getElementById('skills');
    const skills = skillsInput ? skillsInput.value : "";
    
    if (!q1 || !q2 || !q3) {
        alert("Please answer all questions for a better bio!");
        return;
    }
    
    document.getElementById('bioQuestions').style.display = 'none';
    document.getElementById('aiLoading').style.display = 'block';
    document.getElementById('genBtn').style.display = 'none';
    
    const message = "Expertise: " + q1 + ". Experience: " + q2 + ". Achievement: " + q3;
    const formData = new URLSearchParams();
    formData.append('action', 'generateBio');
    formData.append('message', message);
    formData.append('skills', skills);
    
    fetch('ChatServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
    })
    .then(r => r.text())
    .then(bio => {
        document.getElementById('bio').value = bio;
        closeBioModal();
    })
    .catch(err => {
        alert("AI error. Please try again.");
        closeBioModal();
    });
}
