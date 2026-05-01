import sqlite3
import hashlib
import secrets
import os

from datetime import datetime, timedelta
from typing import Annotated, Optional

from lib.types import UserRegistration, UserLogin, User, Course

__dir__: str = os.path.dirname(__file__)

DATABASE_FOLDER: str = os.path.join(__dir__, '../../db')
SCHEMA_FILE: str = os.path.join(DATABASE_FOLDER, 'schema.sql')
POPULATE_FILE: str = os.path.join(DATABASE_FOLDER, 'populate.sql')

# allowed_tables: list = ['users', 'gpa', 'sessions', 'courses', 'prerequisites', 'appointments', 'chat_logs']

allowed_tables: list = ['students', 'gpa', 'sessions', 'courses', 'departments', 'term', 'sections', 'enrollments', 'prerequisites', 'appointments', 'conversations', 'messages']

int_to_day = {
    1: 'M',
    2: 'Tu',
    3: 'W',
    4: 'Th',
    5: 'F',
    6: 'S',
    7: 'Su',
}

# connect to the databse
# database: sqlite3.Connection = sqlite3.connect(os.path.join(DATABASE_FOLDER, 'database.db'))

class Database:
    def __init__(self, path: str, schema: str):
        self.connection: sqlite3.Connection = sqlite3.connect(path)
        self.schema = schema

        # set return items to a dict
        self.connection.row_factory = sqlite3.Row

        self.init()

    # initializes database schema, returns successful: bool
    def init(self) -> bool:
        try:
            cursor: sqlite3.Cursor = self.connection.cursor()

            cursor.executescript(self.schema)

            cursor.close()

            print('database successfully initialized')

            return True
        except sqlite3.Error as err:
            print('failed to initialize database: ', err)

            return False

    # populates database with data
    def populate(self, script: str) -> bool:
        try:
            cursor: sqlite3.Cursor = self.connection.cursor()

            cursor.executescript(script)

            cursor.close()

            print('database populated')
        except sqlite3.Error as err:
            print('failed to populate database: ', err)

    def register_user(self, data: UserRegistration) -> User:
        hash_object = hashlib.sha256(data.password.encode())
    
        digest: str = hash_object.hexdigest()

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `students` (email, first_name, last_name, password_hash, discipline, begin_term)
            VALUES (?, ?, ?, ?, ?, ?);
        ''', (data.email, data.first_name, data.last_name, digest, 'Computer Science', 1))

        self.connection.commit()

        cursor.close()

        return self.login_user(UserLogin(email=data.email, password=data.password))

    def login_user(self, data: UserLogin):
        hash_object = hashlib.sha256(data.password.encode())
        digest: str = hash_object.hexdigest()

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT * FROM `students`
            WHERE email = ?            
        ''', (data.email,))

        row = cursor.fetchone()
        row = dict(row)

        user_data: Optional[User] = User.model_validate(row) if row else None

        # check if email exists 
        if (user_data == None):
            return (False, 'User not found')
        
        if (user_data.password_hash != digest):
            return (False, 'Incorrect password')
        
        cursor.close()
        
        return (True, user_data)

    def create_session(self, user: User) -> str:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT * FROM `sessions`
            WHERE user_id = ?
        ''', (user.id,))

        existing_session = cursor.fetchone()

        if (existing_session):
            existing_session = dict(existing_session)

            cursor.execute('''
                DELETE FROM `sessions`
                WHERE id = ?
            ''', (existing_session['id'],))

        # generate token
        token = secrets.token_urlsafe(32)

        hash_object = hashlib.sha256(token.encode())

        digest = hash_object.hexdigest()

        # 3 months until expire
        offset = timedelta(days=90)

        expires = datetime.now() + offset
        expires_formatted = expires.strftime('%Y-%m-%d %H:%M:%S')

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `sessions` (user_id, token_hash, expires_at)
            VALUES (?, ?, ?)         
        ''', (user.id, digest, expires_formatted))

        self.connection.commit()

        cursor.close()

        return token
    
    # def validate_session(self, token: str) -> Optional[User]:
    #     hash_object = hashlib.sha256(token.encode())

    #     digest = hash_object.hexdigest()

    #     cursor: sqlite3.Cursor = self.connection.cursor()

    #     cursor.execute('''
    #         SELECT * FROM `sessions`
    #         WHERE token_hash = ?
    #     ''', (digest,))

    #     session_row = cursor.fetchone()

    #     if (session_row == None):
    #         return None
        
    #     session_row = dict(session_row)

    #     expires_at = datetime.strptime(session_row['expires_at'], '%Y-%m-%d %H:%M:%S')

    #     if (expires_at < datetime.now()):
    #         return None
        
    #     cursor.execute('''
    #         SELECT * FROM `students`
    #         WHERE id = ?
    #     ''', (session_row['user_id'],))

    #     user_row = cursor.fetchone()

    #     if (user_row == None):
    #         return None
        
    #     user_row = dict(user_row)

    #     user_data: Optional[User] = User.model_validate(user_row) if user_row else None

    #     cursor.close()

    #     return user_data

    def validate_session(self, token: str) -> Optional[User]:
        return User(
            id=16,
            email='kequi4@morgan.edu',
            first_name='Kevin',
            last_name='Quintero',
            password_hash='6c897c93fbc1aac75fe5d48bf161d37fff1caac41735208987231a6bc8c72a89',
            discipline='Computer Science',
            begin_term=1,
            created_at="2025-05-21 00:00:00"
        )
    
    # def fetch_gpa(self, user: User) -> float:
    #     cursor: sqlite3.Cursor = self.connection.cursor()

    #     cursor.execute('''
    #         SELECT CAST(SUM(e.grade * c.credits) AS FLOAT) / SUM(c.credits) AS gpa
    #         FROM `enrollments` AS e
    #         JOIN `sections` AS s ON s.id = e.section_id
    #         JOIN `courses` AS c ON c.id = s.course_id
    #         WHERE e.student_id = ? AND e.status = 'completed' AND e.grade IS NOT NULL;            
    #     ''', (user.id,))

    #     gpa = dict(cursor.fetchone())['gpa']

    #     cursor.close()

    #     return gpa
    
    def fetch_semester_gpa(self, user: User, semester: int = 1) -> float:
        cursor: sqlite3.Curosr = self.connection.cursor()

        cursor.execute('''
            SELECT
                ROUND(
                    CAST(SUM(e.grade * c.credits) AS REAL)
                    / NULLIF(SUM(c.credits), 0),
                    2
                ) AS gpa,
                SUM(c.credits) AS credits_earned,
                COUNT(*) AS courses_completed
            FROM `enrollments` AS e
            JOIN `sections` AS s ON s.id = e.section_id
            JOIN `courses` AS c ON c.id = s.course_id
            JOIN `term` AS t ON t.id = s.term_id
            WHERE e.student_id = ?
            AND t.id <= ?
            AND e.status = 'completed'
            AND e.grade IS NOT NULL;
        ''', (user.id, user.begin_term + semester - 1))

        gpa = dict(cursor.fetchone())['gpa']

        cursor.close()

        return gpa
    
    def fetch_credits(self, user: User) -> int:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT SUM(c.credits) AS credits
            FROM `enrollments` AS e
            INNER JOIN `sections` AS s ON s.id = e.section_id
            INNER JOIN `courses` AS c ON c.id = s.course_id
            WHERE e.student_id = ? AND e.status = 'completed' AND e.grade IS NOT NULL AND e.grade >= 2;          
        ''', (user.id,))

        credits_earned = dict(cursor.fetchone())['credits']

        cursor.close()

        return credits_earned

    def fetch_enrolled(self, user: User) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT s.id, e.grade, e.status, c.title, s.section, c.code, c.level, c.credits, t.name AS term, sm.start_time, sm.end_time, md.day, d.name AS department,
                (f.prefix || f.first_name || ' ' || f.last_name) AS instructor
            FROM `enrollments` AS e
            INNER JOIN `sections` AS s ON s.id = e.section_id
            INNER JOIN `section_meetings` AS sm ON sm.section_id = s.id
            INNER JOIN `meeting_days` AS md ON md.meeting_id = sm.id
            INNER JOIN `courses` AS c ON c.id = s.course_id
            INNER JOIN `departments` AS d ON c.department_id = d.id
            INNER JOIN `faculty` AS f ON s.instructor_id = f.id
            INNER JOIN `term` AS t ON s.term_id = t.id
            WHERE e.student_id = ? AND e.status = 'enrolled'            
        ''', (user.id,))

        results: list = [dict(row) for row in cursor.fetchall()]

        enrolled_courses: dict = {}

        for row in results:
            id: int = row['id']

            if (enrolled_courses.get(id) == None):
                enrolled_courses[id] = {
                    'id': row['id'],
                    'title': row['title'],
                    'code': row['code'],
                    'section': row['section'],
                    'grade': row['grade'],
                    'status': row['status'],
                    'department': row['department'],
                    'instructor': row['instructor'],
                    'level': row['level'],
                    'credits': row['credits'],
                    'term': row['term'],
                    'start_time': row['start_time'],
                    'end_time': row['end_time'],
                    'days': [int_to_day[row['day']]]
                }
            else:
                enrolled_courses[id]['days'].append(int_to_day[row['day']])

        cursor.close()

        return list(enrolled_courses.values())

    def fetch_course_history(self, user: User) -> list:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT s.id, e.grade, e.status, c.title, s.section, c.code, c.level, c.credits, t.name AS term, sm.start_time, sm.end_time, md.day, d.name AS department,
                (f.prefix || f.first_name || ' ' || f.last_name) AS instructor
            FROM `enrollments` AS e
            INNER JOIN `sections` AS s ON s.id = e.section_id
            INNER JOIN `section_meetings` AS sm ON sm.section_id = s.id
            INNER JOIN `meeting_days` AS md ON md.meeting_id = sm.id
            INNER JOIN `courses` AS c ON c.id = s.course_id
            INNER JOIN `departments` AS d ON c.department_id = d.id
            INNER JOIN `faculty` AS f ON s.instructor_id = f.id
            INNER JOIN `term` AS t ON s.term_id = t.id
            WHERE e.student_id = ? AND e.status IN ('completed', 'dropped', 'withdrawn')
        ''', (user.id,))

        results: list = [dict(row) for row in cursor.fetchall()]

        enrolled_courses: dict = {}

        for row in results:
            id: int = row['id']

            if (enrolled_courses.get(id) == None):
                enrolled_courses[id] = {
                    'id': row['id'],
                    'title': row['title'],
                    'code': row['code'],
                    'section': row['section'],
                    'grade': row['grade'],
                    'status': row['status'],
                    'department': row['department'],
                    'instructor': row['instructor'],
                    'level': row['level'],
                    'credits': row['credits'],
                    'term': row['term'],
                    'start_time': row['start_time'],
                    'end_time': row['end_time'],
                    'days': [int_to_day[row['day']]]
                }
            else:
                enrolled_courses[id]['days'].append(int_to_day[row['day']])

        cursor.close()

        return list(enrolled_courses.values())

    def fetch_conversation(self, user: User, conversation_id: int) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        # grab conversation data
        cursor.execute('''
            SELECT title, created_at
            FROM `conversations`
            WHERE student_id = ? AND id = ?            
        ''', (user.id, conversation_id))

        info = dict(cursor.fetchone())

        cursor.execute('''
            SELECT m.id, m.prompt, m.response, m.created_at
            FROM `messages` AS m
            INNER JOIN `conversations` AS c ON m.conversation = c.id
            WHERE c.student_id = ? AND c.id = ?
            ORDER BY m.id DESC
            LIMIT 20
        ''', (user.id, conversation_id))

        selected = cursor.fetchall()

        messages = [dict(row) for row in selected]

        cursor.close()

        return {
            'title': info['title'],
            'messages': messages[::-1],
            'created_at': info['created_at']
        }
    
    def fetch_convo_list(self, user: User) -> list[dict]:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT * 
            FROM `conversations`
            WHERE student_id = ?
            ORDER BY created_at DESC
        ''', (user.id,))

        selected = cursor.fetchall()

        conversations = [dict(row) for row in selected]

        cursor.close()

        return conversations

    def post_message(self, user: User, conversation_id: int, query: str, response: str) -> int:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `messages` (conversation, prompt, response)
            VALUES (?, ?, ?)
        ''', (conversation_id, query, response))

        self.connection.commit()

        cursor.close()

        return cursor.lastrowid
    
    def create_conversation(self, user: User, title: str) -> int:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `conversations` (student_id, title)
            VALUES (?, ?)
        ''', (user.id, title))

        conversation_id: int = cursor.lastrowid

        self.connection.commit()

        cursor.close()

        return cursor.lastrowid
    
    def fetch_course(self, code: str) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT c.title, c.code, c.level, c.credits, c.description, d.name AS department
            FROM `courses` AS c
            INNER JOIN `departments` AS d ON d.id = c.department_id
            WHERE c.code = ?            
        ''', (code,))

        info = dict(cursor.fetchone())

        cursor.close()

        return info
    
    def fetch_course_name(self, name: str) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor() 

        cursor.execute('''
            SELECT c.title, c.code, c.level, c.credits, c.description, d.name AS department
            FROM `courses` AS c
            INNER JOIN `departments` AS d ON d.id = c.department_id
            WHERE c.title = ?      
        ''', (name,))

        info = dict(cursor.fetchone())

        cursor.close()

        return info
    
    def fetch_course_list(self, code: str) -> list:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT c.title, c.code, c.level, c.credits, c.description, d.name AS department
            FROM `courses` AS c
            INNER JOIN `departments` AS d ON d.id = c.department_id
            WHERE d.code = ?            
        ''', (code,))

        courses = [dict(row) for row in cursor.fetchall()]

        cursor.close()

        return courses
    
    def fetch_course_list_name(self, name: str) -> list:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT c.title, c.code, c.level, c.credits, c.description, d.name AS department
            FROM `courses` AS c
            INNER JOIN `departments` AS d ON d.id = c.department_id
            WHERE d.name = ?
        ''', (name,))

        courses = [dict(row) for row in cursor.fetchall()]

        cursor.close()

        return courses

    def fetch_department(self, code: str) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT d.name, d.code, d.description, c.name AS college, (f.prefix || '.' || f.first_name || ' ' || f.last_name) AS chair
            FROM `departments` AS d
            INNER JOIN `colleges` AS c ON d.college_id = c.id
            INNER JOIN `faculty` AS f ON f.department_id = d.id
            WHERE d.code = ? AND f.role = 'chair'
        ''', (code,))

        info = dict(cursor.fetchone())

        cursor.close()

        return info

    def fetch_department_byname(self, name: str) -> dict: 
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT d.name, d.code, d.description, c.name AS college, (f.prefix || '.' || f.first_name || ' ' || f.last_name) AS chair
            FROM `departments` AS d
            INNER JOIN `colleges` AS c ON d.college_id = c.id
            INNER JOIN `faculty` AS f ON f.department_id = d.id
            WHERE d.name = ? AND f.role = 'chair'        
        ''', (name,))

        info = dict(cursor.fetchone())

        cursor.close()

        return info
    
    def fetch_departments_list(self) -> list:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT name, code, description
            FROM `departments`
        ''')

        departments = [dict(row) for row in cursor.fetchall()]

        cursor.close()

        return departments

    def fetch_sections(self, code: str) -> list:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT s.id, c.title, c.code, s.section, c.level, c.credits, s.capacity, s.enrolled, t.name AS term, sm.start_time, sm.end_time, md.day, d.name AS department,
                (f.prefix || f.first_name || ' ' || f.last_name) AS instructor
            FROM `sections` AS s
            INNER JOIN `section_meetings` AS sm ON sm.section_id = s.id
            INNER JOIN `meeting_days` AS md ON md.meeting_id = sm.id
            INNER JOIN `courses` AS c ON s.course_id = c.id
            INNER JOIN `departments` AS d ON c.department_id = d.id
            INNER JOIN `faculty` AS f ON s.instructor_id = f.id
            INNER JOIN `term` AS t ON s.term_id = t.id
            WHERE c.code = ?
        ''', (code,))

        results: list = [dict(row) for row in cursor.fetchall()]

        test: dict = {}

        int_to_day = {
            1: 'M',
            2: 'Tu',
            3: 'W',
            4: 'Th',
            5: 'F',
            6: 'S',
            7: 'Su',
        }

        for row in results:
            id: int = row['id']

            if (test.get(id) == None):
                test[id] = {
                    'id': row['id'],
                    'title': row['title'],
                    'code': row['code'],
                    'section': row['section'],
                    'department': row['department'],
                    'instructor': row['instructor'],
                    'level': row['level'],
                    'credits': row['credits'],
                    'term': row['term'],
                    'capacity': row['capacity'],
                    'enrolled': row['enrolled'],
                    'start_time': row['start_time'],
                    'end_time': row['end_time'],
                    'days': [int_to_day[row['day']]]
                }
            else:
                test[id]['days'].append(int_to_day[row['day']])

        cursor.close()

        return list(test.values())
    
    def fetch_staff(self, first_name: str, last_name: str) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT *
            FROM `faculty` AS f
            WHERE first_name = ? AND last_name = ?
        ''', (first_name, last_name))

        info: dict = dict(cursor.fetchone())

        cursor.close()
        
        return info
    
    def fetch_department_staff(self, name: str) -> list:
        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT (f.prefix || f.first_name || ' ' || f.last_name) AS name, f.email, f.bio, f.role
            FROM `faculty` AS f
            INNER JOIN `departments` AS d ON f.department_id = d.id
            WHERE d.name = ?
        ''', (name,))

        staff: list = [dict(row) for row in cursor.fetchall()]

        cursor.close()

        return staff

    def fetch_table(self, table_name: str, offset: int, n: int, sort_by: str | None, sort_order: bool = False) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        if (table_name not in allowed_tables):
            raise ValueError('invalid table name')

        if (sort_by != None):
            cursor.execute(f'''
                SELECT * FROM `{table_name}`
                ORDER BY {sort_by} {'ASC' if sort_order else 'DESC'}
                LIMIT ?
                OFFSET ?
            ''', (n, offset))
        else:
            cursor.execute(f'''
                SELECT * FROM `{table_name}`
                LIMIT ?
                OFFSET ?
            ''', (n, offset))

        field_names = [description[0] for description in cursor.description]

        rows = cursor.fetchall()

        cursor.close()

        return {
            'fields': field_names,
            'rows': rows
        }
    
    def table_info(self, table_name: str) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        if (table_name not in allowed_tables):
            raise ValueError('invalid table name')

        cursor.execute(f'''
            PRAGMA table_info(`{table_name}`)
        ''')

        fields = cursor.fetchall()

        cursor.execute(f'''
            SELECT COUNT(*) FROM `{table_name}`            
        ''')

        row_count = dict(cursor.fetchone())['COUNT(*)']

        cursor.close()

        return {
            'count': row_count,
            'fields': [{'name': row['name'], 'type': row['type']} for row in fields], 
        }

schema = ''

with open(SCHEMA_FILE, 'r') as file:
    schema = file.read()

database: Database = Database(
    os.path.join(DATABASE_FOLDER, 'database.db'),
    schema
)

# only to be called when want to populate db
def populate_db():
    with open(POPULATE_FILE, 'r') as file:
        database.populate(file.read())


populate_db()