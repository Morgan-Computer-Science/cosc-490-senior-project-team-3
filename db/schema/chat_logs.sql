CREATE TABLE chat_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL, -- Link to user
    prompt TEXT NOT NULL, -- What the user said
    response TEXT NOT NULL, -- What the AI said
    -- model_used VARCHAR(50), -- e.g., 'gpt-4o' or 'gemini-1.5-pro'
    tokens_used INT, -- Optional: for tracking costs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Time of the chat
    CONSTRAINT use_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);