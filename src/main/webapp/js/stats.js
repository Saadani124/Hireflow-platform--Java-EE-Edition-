
document.addEventListener('DOMContentLoaded', function() {
    // Client Chart
    const clientCtx = document.getElementById('clientChart');
    if (clientCtx) {
        const open = clientCtx.getAttribute('data-open');
        const progress = clientCtx.getAttribute('data-progress');
        const completed = clientCtx.getAttribute('data-completed');
        
        new Chart(clientCtx.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Open', 'In Progress', 'Completed'],
                datasets: [{
                    data: [open, progress, completed],
                    backgroundColor: ['#22c55e', '#f59e0b', '#64748b'],
                    borderWidth: 0
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'bottom' }
                },
                cutout: '70%'
            }
        });
    }

    // Freelancer Chart
    const freelancerCtx = document.getElementById('freelancerChart');
    if (freelancerCtx) {
        const pending = freelancerCtx.getAttribute('data-pending');
        const accepted = freelancerCtx.getAttribute('data-accepted');
        const rejected = freelancerCtx.getAttribute('data-rejected');
        
        new Chart(freelancerCtx.getContext('2d'), {
            type: 'pie',
            data: {
                labels: ['Pending', 'Accepted', 'Rejected'],
                datasets: [{
                    data: [pending, accepted, rejected],
                    backgroundColor: ['#f59e0b', '#22c55e', '#ef4444'],
                    borderWidth: 0
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    }
});

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
