// const terms = [
//   {
//     id: "fa2026",
//     name: "Fall 2026",
//     status: "planned",
//     statusLabel: "Planned",
//     dateRange: "Aug 25 – Dec 18, 2026",
//     credits: 15,
//     courses: [
//       { code: "CS 421", name: "Programming Languages & Compilers", credits: 3, instructor: "Prof. Vasilakis", grade: "PLANNED", gradeClass: "planned", tags: ["Theory"] },
//       { code: "CS 461", name: "Computer Security", credits: 3, instructor: "Prof. Bates", grade: "PLANNED", gradeClass: "planned", tags: ["Systems"] },
//       { code: "STAT 425", name: "Applied Regression & Design", credits: 3, instructor: "TBD", grade: "PLANNED", gradeClass: "planned", tags: ["Stats"] },
//       { code: "STAT 432", name: "Basics of Statistical Learning", credits: 3, instructor: "Prof. Wong", grade: "PLANNED", gradeClass: "planned", tags: ["ML", "Stats"] },
//       { code: "ENG 300", name: "Tech Writing for Engineers", credits: 3, instructor: "TBD", grade: "PLANNED", gradeClass: "planned", tags: ["Required"] },
//     ],
//   },
// ];

// ========== STATE ==========
let activeFilter = "all";

// ========== RENDER ==========
function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

function renderCourseRow(course, termStatus) {
//   const tagsHtml = course.tags.map(t => {
//     const isReq = t === "Required";
//     return `<span class="course-tag ${isReq ? 'req' : ''}">${escapeHtml(t)}</span>`;
//   }).join("");
    const tagsHtml = '';

  return `
    <div class="course-row ${termStatus}">
      <div class="course-code-block">
        <div class="course-bar"></div>
        <div class="course-code-text">
          <div class="course-code">${escapeHtml(course.code)}</div>
          <div class="course-credits-text">${course.credits} cr</div>
        </div>
      </div>
      <div class="course-info">
        <div class="course-name">${escapeHtml(course.title)}</div>
        <div class="course-instructor">${escapeHtml(course.instructor)}</div>
      </div>
      <div class="course-tag-cell">${tagsHtml}</div>
      <div class="course-grade-cell">
        <span class="grade-badge ${course.gradeClass}">${escapeHtml(course.grade ?? '')}</span>
      </div>
      <div class="course-row-actions">
        <button class="row-action" title="View course details" onclick="event.stopPropagation();">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
        </button>
        <button class="row-action" title="More" onclick="event.stopPropagation();">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/></svg>
        </button>
      </div>
    </div>
  `;
}

function renderTerm(term) {
  const showSection = activeFilter === "all" || activeFilter === term.status;
  const courseRows = term.courses.map(c => renderCourseRow(c, term.status)).join("");

  // Status pill content varies by status
  let statusPill;
  if (term.status === "current") {
    statusPill = `<span class="term-status-pill current"><span class="live-dot"></span>${escapeHtml(term.statusLabel)}</span>`;
  } else if (term.status === "planned") {
    statusPill = `<span class="term-status-pill planned">${escapeHtml(term.statusLabel)}</span>`;
  } else {
    statusPill = `<span class="term-status-pill past">${escapeHtml(term.statusLabel)}</span>`;
  }

  // Right side totals: past terms show GPA, current shows credits, planned shows credits
  const gpaCell = term.gpa
    ? `<div class="term-total"><svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor" style="color: var(--orange-300);"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01z"/></svg>Term GPA <span class="gpa-value">${term.gpa.toFixed(2)}</span></div>`
    : "";

  const addCourseFooter = term.status === "current" || term.status === "planned"
    ? `<div class="add-course-row">
        <button class="add-course-btn">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add a course to ${escapeHtml(term.name)}
        </button>
      </div>`
    : "";

  return `
    <section class="term-section ${showSection ? '' : 'hidden'}" data-term="${term.id}" data-status="${term.status}">
      <div class="term-header">
        <div class="term-marker ${term.status}"></div>
        <div class="term-title-block">
          <div class="term-title">
            ${escapeHtml(term.name)}
            ${statusPill}
          </div>
        </div>
        <div class="term-totals">
          ${gpaCell}
          <div class="term-total"><strong>${term.credits}</strong> credits · <strong>${term.courses.length}</strong> course${term.courses.length === 1 ? '' : 's'}</div>
        </div>
      </div>
      <div class="course-list">
        ${courseRows}
        ${addCourseFooter}
      </div>
    </section>
  `;
}

