CREATE TABLE appointments (
    id SERIAL PRIMARY KEY, -- id ?
    advisor_id INT NOT NULL,
    student_id INT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT advisor_fk FOREIGN KEY (advisor_id) REFERENCES users(id),
    CONSTRAINT student_fk FOREIGN KEY (student_id) REFERENCES users(id)
);