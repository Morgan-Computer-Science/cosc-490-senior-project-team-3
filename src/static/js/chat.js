const elements = {
	input: document.getElementById('chatInput'),
	sendBtn: document.getElementById('sendBtn'),
	sendIcon: document.getElementById('sendIcon'),
	messages: document.getElementById('messages'),
	messagesInner: document.getElementById('messagesInner'),
	newChat: document.getElementById('newChatBtn'),
	historyList: document.getElementById('historyList'),
	statusDot: document.getElementById('statusDot'),
	chatHeaderTitle: document.getElementById('chatHeaderTitle'),
	chatHeaderSub: document.getElementById('chatHeaderSub'),
	settingsBtn: document.getElementById('openSettings'),
	settingsModal: document.getElementById('settingsModal'),
	apiKeyInput: document.getElementById('apiKeyInput'),
	modelSelect: document.getElementById('modelSelect'),
	saveSettings: document.getElementById('saveSettings'),
	cancelSettings: document.getElementById('cancelSettings'),
	clearAllBtn: document.getElementById('clearAllBtn'),
	exportBtn: document.getElementById('exportBtn'),
	clearBtn: document.getElementById('clearBtn'),
	planBtn: document.getElementById('planBtn'),
	catalogBtn: document.getElementById('catalogBtn'),
	toast: document.getElementById('toast'),
};

const store = {
    model: "Gemini 2.5-flash"
};

// utility

function format_time(t) {
	const d = new Date(t);
    
	let h = d.getHours();
	
    const m = d.getMinutes().toString().padStart(2, '0');
    const ampm = h >= 12 ? 'PM' : 'AM';
	
    h = h % 12 || 12;

    return h + ':' + m + ' ' + ampm;
}

function formatRelative(ts) {
	const diff = (Date.now() - ts) / 1000;
	if (diff < 60) return 'Just now';
	if (diff < 3600) return Math.floor(diff / 60) + 'm ago';
	if (diff < 86400) return Math.floor(diff / 3600) + 'h ago';
	if (diff < 86400 * 2) return 'Yesterday';
	if (diff < 86400 * 7) return Math.floor(diff / 86400) + ' days ago';
	return new Date(ts).toLocaleDateString();
}

