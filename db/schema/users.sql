-- USER PRIVILEGES
-- 1: User (Students)
-- 2: Faculty (Advisors)
-- 3: Administrator
-- 4: Developer

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    discipline VARCHAR(255) NOT NULL,
    credits_earned SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    gpa DECIMAL NOT NULL DEFAULT 0,
    privilege INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);