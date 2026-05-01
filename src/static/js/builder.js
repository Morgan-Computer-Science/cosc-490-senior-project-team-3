// ============ DATA: SAMPLE GENERATED SCHEDULE ============
// Times are in minutes from 8:00 AM (so 9:30 AM = 90)
// Each course has: code, name, credits, instructor, days array (M T W R F), startMin, durationMin, colorClass

const sampleSchedule = {
	term: "Fall 2026",
	rationale: "This plan keeps you on track for graduation while targeting your ML interest. CS 421 and CS 461 are major requirements — both fit cleanly into your morning slots. STAT 432 double-counts toward the Stats minor and your CS technical elective. ENG 300 satisfies your writing requirement. Friday is intentionally light (one class) to give you a research/internship buffer.",
	totalCredits: 15,
	preferences: ["Morning bias", "Light Fridays", "ML focus"],
	courses: [
		{
			code: "CS 421", name: "Programming Languages & Compilers",
			credits: 3, instructor: "Prof. Vasilakis",
			days: ["M", "W", "F"], startMin: 90, durationMin: 50, // 9:30-10:20
			colorClass: "c1",
			note: "Required for major"
		},
		{
			code: "CS 461", name: "Computer Security",
			credits: 3, instructor: "Prof. Bates",
			days: ["T", "R"], startMin: 180, durationMin: 75, // 11:00-12:15
			colorClass: "c4",
			note: "Required for major"
		},
		{
			code: "STAT 432", name: "Basics of Statistical Learning",
			credits: 3, instructor: "Prof. Wong",
			days: ["M", "W"], startMin: 360, durationMin: 75, // 2:00-3:15
			colorClass: "c3",
			note: "Counts toward CS + Stats minor"
		},
		{
			code: "STAT 425", name: "Applied Regression & Design",
			credits: 3, instructor: "Prof. Liang",
			days: ["T", "R"], startMin: 510, durationMin: 75, // 4:30-5:45
			colorClass: "c5",
			note: "Stats minor requirement"
		},
		{
			code: "ENG 300", name: "Tech Writing for Engineers",
			credits: 3, instructor: "Dr. Reyes",
			days: ["M", "W"], startMin: 540, durationMin: 50, // 5:00-5:50
			colorClass: "c2",
			note: "Writing requirement"
		},
	]
};

// ============ STATE ============
const state = {
	status: "idle", // idle | loading | result
	view: "calendar", // calendar | table
	schedule: null,
};

// ============ DOM ============
const promptInput = document.getElementById("promptInput");
const generateBtn = document.getElementById("generateBtn");
const resultArea = document.getElementById("resultArea");
const termSelector = document.getElementById("termSelector");

