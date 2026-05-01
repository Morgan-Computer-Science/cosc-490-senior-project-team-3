// ============ FAQ DATA ============
const faqs = [
  {
    cat: "getting-started",
    icon: '<path d="M12 2l1.9 5.8L20 10l-5 4.4 1.6 6L12 17.3 7.4 20.4 9 14.4 4 10l6.1-1.2z"/>',
    q: "What is BearViSor and how does it work?",
    a: "BearViSor is an AI academic advisor trained on your department's catalog, prerequisites, and advisor calendars. Ask it natural questions about courses, requirements, or your degree plan, and it'll give you accurate answers in seconds — backed by your institution's actual data, not a generic LLM guess.",
  },
  {
    cat: "getting-started",
    icon: '<polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/>',
    q: "How do I connect Canvas and DegreeWorks?",
    a: "Head to <a>Settings → Integrations</a>. Click <strong>Connect Canvas</strong> or <strong>Link DegreeWorks</strong>, sign in with your university SSO, and approve the data scopes. The agent will start using live data within about 30 seconds. You can disconnect at any time without losing your saved schedules.",
  },
  {
    cat: "getting-started",
    icon: '<rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>',
    q: "Is BearViSor free for students?",
    a: "Yes — BearViSor is provided free to students whose universities have a department subscription. Check with your academic department or advising office to confirm coverage. There's no individual paid plan.",
  },
  {
    cat: "schedules",
    icon: '<path d="M12 2l1.9 5.8L20 10l-5 4.4 1.6 6L12 17.3 7.4 20.4 9 14.4 4 10l6.1-1.2z"/>',
    q: "How accurate are AI-generated schedules?",
    a: "<p>Schedules are conflict-free and respect prerequisites because the agent is grounded in your real catalog and transcript data. However:</p><ul><li>Section availability can change in real time — always verify on your registration system before locking in.</li><li>The agent can't guarantee a seat in a high-demand course.</li><li>Always confirm major-specific exceptions with your advisor.</li></ul>",
  },
  {
    cat: "schedules",
    icon: '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
    q: "Can I edit a generated schedule?",
    a: "Yes. After generation, switch to <code>Table view</code> and use the row actions to remove courses, or click <strong>Try a variation</strong> to ask the agent for a tweak — e.g. \"swap CS 461 for CS 484\" or \"make Mondays lighter\".",
  },
  {
    cat: "schedules",
    icon: '<polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/>',
    q: "Why won't a course I want appear in suggestions?",
    a: "<p>The most common reasons:</p><ul><li><strong>Missing a prerequisite</strong> — the agent filters out courses you can't yet take.</li><li><strong>Not offered that term</strong> — Spring-only courses won't show up in a Fall plan.</li><li><strong>Time conflict</strong> with another higher-priority course you've requested.</li></ul><p>Ask the agent directly: \"why didn't you include CS 411?\" and it'll explain.</p>",
  },
  {
    cat: "schedules",
    icon: '<path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>',
    q: "How long are schedules saved?",
    a: "Saved schedules persist indefinitely on your account. Auto-saved drafts (every generation) are kept for 90 days unless you star them. You can manage all of them under <a>My Schedule → Past plans</a>.",
  },
  {
    cat: "agent",
    icon: '<path d="M12 2l1.9 5.8L20 10l-5 4.4 1.6 6L12 17.3 7.4 20.4 9 14.4 4 10l6.1-1.2z"/>',
    q: "What can the AI agent actually do?",
    a: "<p>BearViSor can:</p><ul><li>Look up course details, prerequisites, and offerings</li><li>Build complete schedules with conflict resolution</li><li>Compare minors, tracks, or specializations</li><li>Calculate degree progress and graduation timelines</li><li>Recommend electives based on your interests</li><li>Find your advisor's open calendar slots</li></ul>",
  },
  {
    cat: "agent",
    icon: '<circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>',
    q: "What happens to my chat history?",
    a: "Your conversations are stored privately on your account so you can pick up where you left off. They're never used to train models, never shown to other students, and never shared with third parties. You can delete any conversation from the chat history at any time, and clear all data from <a>Settings → Danger zone</a>.",
  },
  {
    cat: "agent",
    icon: '<path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/>',
    q: "Can the agent make mistakes?",
    a: "Yes — like any AI, it can occasionally misinterpret a question or surface stale info if your catalog data hasn't synced recently. Always verify critical decisions (graduation eligibility, major changes, transfer credits) with your human advisor before acting. The agent will flag its own uncertainty when relevant.",
  },
  {
    cat: "account",
    icon: '<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>',
    q: "How do I change my major or minor?",
    a: "Major and minor changes have to go through your registrar — BearViSor only mirrors what's in your official record. Once your university updates your record, BearViSor will pick up the change at the next DegreeWorks sync (within a few hours). To plan around a hypothetical change, just ask the agent: \"what would my schedule look like if I switched to a Stats minor?\"",
  },
  {
    cat: "account",
    icon: '<path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/>',
    q: "How do I delete my account?",
    a: "Go to <a>Settings → Danger zone → Delete account</a>. This permanently removes your profile, conversations, and saved schedules from BearViSor. Your university record is unaffected. The action takes effect immediately and can't be undone.",
  },
];