function render(terms) {
  const container = document.getElementById("termContainer");
  // Order: planned first, then current, then past (most recent first)
  const ordered = [...terms].sort((a, b) => {
    const statusOrder = { planned: 0, current: 1, past: 2 };
    if (statusOrder[a.status] !== statusOrder[b.status]) {
      return statusOrder[a.status] - statusOrder[b.status];
    }
    // Within same status, sort by id descending (newer first)
    return b.id < a.id;
  });

  container.innerHTML = ordered.map(renderTerm).join("");
}

// ========== EVENTS ==========

document.querySelectorAll('.nav-item').forEach(item => {
  item.addEventListener('click', () => {
    document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
    item.classList.add('active');
  });
});

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

// init
async function init() {
    const response = await fetch('/api/v1/user_stats');

    const data = await response.json();

    const courses = [...data.enrolled];

    for (const course of data.history) {
        courses.push(course)
    }

    // const grouped = Object.groupBy(courses, (course) => course.term);

    const grouped = courses.reduce((acc, item) => {
        const key = item.term;
        if (!acc[key]) acc[key] = [];
        acc[key].push(item);
        return acc;
    }, {});

    const by_term = [];

    const numeric_to_letter = ['F', 'D', 'C', 'B', 'A'];

    for (const [term, courses] of Object.entries(grouped)) {
        let credits = 0;
        let real_credits = 0;
        let gpa = 0; 

        for (const c of courses) {
            if (c.grade) {
                gpa += c.grade * c.credits
                credits += c.credits;
            }

            real_credits += c.credits;

            c.grade = numeric_to_letter[c.grade];
            c.gradeClass = (numeric_to_letter[c.grade] ?? '').toLowerCase();
        }

        gpa /= credits;

        by_term.push({
            name: term,
            status: 'past',
            statusLabel: 'Completed',
            credits: real_credits,
            gpa: gpa,
            courses: courses
        })
    }

    render(by_term);

    document.querySelectorAll('.term-tab').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.term-tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            activeFilter = tab.dataset.filter;
            render(by_term);
        });
    });

    const credits_fraction = document.getElementById('credits-frac');
    const credits_percent = document.getElementById('credits-percent');

    const gpa_counter = document.getElementById('gpa');

    tween(credits_fraction, 0, data.credits, {
        duration: 2000,
        format: '%d',
        style: tween_styles.Quartic.Out
    })

    tween(credits_percent, 0, data.credits / 120 * 100, {
        duration: 2000,
        format: '%d% complete',
        style: tween_styles.Quartic.Out
    })

    const gpa = data.gpa[8]

    tween(gpa_counter, 0, gpa, {
        duration: 2000,
        format: '%d',
        decimals: 2,
        style: tween_styles.Quartic.Out
    })

    const progress_ratio = document.getElementById('progress-ratio');
    const progress_bar = document.getElementById('progress-bar');

    tween(progress_ratio, 0, data.credits, {
        duration: 2000,
        format: '%d / 120 cr',
        style: tween_styles.Quartic.Out
    })

    tween(progress_bar, 0, data.credits / 120 * 100, {
        property: 'style',
        duration: 2000,
        format: 'width: %d%;',
        decimals: 3,
        style: tween_styles.Quartic.Out
    })

}

init();