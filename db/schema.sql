-- users table 

-- USER PRIVILEGES
-- 1: User (Students)
-- 2: Faculty (Advisors)
-- 3: Administrator
-- 4: Developer

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    password_hash BINARY(32) NOT NULL,
    discipline VARCHAR(255) NOT NULL,
    credits_earned SMALLINT NOT NULL DEFAULT 0,
    privilege INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- gpa track table
CREATE TABLE gpa (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    semester INT NOT NULL,
    gpa DECIMAL(3, 2) NOT NULL DEFAULT 0,
    CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- login session table
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    token_hash CHAR(64) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- course table
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    discipline CHAR(4) NOT NULL,
    code SMALLINT NOT NULL,
    credits SMALLINT,
    description TEXT
);

-- prerequisites (fixed spelling + references)
CREATE TABLE prerequisites (
    id SERIAL PRIMARY KEY,
    grouping INT NOT NULL,
    course_id INT NOT NULL,
    requires_id INT NOT NULL,
    CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT requires_fk FOREIGN KEY (requires_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- appointments 
CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    advisor_id INT NOT NULL,
    student_id INT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT advisor_fk FOREIGN KEY (advisor_id) REFERENCES users(id),
    CONSTRAINT student_fk FOREIGN KEY (student_id) REFERENCES users(id)
);

-- chat logs table
CREATE TABLE chat_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    prompt TEXT NOT NULL,
    response TEXT NOT NULL,
    tokens_used INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_fk_chat FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- index
CREATE INDEX idx_chat_user ON chat_logs(user_id);