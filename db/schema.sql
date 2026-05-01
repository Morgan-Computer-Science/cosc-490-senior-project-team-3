CREATE TABLE IF NOT EXISTS term (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(40) NOT NULL, -- 'spring 202X'
    begins DATE NOT NULL,
    ends DATE NOT NULL,
    CHECK (begins < ends)
);

CREATE TABLE IF NOT EXISTS colleges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS departments ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    college_id INT NOT NULL,
    name VARCHAR(120) NOT NULL, -- 'Computer Science'
    code VARCHAR(4) UNIQUE NOT NULL, -- 'COSC', 'ENGL', 'MATH'
    description TEXT,
    CONSTRAINT college_fk FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    password_hash BINARY(32) NOT NULL,
    discipline VARCHAR(255) NOT NULL,
    begin_term INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT term_fk FOREIGN KEY (begin_term) REFERENCES term(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS faculty (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    prefix VARCHAR(3) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    college_id INT NOT NULL,
    department_id INT NOT NULL,
    role VARCHAR(15) NOT NULL,
    bio TEXT,
    CONSTRAINT department_fk FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    CONSTRAINT college_fk FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE,
    CHECK (role IN ('staff', 'advisor', 'administrator', 'professor', 'chair', 'dean'))
);

-- login session table
CREATE TABLE IF NOT EXISTS sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INT NOT NULL,
    token_hash BINARY(32) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES students(id) ON DELETE CASCADE
);

-- course table
CREATE TABLE IF NOT EXISTS courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    code VARCHAR(9) NOT NULL, -- COSC 001
    level SMALLINT NOT NULL, 
    credits SMALLINT NOT NULL,
    description TEXT,
    CONSTRAINT department_fk FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE (department_id, code)
);

-- sections are courses that are scheduled for a specific term
CREATE TABLE IF NOT EXISTS sections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id INT NOT NULL,
    term_id INT NOT NULL,
    instructor_id INT NOT NULL,
    section CHAR(3) NOT NULL, -- 001, W01, M01
    capacity INT NOT NULL,
    enrolled SMALLINT NOT NULL DEFAULT 0,
    waitlisted SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES courses(id),
    CONSTRAINT term_fk FOREIGN KEY (term_id) REFERENCES term(id),
    CONSTRAINT instructor_fk FOREIGN KEY (instructor_id) REFERENCES faculty(id) ON DELETE CASCADE
    UNIQUE (course_id, term_id, section)
);

CREATE INDEX IF NOT EXISTS idx_sections_term ON sections(term_id);
CREATE INDEX IF NOT EXISTS idx_sections_course_term ON sections(course_id, term_id);

CREATE TABLE IF NOT EXISTS section_meetings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    section_id INTEGER NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    location TEXT,
    CHECK (start_time < end_time),
    CONSTRAINT section_fk FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_meetings_section ON section_meetings(section_id);

CREATE TABLE IF NOT EXISTS meeting_days (
    meeting_id INTEGER NOT NULL,
    day INTEGER NOT NULL, 
    PRIMARY KEY (meeting_id, day),
    CONSTRAINT meeting_fk FOREIGN KEY (meeting_id) REFERENCES section_meetings(id) ON DELETE CASCADE,
    CHECK (day BETWEEN 1 AND 7)
);

CREATE INDEX IF NOT EXISTS idx_meeting_days_day ON meeting_days(day);

-- student enrollments into active courses
CREATE TABLE IF NOT EXISTS enrollments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    status TEXT NOT NULL DEFAULT 'enrolled',
    grade SMALLINT, -- 0: F, 1: D, 2: C, 3: B ....
    enrolled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dropped_at TIMESTAMP,
    completed_at TIMESTAMP,
    CHECK (status IN ('enrolled', 'waitlisted', 'dropped', 'completed', 'withdrawn')),
    CONSTRAINT student_fk FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT section_fk FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
    UNIQUE (student_id, section_id)
);

CREATE INDEX IF NOT EXISTS idx_enrollments_student ON enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_section ON enrollments(section_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_status ON enrollments(student_id, status);

-- prerequisites (fixed spelling + references)
CREATE TABLE IF NOT EXISTS prerequisites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    grouping INT NOT NULL,
    course_id INT NOT NULL,
    requires_id INT NOT NULL,
    min_grade SMALLINT NOT NULL DEFAULT 2,
    CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT requires_fk FOREIGN KEY (requires_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- appointments 
CREATE TABLE IF NOT EXISTS appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    advisor_id INT NOT NULL,
    student_id INT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT advisor_fk FOREIGN KEY (advisor_id) REFERENCES faculty(id),
    CONSTRAINT student_fk FOREIGN KEY (student_id) REFERENCES students(id)
);

-- conversations
CREATE TABLE IF NOT EXISTS conversations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INT NOT NULL,
    title VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT student_fk FOREIGN KEY (student_id) REFERENCES students(id)
);

-- chat logs table
CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation INT NOT NULL,
    prompt TEXT NOT NULL,
    response TEXT NOT NULL,
    tokens_used INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT conversation_fk FOREIGN KEY (conversation) REFERENCES conversations(id)
);