// ============ HELPERS ============
function escapeHtml(s) {
	return String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

function minToTime(min) {
	const total = min + 8 * 60; // offset by 8 AM
	const h = Math.floor(total / 60);
	const m = total % 60;
	const ampm = h >= 12 ? "PM" : "AM";
	const h12 = h % 12 || 12;
	return h12 + ":" + (m < 10 ? "0" + m : m) + " " + ampm;
}

function timeRange(startMin, durationMin) {
	return minToTime(startMin) + " – " + minToTime(startMin + durationMin);
}

function dayLabel(d) {
	return { M: "Mon", T: "Tue", W: "Wed", R: "Thu", F: "Fri" }[d];
}

// ============ RENDER: EMPTY ============
function renderEmpty() {
	resultArea.innerHTML = `
		<div class="empty-state">
			<div class="empty-icon-wrap">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
			</div>
			<h3>Your generated schedule will appear here</h3>
			<p>Describe what you want and BearViSor will build a calendar with the right courses, times, and instructors. You can iterate from there.</p>
		</div>
	`;
}

// ============ RENDER: LOADING ============
function renderLoading() {
	resultArea.innerHTML = `
		<div class="loading-state">
			<div class="spinner"></div>
			<h3>Building your schedule</h3>
			<p>BearViSor is checking prerequisites, conflicts, and your preferences.</p>
			<div class="loading-steps">
				<div class="loading-step done" data-step="1">
					<div class="step-icon">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
					</div>
					Parsing your preferences
				</div>
				<div class="loading-step active" data-step="2">
					<div class="step-icon">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3" fill="currentColor"/></svg>
					</div>
					Matching against the catalog
				</div>
				<div class="loading-step" data-step="3">
					<div class="step-icon">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/></svg>
					</div>
					Resolving time conflicts
				</div>
				<div class="loading-step" data-step="4">
					<div class="step-icon">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/></svg>
					</div>
					Optimizing for preferences
				</div>
			</div>
		</div>
	`;

	// Animate the steps progressing
	const steps = resultArea.querySelectorAll(".loading-step");
	let currentStep = 1; // step 1 already done
	const interval = setInterval(() => {
		currentStep++;
		if (currentStep >= steps.length) {
			clearInterval(interval);
			return;
		}
		steps.forEach((step, i) => {
			step.classList.remove("active", "done");
			if (i < currentStep) step.classList.add("done");
			else if (i === currentStep) step.classList.add("active");
		});
		// Replace icons for done/active states
		steps.forEach(step => {
			const iconWrap = step.querySelector(".step-icon");
			if (step.classList.contains("done")) {
				iconWrap.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>';
			} else if (step.classList.contains("active")) {
				iconWrap.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3" fill="currentColor"/></svg>';
			} else {
				iconWrap.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/></svg>';
			}
		});
	}, 600);
}

// ============ RENDER: RESULT ============
function renderResult() {
	const sched = state.schedule;
	resultArea.innerHTML = `
		<div class="result-wrap">
			<div class="schedule-section">
				<div class="schedule-header">
					<div class="schedule-header-left">
						<h3>${escapeHtml(sched.term)} — ${sched.totalCredits} credits</h3>
						<div class="ai-badge">
							<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l1.9 5.8L20 10l-5 4.4 1.6 6L12 17.3 7.4 20.4 9 14.4 4 10l6.1-1.2z"/></svg>
							AI Generated
						</div>
					</div>
					<div class="view-tabs" id="viewTabs">
						<button class="view-tab ${state.view === 'calendar' ? 'active' : ''}" data-view="calendar">
							<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
							Calendar
						</button>
						<button class="view-tab ${state.view === 'table' ? 'active' : ''}" data-view="table">
							<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
							Table
						</button>
					</div>
				</div>
				<div id="scheduleBody">
					${state.view === 'calendar' ? renderCalendar() : renderTable()}
				</div>
			</div>

			${renderSummary()}
		</div>
	`;

	// Wire view toggle
	resultArea.querySelectorAll(".view-tab").forEach(tab => {
		tab.addEventListener("click", () => {
			state.view = tab.dataset.view;
			// Update active state and body only (don't re-render whole result)
			resultArea.querySelectorAll(".view-tab").forEach(t => t.classList.remove("active"));
			tab.classList.add("active");
			document.getElementById("scheduleBody").innerHTML =
				state.view === "calendar" ? renderCalendar() : renderTable();
		});
	});
}

// ============ CALENDAR VIEW ============
function renderCalendar() {
	const sched = state.schedule;
	const days = ["M", "T", "W", "R", "F"];
	const dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri"];

	// Time slots from 8 AM to 6 PM in 30-min increments
	// Each slot = 36px tall, so 1 minute = 1.2px
	const PIXELS_PER_MIN = 0.6;
	const SLOT_HEIGHT = 36; // 30 min slot
	const slots = [];
	for (let h = 8; h <= 18; h++) {
		slots.push(h);
	}

	// Header row
	const headerCells = `
		<div class="cal-header-cell time-corner"></div>
		${dayNames.map(d => `<div class="cal-header-cell">${d}</div>`).join("")}
	`;

	// Time labels (one per hour)
	const timeColumn = slots.map(h => {
		const ampm = h >= 12 ? "PM" : "AM";
		const h12 = h > 12 ? h - 12 : h;
		return `<div class="cal-time-cell">${h12} ${ampm}</div>`;
	}).join("");

	// Day columns - each is a positioned container for its events
	const dayColumns = days.map(day => {
		// Find courses on this day
		const events = sched.courses.filter(c => c.days.includes(day));
		const eventBlocks = events.map(c => {
			// Top offset = (startMin - 0) * PIXELS_PER_MIN
			// Height = durationMin * PIXELS_PER_MIN
			const top = c.startMin * PIXELS_PER_MIN;
			const height = c.durationMin * PIXELS_PER_MIN;
			return `
				<div class="cal-block ${c.colorClass}"
						 style="top: ${top}px; height: ${height}px;"
						 title="${escapeHtml(c.code)} — ${escapeHtml(c.name)}\n${timeRange(c.startMin, c.durationMin)}\n${escapeHtml(c.instructor)}">
					<div class="cal-block-code">${escapeHtml(c.code)}</div>
					<div class="cal-block-name">${escapeHtml(c.name)}</div>
					${height > 50 ? `<div class="cal-block-meta">${timeRange(c.startMin, c.durationMin)}</div>` : ""}
				</div>
			`;
		}).join("");

		// Generate the slot grid lines
		const slotLines = slots.map(() =>
			`<div style="height: ${SLOT_HEIGHT}px; border-bottom: 1px solid var(--border);"></div>`
		).join("");

		return `
			<div class="cal-day-col" style="position: relative;">
				${slotLines}
				${eventBlocks}
			</div>
		`;
	}).join("");

	// Custom grid template: time column (60px) + 5 day columns
	return `
		<div class="calendar-view">
			<div style="display: grid; grid-template-columns: 56px repeat(5, 1fr); border: 1px solid var(--border); border-radius: 8px; overflow: hidden; background: var(--bg);">
				${headerCells}
				<div style="border-right: 1px solid var(--border);">
					${timeColumn}
				</div>
				${dayColumns}
			</div>
		</div>
	`;
}

// ============ TABLE VIEW ============
function renderTable() {
	const sched = state.schedule;
	const days = ["M", "T", "W", "R", "F"];

	const rows = sched.courses.map(c => {
		const dayPills = days.map(d =>
			`<div class="day-pill ${c.days.includes(d) ? 'active' : ''}">${d}</div>`
		).join("");

		return `
			<tr>
				<td>
					<div class="table-code-cell">
						<div class="color-pip ${c.colorClass}"></div>
						<div>
							<div class="table-code">${escapeHtml(c.code)}</div>
							<div class="table-credits">${c.credits} cr</div>
						</div>
					</div>
				</td>
				<td>
					<div class="table-name">${escapeHtml(c.name)}</div>
					<div class="table-instructor">${escapeHtml(c.instructor)}</div>
				</td>
				<td><div class="table-days">${dayPills}</div></td>
				<td><div class="table-time">${timeRange(c.startMin, c.durationMin)}</div></td>
				<td>
					<button class="row-action-btn danger" title="Remove course">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-2 14a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2L5 6"/></svg>
					</button>
				</td>
			</tr>
		`;
	}).join("");

	return `
		<div class="table-view">
			<table class="schedule-table">
				<thead>
					<tr>
						<th style="width: 130px;">Course</th>
						<th>Title</th>
						<th style="width: 160px;">Days</th>
						<th style="width: 180px;">Time</th>
						<th style="width: 50px;"></th>
					</tr>
				</thead>
				<tbody>${rows}</tbody>
			</table>
		</div>
	`;
}

// ============ SUMMARY SIDEBAR ============
function renderSummary() {
	const sched = state.schedule;
	// Count courses per day
	const dayCount = { M: 0, T: 0, W: 0, R: 0, F: 0 };
	sched.courses.forEach(c => c.days.forEach(d => dayCount[d]++));
	const heaviestDay = Object.entries(dayCount).sort((a, b) => b[1] - a[1])[0];
	const earliestStart = Math.min(...sched.courses.map(c => c.startMin));

	return `
		<div class="summary-card">
			<h4>Schedule summary</h4>

			<div class="summary-stat">
				<div class="summary-stat-label">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
					Courses
				</div>
				<div class="summary-stat-value">${sched.courses.length}</div>
			</div>

			<div class="summary-stat">
				<div class="summary-stat-label">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg>
					Total credits
				</div>
				<div class="summary-stat-value accent">${sched.totalCredits}</div>
			</div>

			<div class="summary-stat">
				<div class="summary-stat-label">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
					Earliest class
				</div>
				<div class="summary-stat-value">${minToTime(earliestStart)}</div>
			</div>

			<div class="summary-stat">
				<div class="summary-stat-label">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/></svg>
					Heaviest day
				</div>
				<div class="summary-stat-value">${dayLabel(heaviestStart(heaviestDay[0]))} (${heaviestDay[1]})</div>
			</div>

			<div class="summary-stat">
				<div class="summary-stat-label">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
					No conflicts
				</div>
				<div class="summary-stat-value success">All clear</div>
			</div>

			<div class="ai-rationale">
				<div class="ai-rationale-header">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l1.9 5.8L20 10l-5 4.4 1.6 6L12 17.3 7.4 20.4 9 14.4 4 10l6.1-1.2z"/></svg>
					Why this works
				</div>
				<div class="ai-rationale-text">${escapeHtml(sched.rationale)}</div>
			</div>

			<div class="summary-actions">
				<button class="save-schedule-btn">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
					Save to my schedule
				</button>
				<button class="iterate-btn" id="iterateBtn">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
					Try a variation
				</button>
			</div>
		</div>
	`;
}

// Tiny helper for the summary
function heaviestStart(day) { return day; }

// ============ ACTIONS ============
async function generate() {
	if (state.status === "loading") return;
	const prompt = promptInput.value.trim();
	if (!prompt) return;

	state.status = "loading";
	generateBtn.disabled = true;
	renderLoading();

    const response = await fetch('/api/v1/build', {
        method: "POST",
        body: JSON.stringify({
            msg: promptInput.value
        })
    })

    const schedule = await response.json()

    for (const course of schedule.courses) { 
        course.startMin -= 250;
        course.durationMin = 50;
    }

    state.status = 'result';
    state.schedule = schedule
    state.view = 'calendar'

    generateBtn.disabled = false;

    renderResult()

    resultArea.scrollIntoView({ behavior: "smooth", block: "start" });

	// Simulate AI generation. In real usage, swap this for a fetch to your backend.
	// setTimeout(() => {
	// 	state.status = "result";
	// 	state.schedule = sampleSchedule;
	// 	state.view = "calendar";
	// 	generateBtn.disabled = false;
	// 	renderResult();

	// 	// Scroll result into view smoothly
	// 	resultArea.scrollIntoView({ behavior: "smooth", block: "start" });
	// }, 2400);
}

// ============ EVENT WIRING ============
promptInput.addEventListener("input", () => {
	promptInput.style.height = "auto";
	promptInput.style.height = Math.min(promptInput.scrollHeight, 240) + "px";
	generateBtn.disabled = promptInput.value.trim().length === 0 || state.status === "loading";
});

promptInput.addEventListener("keydown", e => {
	if ((e.metaKey || e.ctrlKey) && e.key === "Enter") {
		e.preventDefault();
		if (!generateBtn.disabled) generate();
	}
});

generateBtn.addEventListener("click", generate);

document.querySelectorAll(".suggestion-chip").forEach(chip => {
	chip.addEventListener("click", () => {
		promptInput.value = chip.dataset.prompt;
		promptInput.dispatchEvent(new Event("input"));
		promptInput.focus();
	});
});

// "Try a variation" delegates back to the prompt
resultArea.addEventListener("click", e => {
	if (e.target.closest("#iterateBtn")) {
		promptInput.focus();
		promptInput.scrollIntoView({ behavior: "smooth", block: "center" });
	}
});

// Sidebar nav
document.querySelectorAll(".nav-item").forEach(item => {
	item.addEventListener("click", () => {
		document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
		item.classList.add("active");
	});
});

// Initial focus
promptInput.focus();
