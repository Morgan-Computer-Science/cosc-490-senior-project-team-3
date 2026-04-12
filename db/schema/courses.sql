CREATE TABLE courses (
    id SERIAL PRIMARY KEY, -- course id
    title VARCHAR(100) NOT NULL,
    discipline CHAR(4) NOT NULL, -- COSC, ENG, MATH
    code SMALLINT UNSIGNED NOT NULL, -- 111, 001, 499
    credits TINYINT UNSIGNED, 
    description TEXT NOT NULL,
);