// ============ STATE ============
let activeCat = "all";
let searchQuery = "";

// ============ DOM ============
const faqList = document.getElementById("faqList");
const searchInput = document.getElementById("searchInput");
const searchInfo = document.getElementById("searchInfo");
const toast = document.getElementById("toast");
const toastText = document.getElementById("toastText");

// ============ HELPERS ============
function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

function highlight(text, query) {
  if (!query) return text;
  const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const regex = new RegExp(`(${escaped})`, 'gi');
  return text.replace(regex, '<mark style="background: rgba(255,113,12,0.25); color: var(--orange-300); padding: 0 2px; border-radius: 2px;">$1</mark>');
}

function showToast(msg) {
  toastText.textContent = msg;
  toast.classList.add("show");
  setTimeout(() => toast.classList.remove("show"), 2400);
}

// ============ RENDER FAQ ============
function renderFaqs() {
  const q = searchQuery.toLowerCase().trim();
  const filtered = faqs.filter(f => {
    if (activeCat !== "all" && f.cat !== activeCat) return false;
    if (q) {
      const haystack = (f.q + " " + f.a).toLowerCase();
      if (!haystack.includes(q)) return false;
    }
    return true;
  });

  // Update search info text
  if (q) {
    searchInfo.textContent = filtered.length === 0
      ? `No results for "${q}"`
      : `${filtered.length} ${filtered.length === 1 ? "result" : "results"} for "${q}"`;
  } else {
    searchInfo.textContent = "";
  }

  if (filtered.length === 0) {
    faqList.outerHTML = `<div class="faq-list" id="faqList"><div class="no-results">
      <div class="no-results-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      </div>
      <h3>No matches found</h3>
      <p>Try a different search or ask the BearViSor agent directly.</p>
    </div></div>`;
    return;
  }

  faqList.outerHTML = `<div class="faq-list" id="faqList">${filtered.map((f, i) => `
    <div class="faq-item" data-index="${i}">
      <button class="faq-question" data-toggle="${i}">
        <div class="faq-q-content">
          <div class="faq-q-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${f.icon}</svg>
          </div>
          <div class="faq-q-text">${q ? highlight(escapeHtml(f.q), q) : escapeHtml(f.q)}</div>
        </div>
        <div class="faq-chevron">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
      </button>
      <div class="faq-answer">
        <div class="faq-answer-inner">${q ? highlight(f.a, q) : f.a}</div>
      </div>
    </div>
  `).join("")}</div>`;

  // Re-wire click handlers (since we replaced the DOM)
  document.querySelectorAll(".faq-question").forEach(btn => {
    btn.addEventListener("click", () => {
      btn.parentElement.classList.toggle("open");
    });
  });
}

// ============ EVENTS ============
document.querySelectorAll(".faq-cat").forEach(cat => {
  cat.addEventListener("click", () => {
    document.querySelectorAll(".faq-cat").forEach(c => c.classList.remove("active"));
    cat.classList.add("active");
    activeCat = cat.dataset.cat;
    renderFaqs();
  });
});

searchInput.addEventListener("input", e => {
  searchQuery = e.target.value;
  renderFaqs();
});

// Cmd/Ctrl + K focuses search
document.addEventListener("keydown", e => {
  if ((e.metaKey || e.ctrlKey) && e.key === "k") {
    e.preventDefault();
    searchInput.focus();
    searchInput.select();
  }
});

// Quick action cards
document.querySelectorAll(".quick-card").forEach(card => {
  card.addEventListener("click", () => {
    const title = card.querySelector(".quick-card-title").textContent;
    showToast(`Opening: ${title}`);
  });
});

// Getting started cards
document.querySelectorAll(".gs-card").forEach(card => {
  card.addEventListener("click", () => {
    const title = card.querySelector(".gs-title").textContent;
    showToast(`Opening guide: ${title}`);
  });
});

// Contact buttons
document.getElementById("contactBtn").addEventListener("click", () => {
  showToast("Opening chat with the team...");
});

document.querySelectorAll(".contact-method").forEach(method => {
  method.addEventListener("click", () => {
    const title = method.querySelector(".cm-title").textContent;
    showToast(`Opening: ${title}`);
  });
});

// Sidebar nav
document.querySelectorAll(".nav-item").forEach(item => {
  item.addEventListener("click", () => {
    document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
    item.classList.add("active");
  });
});

// Initial render
renderFaqs();