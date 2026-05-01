async function init() {
    const response = await fetch('/api/v1/user_stats');

    const data = await response.json();

    const user_display = document.getElementById('user-display');
    const initials = document.getElementById('user-initials');

    user_display.textContent = data.first_name + ' ' + data.last_name;

    initials.textContent = data.first_name.charAt(0).toUpperCase() + data.last_name.charAt(0).toUpperCase();
}

init();