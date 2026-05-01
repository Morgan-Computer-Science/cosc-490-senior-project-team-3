// email validation
const email_input = document.getElementById('email');

function valid_email() {
    const invalid_text = document.getElementById('email-invalid');

    const email = email_input.value.trim();
    const expr = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    if (email.match(expr)) {
        invalid_text.style.display = 'none';

        return true;
    }

    invalid_text.style.display = 'block';

    return false;
}

email_input.addEventListener('input', valid_email);

const password_input = document.getElementById('password');

function valid_password() {
    const invalid_password = document.getElementById('password-invalid');

    if (password_input.value.length < 1) {
        invalid_password.style.display = 'block';

        return false;
    }

    invalid_password.style.display = 'none';

    return true;
}

const form = document.getElementsByClassName('form')[0];

form.addEventListener('submit', (event) => {
    event.preventDefault();

    if (!valid_email() || !valid_password()) {
        return;
    }

    form.submit();
})
