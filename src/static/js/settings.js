// ============ TOAST ============
const toast = document.getElementById("toast");
const toastText = document.getElementById("toastText");
function showToast(msg) {
  toastText.textContent = msg;
  toast.classList.add("show");
  setTimeout(() => toast.classList.remove("show"), 2400);
}

// ============ CANVAS CONNECT FLOW ============
const canvasCard = document.getElementById("canvas-card");
const canvasConnectBtn = document.getElementById("canvas-connect");
const canvasStatus = document.getElementById("canvas-status");
const canvasMeta = document.getElementById("canvas-meta");
const canvasActions = document.getElementById("canvas-actions");

let canvasConnected = false;

canvasConnectBtn.addEventListener("click", () => {
  if (canvasConnected) return;

  // Loading state
  canvasConnectBtn.classList.add("connecting");
  canvasConnectBtn.innerHTML = `
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="animation: spin 0.8s linear infinite;"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
    Connecting...
  `;

  setTimeout(() => {
    canvasConnected = true;
    canvasCard.classList.add("connected");
    canvasStatus.classList.remove("disconnected");
    canvasStatus.classList.add("connected");
    canvasStatus.innerHTML = '<span class="live-dot"></span>Connected';
    canvasMeta.style.display = "flex";

    canvasActions.innerHTML = `
      <button class="btn-manage">Manage</button>
      <button class="btn-disconnect" id="canvas-disconnect">Disconnect</button>
    `;
    document.getElementById("canvas-disconnect").addEventListener("click", disconnectCanvas);

    showToast("Canvas connected — pulling courses...");
  }, 1400);
});

function disconnectCanvas() {
  if (!confirm("Disconnect Canvas? You'll lose live course data and grade sync.")) return;
  canvasConnected = false;
  canvasCard.classList.remove("connected");
  canvasStatus.classList.remove("connected");
  canvasStatus.classList.add("disconnected");
  canvasStatus.innerHTML = "Not connected";
  canvasMeta.style.display = "none";
  canvasActions.innerHTML = `
    <button class="btn-connect" id="canvas-connect">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
      Connect Canvas
    </button>
  `;
  showToast("Canvas disconnected");
}

// ============ DEGREEWORKS CONNECT FLOW ============
const dwCard = document.getElementById("dw-card");
const dwConnectBtn = document.getElementById("dw-connect");
const dwStatus = document.getElementById("dw-status");
const dwMeta = document.getElementById("dw-meta");
const dwActions = document.getElementById("dw-actions");

let dwConnected = false;

dwConnectBtn.addEventListener("click", () => {
  if (dwConnected) return;
  dwConnectBtn.classList.add("connecting");
  dwConnectBtn.innerHTML = `
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="animation: spin 0.8s linear infinite;"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
    Linking...
  `;

  setTimeout(() => {
    dwConnected = true;
    dwCard.classList.add("connected");
    dwStatus.classList.remove("disconnected");
    dwStatus.classList.add("connected");
    dwStatus.innerHTML = '<span class="live-dot"></span>Linked';
    dwMeta.style.display = "flex";

    dwActions.innerHTML = `
      <button class="btn-manage">Manage</button>
      <button class="btn-disconnect" id="dw-disconnect">Unlink</button>
    `;
    document.getElementById("dw-disconnect").addEventListener("click", disconnectDw);

    showToast("DegreeWorks linked — syncing audit...");
  }, 1600);
});

function disconnectDw() {
  if (!confirm("Unlink DegreeWorks? Degree progress data will no longer auto-update.")) return;
  dwConnected = false;
  dwCard.classList.remove("connected");
  dwStatus.classList.remove("connected");
  dwStatus.classList.add("disconnected");
  dwStatus.innerHTML = "Not linked";
  dwMeta.style.display = "none";
  dwActions.innerHTML = `
    <button class="btn-connect" id="dw-connect">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>
      Link DegreeWorks
    </button>
  `;
  showToast("DegreeWorks unlinked");
}

// ============ SECTION NAV - SMOOTH SCROLL ============
document.querySelectorAll(".section-nav-item").forEach(item => {
  item.addEventListener("click", () => {
    const target = document.getElementById("section-" + item.dataset.section);
    if (target) {
      target.scrollIntoView({ behavior: "smooth", block: "start" });
      document.querySelectorAll(".section-nav-item").forEach(i => i.classList.remove("active"));
      item.classList.add("active");
    }
  });
});

// Highlight section nav based on scroll position
const sections = ["profile", "integrations", "preferences", "notifications", "danger"];
window.addEventListener("scroll", () => {
  const scrollY = window.scrollY + 200;
  let current = "profile";
  for (const id of sections) {
    const el = document.getElementById("section-" + id);
    if (el && el.offsetTop <= scrollY) current = id;
  }
  document.querySelectorAll(".section-nav-item").forEach(i => {
    i.classList.toggle("active", i.dataset.section === current);
  });
}, { passive: true });

// ============ SAVE BUTTON ============
document.getElementById("saveBtn").addEventListener("click", () => {
  showToast("Settings saved");
});

// ============ MAIN SIDEBAR NAV ============
document.querySelectorAll(".nav-item").forEach(item => {
  item.addEventListener("click", () => {
    document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
    item.classList.add("active");
  });
});

// Add spin animation for connect spinner
const style = document.createElement("style");
style.textContent = "@keyframes spin { to { transform: rotate(360deg); } }";
document.head.appendChild(style);

// Toggle interactivity feedback
document.querySelectorAll(".toggle input").forEach(toggle => {
  toggle.addEventListener("change", e => {
    showToast(e.target.checked ? "Setting enabled" : "Setting disabled");
  });
});


async function init() {
    const response = await fetch('/api/v1/user_stats');

    const data = await response.json();

    const initials = document.getElementById('initials');

    const profile_name = document.getElementById('profile-name');
    const profile_email = document.getElementById('profile-email');

    const field_email = document.getElementById('email-field');

    initials.textContent = data.first_name.charAt(0).toUpperCase() + data.last_name.charAt(0).toUpperCase();

    profile_name.textContent = data.first_name + ' ' + data.last_name;
    profile_email.textContent = data.email;

    field_email.textContent = data.email;
}

init();