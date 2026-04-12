CREATE TABLE sessions (
    id SERIAL PRIMARY KEY, -- session id
    user_id INT NOT NULL, -- foreign key to user
    token_hash CHAR(64) NOT NULL, -- hashed token (SHA256)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- session begin
    expires_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- session expire
    CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);