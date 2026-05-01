const tween_styles = {
    Linear: {
        In: (x) => x,
        Out: (x) => x
    },
    Quadratic: {
        In: (x) => x * x,
        Out: (x) => x * (2 - x)
    },
    Cubic: {
        In: (x) => x * x * x,
        Out: (x) => (x - 1) ** 3 + 1
    },
    Quartic: {
        In: (x) => x ** 4,
        Out: (x) => 1 - (x - 1) ** 4
    },
    Quintic: {
        In: (x) => x ** 5,
        Out: (x) => (x - 1) ** 5 + 1
    }
}

function tween(element, start, end, options = {}) {
    const {
        property = 'textContent',
        duration = 500,
        decimals = 0,
        format = '%d',
        style = tween_styles.Linear.In
    } = options;

    const start_time = performance.now();
    const difference = end - start;

    function _format(value) {
        // fix decimals
        const fixed = value.toFixed(decimals);

        const formatted = format.replace('%d', fixed);

        return formatted
    }

    function update(t) {
        const time_elapsed = t - start_time;
        const progress = Math.min(time_elapsed / duration, 1);
        const styled = style(progress); 

        const current = start + difference * styled;

        // element.textContent = _format(current);
        element[property] = _format(current);

        if (progress < 1) {
            requestAnimationFrame(update);
        } else { 
            element[property] = _format(end);
        }
    }

    requestAnimationFrame(update);
}

async function load_dash() {
    const degree_percent = document.getElementById('completion-metric');
    const credit_completion = document.getElementById('credit-completion');
    const degree_progress = document.getElementById('completion-bar');

    const gpa_metric = document.getElementById('gpa-metric');

    const credits_metric = document.getElementById('credits-metric');
    const enrolled_term = document.getElementById('enrolled-term');

    const response = await fetch('/api/v1/user_stats');

    const data = await response.json();

    const percentage = Math.floor(data.credits / 120 * 100);

    const DURATION = 2000;
    const STYLE_FUNC = tween_styles.Quartic.Out;

    tween(degree_percent, 0, percentage, {
        duration: DURATION,
        format: '%d%',
        style: STYLE_FUNC
    });

    tween(credit_completion, 0, data.credits, {
        duration: DURATION, 
        format: '%d of 120 credits',
        style: STYLE_FUNC
    });

    degree_progress.style.width = `${percentage}%`;

    tween(gpa_metric, 0, data.gpa[8], {
        duration: DURATION,
        decimals: 2,
        style: STYLE_FUNC
    })

    let enrolled_credits = 0;
    
    for (const row of data.enrolled) {
        enrolled_credits += row.credits
    }

    tween(credits_metric, 0, enrolled_credits, {
        duration: 2000,
        format: '%d CR',
        style: tween_styles.Quartic.Out
    })

    // rendering gpa bar chart
    const chart = document.getElementById('bar-chart');

    for (let i = 1; i < 9; i++) {
        const gpa = data.gpa[i];
        const bar = document.createElement('div');

        bar.classList.add('bar-col');

        bar.innerHTML = `
            <div class="bar"><span class="bar-value">${gpa.toFixed(2)}</span></div>
            <div class="bar-label">S${i}</div>
        `

        tween(bar.querySelector('div'), 0, gpa / 4 * 100, {
            property: 'style',
            duration: 2000,
            format: 'height: %d%;',
            style: STYLE_FUNC
        })

        chart.append(bar);
    }


    // render courses
    const courses = document.getElementById('courses');
    const term = document.getElementById('current-term');

    courses.innerHTML = ''; // clear

    term.textContent = `Spring 2026 · ${data.enrolled.length} enrolled`;

    for (const course of data.enrolled) {
        const course_item = document.createElement('div');

        const [discipline, code] = course.code.split(' ');

        console.log(discipline, code);

        course_item.classList.add('course-item');

        course_item.innerHTML = `
            <div class="course-code">${discipline}<br>${code}</div>
            <div class="course-body">
                <div class="course-name">${course.title}</div>
                <div class="course-meta">
                    <div class="course-meta-item">
                        ${course.credits} Credits
                    </div>
                </div>
            </div>
            ${
                course.grade ? `<span class="pill-sm green">${(course.grade ?? 0).toFixed(1)}</span>` : ''
            }
        `

        courses.append(course_item)
    }
}

load_dash();

async function init() {
    const response = await fetch('/api/v1/user_stats');

    const data = await response.json();

    const greeting = document.getElementById('greeting');

    greeting.innerHTML = `Hi ${data.first_name} <span class="muted">— here's where you stand.</span>`;

    const user_display = document.getElementById('user-display');
    const initials = document.getElementById('user-initials');

    user_display.textContent = data.first_name + ' ' + data.last_name;

    initials.textContent = data.first_name.charAt(0).toUpperCase() + data.last_name.charAt(0).toUpperCase();
}

init();