function escapeHtml(s) {
	return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

function scrollToBottom(smooth) {
    elements.messages.scrollTo({ top: elements.messages.scrollHeight, behavior: smooth === false ? 'auto' : 'smooth' });
}

function autoGrowInput() {
	elements.input.style.height = 'auto';
	elements.input.style.height = Math.min(elements.input.scrollHeight, 200) + 'px';
}

function renderMarkdown(text) {
	if (!text) return '';
	let html = escapeHtml(text);

	// Code blocks
	html = html.replace(/```(\w*)\n?([\s\S]*?)```/g, (_, lang, code) =>
		'<pre><code>' + code.trim() + '</code></pre>');

	// Inline code
	html = html.replace(/`([^`\n]+)`/g, '<code>$1</code>');

	// Headers
	html = html.replace(/^### (.+)$/gm, '<h3>$1</h3>');
	html = html.replace(/^## (.+)$/gm, '<h2>$1</h2>');
	html = html.replace(/^# (.+)$/gm, '<h1>$1</h1>');

	// Bold and italic
	html = html.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
	html = html.replace(/(^|[^*])\*([^*\n]+)\*/g, '$1<em>$2</em>');

	// Links
	html = html.replace(/\[([^\]]+)\]\((https?:\/\/[^)]+)\)/g,
		'<a href="$2" target="_blank" rel="noopener">$1</a>');

	// Blockquotes
	html = html.replace(/^&gt; (.+)$/gm, '<blockquote>$1</blockquote>');

	// Lists
	const lines = html.split('\n');
	const result = [];
	let inUl = false, inOl = false;
	for (const line of lines) {
		const ulMatch = line.match(/^[-*] (.+)$/);
		const olMatch = line.match(/^\d+\. (.+)$/);
		if (ulMatch) {
			if (inOl) { result.push('</ol>'); inOl = false; }
			if (!inUl) { result.push('<ul>'); inUl = true; }
			result.push('<li>' + ulMatch[1] + '</li>');
		} else if (olMatch) {
			if (inUl) { result.push('</ul>'); inUl = false; }
			if (!inOl) { result.push('<ol>'); inOl = true; }
			result.push('<li>' + olMatch[1] + '</li>');
		} else {
			if (inUl) { result.push('</ul>'); inUl = false; }
			if (inOl) { result.push('</ol>'); inOl = false; }
			result.push(line);
		}
	}
	if (inUl) result.push('</ul>');
	if (inOl) result.push('</ol>');
	html = result.join('\n');

	// Paragraphs
	html = html.split(/\n\n+/).map(block => {
		const trimmed = block.trim();
		if (!trimmed) return '';
		if (/^<(h[1-3]|ul|ol|pre|blockquote)/.test(trimmed)) return trimmed;
		return '<p>' + trimmed.replace(/\n/g, '<br>') + '</p>';
	}).join('\n');

	return html;
}

class Conversation {
    constructor(conversation_id) {
        this.id = conversation_id;
        this.title = '';
        this.messages = [];
    }

    async fetch_conversation() {
        const response = await fetch('/api/v1/conversation?id=' + this.id);

        const data = await response.json();

        this.messages = data.messages;
        this.title = data.title;
        this.created_at = data.created_at;
    }
}

class Chat {
    conversation = null;
    conversations = {};
    history = [];
    catalog_mode = true;
    plan_mode = false;
    streaming = false;

    async set_conversation(conversation_id) {
        // this.conversation = conv_obj;

        if (this.conversations[conversation_id] == null) {
            this.conversations[conversation_id] = new Conversation(conversation_id);
        }

        this.conversation = this.conversations[conversation_id];

        await this.conversation.fetch_conversation();

        this.render_chat();
    }

    async create_conversation() {
        if (this.streaming == true) {
            return;
        }

        this.set_streaming(true)

        const prompt = elements.input.value.trim();

        elements.input.value = '';

        elements.messagesInner.appendChild(this.render_message({
            id: -1,
            role: 'user',
            time: format_time(Date.now()),
            content: prompt
        }))

        const bot_element = this.render_message({
            id: -1,
            role: 'bot',
            time: format_time(Date.now()),
            content: ''
        }, {
            stream: true
        });

        elements.messagesInner.appendChild(bot_element);

        scrollToBottom(true);

        const response = await fetch('/api/v1/create', {
            method: 'POST',
            body: JSON.stringify({
                msg: prompt,
                agent: this.plan_mode ? 'advising' : 'catalog'
            })
        });

        const data = await response.json();

        bot_element.replaceWith(this.render_message({
            id: data.msg_id,
            role: 'bot',
            time: format_time(Date.now()),
            content: data.response 
        }));

        // when query is done executing, set streaming to false
        // this.streaming = false
        this.set_streaming(false)

        elements.input.focus();

        this.set_conversation(data.conversation_id);
        this.load_history();
    }

    delete_conversation() {

    }

    async send_message() {
        // ignore if query is already being executed
        if (this.streaming == true) {
            return ;
        }

        if (this.conversation == null) {
            return this.create_conversation();
        }

        this.set_streaming(true)
        
        const prompt = elements.input.value.trim();

        elements.input.value = '';

        elements.messagesInner.appendChild(this.render_message({
            id: -1,
            role: 'user',
            time: format_time(Date.now()),
            content: prompt
        }));

        const bot_element = this.render_message({
            id: -1,
            role: 'bot',
            time: format_time(Date.now()),
            content: ''
        }, {
            stream: true
        });

        elements.messagesInner.appendChild(bot_element);

        scrollToBottom(true);

        const response = await fetch('/api/v1/query', {
            method: 'POST',
            body: JSON.stringify({
                id: this.conversation.id,
                msg: prompt,
                agent: this.plan_mode ? 'advising' : 'catalog'
            })
        });

        const data = await response.json();

        bot_element.replaceWith(this.render_message({
            id: data.id,
            role: 'bot',
            time: format_time(Date.now()),
            content: data.response 
        }))

        this.conversation.messages.push({
            id: data.id,
            prompt: prompt,
            response: data.response,
            created_at: format_time(Date.now())
        });

        // when query is done executing, set streaming to false
        // this.streaming = false
        this.set_streaming(false)

        elements.input.focus();
    }

    async fetch_history() {
        const response = await fetch('/api/v1/conversations');

        this.history = await response.json();
    }

    async load_history() {
        await this.fetch_history();

        if (this.history.length === 0) {
            elements.historyList.innerHTML = '<div class="history-empty">No conversations yet. Start by asking a question below.</div>';
            
            return;
        }

        const today = [], yesterday = [], earlier = [];
        const now = Date.now();
        for (const c of this.history) {
            const created_at = new Date(c.created_at);

            const diff = (now - created_at) / 1000;

            if (diff < 86400) today.push(c);
            else if (diff < 86400 * 2) yesterday.push(c);
            else earlier.push(c);
        }

        const current_id = this.conversation ? this.conversation.id : null;

        function groupHtml(label, items) {
            if (!items.length) {
                return '';
            }

            const itemsHtml = items.map(c =>
                '<button class="history-item ' + (c.id === current_id ? 'active' : '') + '" data-id="' + c.id + '">' +
                    '<div class="history-item-title">' + escapeHtml(c.title) + '</div>' +
                    '<div class="history-item-time">' + formatRelative(c.created_at) + '</div>' +
                    '<button class="history-delete" data-delete="' + c.id + '" title="Delete">' +
                        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-2 14a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2L5 6"/></svg>' +
                    '</button>' +
                '</button>'
            ).join('');
            
            return '<div class="history-group"><div class="history-label">' + label + '</div>' + itemsHtml + '</div>';
        }

        elements.historyList.innerHTML = groupHtml('TODAY', today) + groupHtml('YESTERDAY', yesterday) + groupHtml('EARLIER', earlier);

        elements.historyList.querySelectorAll('.history-item').forEach(btn => {
            btn.addEventListener('click', e => {
                if (e.target.closest('[data-delete]')) return;

                const cid = btn.dataset.id;

                elements.historyList.querySelectorAll('.history-item').forEach(btn => {
                    btn.classList.toggle('active', btn.dataset.id ==  cid);
                })

                this.set_conversation(cid);
            });
        });
        elements.historyList.querySelectorAll('[data-delete]').forEach(btn => {
            btn.addEventListener('click', e => {
                e.stopPropagation();
                if (confirm('Delete this conversation?')) deleteConversation(btn.dataset.delete);
            });
        });
    }
    
    render_chat() {
        const messages = this.conversation.messages;

        if (messages.length === 0) {
            elements.chatHeaderTitle.textContent = 'New conversation';
            elements.chatHeaderSub.textContent = 'Trained on CS Department catalog';
            
            return this.render_welcome();
        }
        
        elements.chatHeaderTitle.textContent = this.title;

        elements.chatHeaderSub.textContent = messages.length + ' message' + (messages.length === 1 ? '' : 's') + ' · ' + store.model;
        elements.messagesInner.innerHTML = '';
        messages.forEach(msg => {
            // elements.messagesInner.appendChild(renderMessage(msg));
            elements.messagesInner.appendChild(this.render_message({
                id: msg.id,
                role: 'user',
                time: format_time(msg.created_at),
                content: msg.prompt
            }))

            elements.messagesInner.appendChild(this.render_message({
                id: msg.id,
                role: 'bot',
                time: format_time(msg.created_at),
                content: msg.response
            }))
        });

        scrollToBottom(false);
    }

    render_message(msg, opts) {
        opts = opts || {};
        const wrap = document.createElement('div');
        wrap.className = 'msg ' + msg.role + (msg.error ? ' error' : '');
        wrap.dataset.id = msg.id;

        if (msg.role === 'user') {
            wrap.innerHTML =
                '<div class="msg-content">' +
                    '<div class="msg-meta"><span class="msg-author">You</span><span>·</span><span>' + (msg.time || timeNow()) + '</span></div>' +
                    '<div class="msg-bubble">' + escapeHtml(msg.content) + '</div>' +
                '</div>' +
                '<div class="msg-avatar user"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg></div>';
        } else {
            const renderedContent = opts.stream
                ? renderMarkdown(msg.content) + '<p class="thinking">Thinking...</p>'
                : renderMarkdown(msg.content);
            const tools = msg.error ? '' :
                '<div class="msg-tools">' +
                    '<button class="tool-btn" data-action="copy" title="Copy"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg></button>' +
                    '<button class="tool-btn" data-action="regenerate" title="Regenerate"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg></button>' +
                '</div>';
            wrap.innerHTML =
                '<div class="msg-avatar bot">' +
                    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.25" stroke-linecap="round" stroke-linejoin="round"><path d="M12 8V4H8"></path><rect width="16" height="12" x="4" y="8" rx="2"></rect><path d="M2 14h2"></path><path d="M20 14h2"></path><path d="M15 13v2"></path><path d="M9 13v2"></path></svg>' +
                '</div>' +
                '<div class="msg-content">' +
                    '<div class="msg-meta"><span class="msg-author">BearViSor</span><span>·</span><span>' + (msg.time || timeNow()) + '</span></div>' +
                    '<div class="msg-bubble">' + renderedContent + '</div>' +
                    tools +
                '</div>';

            const copyBtn = wrap.querySelector('[data-action="copy"]');
            if (copyBtn) {
                copyBtn.addEventListener('click', () => {
                    navigator.clipboard.writeText(msg.content).then(() => {
                        copyBtn.classList.add('copied');
                        copyBtn.title = 'Copied!';
                        setTimeout(() => {
                            copyBtn.classList.remove('copied');
                            copyBtn.title = 'Copy';
                        }, 1500);
                    });
                });
            }
            const regenBtn = wrap.querySelector('[data-action="regenerate"]');
            if (regenBtn) {
                regenBtn.addEventListener('click', () => regenerateMessage(msg.id));
            }
        } 
        
        return wrap;
    }

    render_welcome() {
        elements.messagesInner.innerHTML =
		'<div class="welcome">' +
			'<div class="welcome-icon">' +
				'<svg viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/></svg>' +
			'</div>' +
			'<h1>Hi ' + store.name + ' — <span class="accent">what can I help with?</span></h1>' +
			'<p>I\'m trained on your department\'s catalog, prerequisites, and advisor calendar. Ask anything about courses, requirements, or your degree plan.</p>' +
			'<div class="prompts">' +
				'<button class="prompt-card" data-prompt="What are the prerequisites for CS 411 Database Systems and what should I know before taking it?">' +
					'<div class="prompt-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg></div>' +
					'<div class="prompt-title">Check prerequisites</div>' +
					'<div class="prompt-sub">Look up requirements for any course</div>' +
				'</button>' +
				'<button class="prompt-card" data-prompt="Can I still graduate on time if I change my minor to Statistics?">' +
					'<div class="prompt-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg></div>' +
					'<div class="prompt-title">Plan graduation</div>' +
					'<div class="prompt-sub">Map credits to a timeline</div>' +
				'</button>' +
				'<button class="prompt-card" data-prompt="Compare the Data Science minor vs the Statistics minor for someone interested in machine learning.">' +
					'<div class="prompt-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg></div>' +
					'<div class="prompt-title">Compare options</div>' +
					'<div class="prompt-sub">Side-by-side minor or track analysis</div>' +
				'</button>' +
				'<button class="prompt-card" data-prompt="Suggest 3 strong electives for next semester if I\'m interested in machine learning and want to stay around 15 credits.">' +
					'<div class="prompt-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l1.9 5.8L20 10l-5 4.4 1.6 6L12 17.3 7.4 20.4 9 14.4 4 10l6.1-1.2z"/></svg></div>' +
					'<div class="prompt-title">Recommend electives</div>' +
					'<div class="prompt-sub">Tailored to your interests</div>' +
				'</button>' +
			'</div>' +
		'</div>';

        elements.messagesInner.querySelectorAll('.prompt-card').forEach(card => {
            card.addEventListener('click', () => {
                sendMessage(card.dataset.prompt);
            });
        });

        elements.historyList.querySelectorAll('.history-item').forEach(btn => {
            btn.classList.toggle('active', false);
        })
    }

    set_streaming(state) {
        this.streaming = state;

        elements.input.disabled = state;

        if (state) {
            elements.sendBtn.classList.add('stop');
            elements.sendBtn.disabled = false;
            elements.sendBtn.title = 'Stop generating';
            document.getElementById('sendIcon').outerHTML =
                '<svg id="sendIcon" viewBox="0 0 24 24" fill="currentColor" stroke="none"><rect x="6" y="6" width="12" height="12" rx="1.5"/></svg>';
        } else {
            elements.sendBtn.classList.remove('stop');
            elements.sendBtn.disabled = elements.input.value.trim().length === 0;
            elements.sendBtn.title = 'Send';
            document.getElementById('sendIcon').outerHTML =
                '<svg id="sendIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="19" x2="12" y2="5"/><polyline points="5 12 12 5 19 12"/></svg>';
        }
    }

    export() {
        const conversation = this.conversation;

        if (conversation == null) {
            return;
        }

        if (conversation.messages.length === 0) { 
            return this.show_toast('Nothing to export.', true);
        }

        const text = 'BearViSor - ' + conversation.title + '\n' +
            new Date(conversation.created_at).toLocaleString() + '\n\n' + 
            conversation.messages.map(m => {
                return 'You: \n' + m.prompt + '\n\nAgent: \n' + m.response;
            }).join('\n---\n\n');

        const blob = new Blob([text], { type: 'text/plain' });

        const url = URL.createObjectURL(blob);
        const hyper = document.createElement('a');

        hyper.href = url;
        hyper.download = 'bearvisor-' + conversation.title.toLowerCase().replace(/[^a-z0-9]+/g, '-').slice(0, 40) + '.txt';
        hyper.click();

        URL.revokeObjectURL(url);

        this.show_toast('Exported');
    }

    show_toast(message, isError) {
        elements.toast.textContent = message;
        elements.toast.classList.toggle('error', !!isError);
        elements.toast.classList.add('show');
        
        setTimeout(() => elements.toast.classList.remove('show'), 2800);
    }
}

async function main() {
    const response = await fetch('/api/v1/user_stats');

    const data = await response.json();

    store.name = data.first_name;

    const chat = new Chat();

    // chat.set_conversation(1);
    chat.load_history();

    chat.render_welcome();

    elements.newChat.addEventListener('click', () => {
        chat.conversation = null;

        chat.render_welcome();
    })

    elements.exportBtn.addEventListener('click', () => {
        chat.export()
    })

    elements.planBtn.addEventListener('click', () => {
        chat.plan_mode = !chat.plan_mode;
        elements.planBtn.classList.toggle('active', chat.plan_mode);
    });

    elements.catalogBtn.addEventListener('click', () => {
        chat.catalog_mode = !chat.catalog_mode;
        elements.catalogBtn.classList.toggle('active', chat.catalog_mode);
    });

    elements.input.addEventListener('input', () => {
        autoGrowInput();

        elements.sendBtn.disabled = elements.input.value.trim().length === 0;
    });

    elements.input.addEventListener('keydown', e => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();

            if (!elements.sendBtn.disabled) {
                chat.send_message();
            }
        }
    });

    elements.sendBtn.addEventListener('click', () => {
        chat.send_message();
    });
}

main();