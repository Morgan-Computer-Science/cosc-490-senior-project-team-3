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

            print('database populated')
        except sqlite3.Error as err:
            print('failed to populate database: ', err)

    def register_user(self, data: UserRegistration) -> None:
        hash_object = hashlib.sha256(data.password.encode())
    
        digest: str = hash_object.hexdigest()

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `users` (email, first_name, last_name, password_hash, discipline, credits_earned, privilege)
            VALUES (?, ?, ?, ?, ?, ?, ?);
        ''', (data.email, data.first_name, data.last_name, digest, 'Computer Science', 0, 1))

        self.connection.commit()

    def login_user(self, data: UserLogin):
        hash_object = hashlib.sha256(data.password.encode())
        digest: str = hash_object.hexdigest()

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            SELECT * FROM `users`
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
        
        print(user_data)

    def create_session(self, user: User) -> str:
        # generate token
        token = secrets.token_urlsafe(32)

        hash_object = hashlib.sha256(token.encode())

        digest = hash_object.hexdigest()

        # 3 months until expire
        offset = timedelta(days=90)

        expires = datetime.now() + offset

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `sessions` (user_id, token_hash, expires_at)
            VALUES (?, ?, ?)         
        ''', (user.id, digest, expires))

        return digest

    def fetch_courses(self) -> list[Course]:
        cursor: sqlite3.Cursor = self.connection.cursor()
        
        cursor.execute('''
            SELECT id, title, discipline, code, credits, description 
            FROM courses 
            ORDER BY discipline, code
        ''')
        
        rows = cursor.fetchall()
        courses = []
        
        for row in rows:
            course = Course(
                id=row[0],
                title=row[1],
                discipline=row[2],
                code=row[3],
                credits=row[4],
                description=row[5]
            )
            courses.append(course)
        
        return courses
        
    def fetch_table(self, table_name: str, offset: int, n: int, sort_by: str | None, sort_order: bool = False) -> dict:
        cursor: sqlite3.Cursor = self.connection.cursor()

        valid_tables: list = ['users', 'gpa', 'sessions', 'courses', 'prerequisites', 'appointments', 'chat_logs']

        if (table_name not in valid_tables):
            raise ValueError('invalid table name')

        if (sort_by != None):
            cursor.execute(f'''
                SELECT * FROM `{table_name}`
                ORDER BY ? {'ASC' if sort_order else 'DESC'}
                LIMIT ?
                OFFSET ?
            ''', (sort_by, n, offset))
        else:
            cursor.execute(f'''
                SELECT * FROM `{table_name}`
                LIMIT ?
                OFFSET ?
            ''', (n, offset))

        field_names = [description[0] for description in cursor.description]

        rows = cursor.fetchall()

        print(rows)

        return {
            'fields': field_names,
            'rows': rows
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
