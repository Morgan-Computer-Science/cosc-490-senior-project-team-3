// password validation
/*
    point-based strength system:
    1pt - Capital Letter
    1pt - 8 characters or greater (required)
    1pt - Symbol used (!@#$%_)
    1pt - Number used (0-9)
*/
function update_strength(password) {
    // regex expressions
    const symbols = /[!@#$%^&*()_\-\+\={\[}\]\|\\:;"'<,>.?/]/;
    const numbers = /[0-9]/;

    const colors = ['#e3172b', '#e36e0e', '#d8e30e', '#14d92b', '#14d92b'];
    const phrases = ['weak', 'weak', 'okay', 'strong', 'strong'];

    let points = 0;

    if (password.length >= 15) {
        points += 2;
    } else if (password.length >= 8) {
        points++;
    }

    if (password != password.toUpperCase()) {
        points++;
    }

    if (password.match(symbols)) {
        points++;
    }

    if (password.match(numbers)) {
        points++;
    }

    if (password.length < 8) {
        points = 1;
    }

    const text = document.getElementById('strength-text');
    const bars = document.getElementsByClassName('strength-bar');

    text.innerHTML = phrases[points - 1];
    text.style.color = colors[points - 1];

    for (let i = 0; i < points; i++) {
        bars[i].style = 'background-color: ' + colors[points - 1];
    }

    for (let i = points; i < bars.length; i++) {
        bars[i].style = 'background-color: #303030;';
    }

    return points;
}

const password_input = document.getElementById('password');

function valid_password() {
    const strength_frame = document.getElementById('strength-frame');

    document.getElementById('password-invalid').style.display = 'none';

    if (password_input.value != '') {
        strength_frame.style.display = 'block';
    } else {
        strength_frame.style.display = 'none';
    }

    const points = update_strength(password_input.value);

    return points >= 3;
}

password_input.addEventListener('input', valid_password);

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

// password confirm
const confirm_input = document.getElementById('confirm');

function password_match() {
    const invalid_match = document.getElementById('password-invalid');

    if (password_input.value == confirm_input.value) {
        invalid_match.style.display = 'none';

        return true
    }

    invalid_match.style.display = 'block';

    return false;
}

confirm_input.addEventListener('input', password_match)

// name length check
const first_input = document.getElementById('first_name');
const invalid_first = document.getElementById('first_invalid');

const expr = /[A-Za-z]+/

function valid_first() {
    const first_name = first_input.value;

    if (first_name.length < 3 || first_name.match(expr) != first_name) {
        invalid_first.style.display = 'block';

        return false;
    }

    invalid_first.style.display = 'none';

    return true;
}

first_input.addEventListener('input', valid_first);

const last_input = document.getElementById('last_name');
const invalid_last = document.getElementById('last_invalid');

function valid_last() {
    const last_name = last_input.value;

    if (last_name.length < 3 || last_name.match(expr) != last_name) {
        invalid_last.style.display = 'block';

        return false;
    }

    invalid_last.style.display = 'none';

    return true;
}

last_input.addEventListener('input', valid_last);

// signup request
const submit_button = document.getElementById('submit-button');
const form = document.getElementsByClassName('form')[0];

form.addEventListener('submit', (event) => {
    event.preventDefault();

    // validate fields
    if (!valid_password() || !valid_email() || !password_match() || !valid_first() || !valid_last()) {
        return; 
    }

    console.log('submission accepted');

    form.submit();
})