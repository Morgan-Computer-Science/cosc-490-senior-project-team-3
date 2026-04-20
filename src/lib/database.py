import sqlite3
import hashlib
import os

from typing import Annotated

from lib.types import UserRegistration, UserLogin

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
    
        digest: str = hash_object.digest()

        cursor: sqlite3.Cursor = self.connection.cursor()

        cursor.execute('''
            INSERT INTO `users` (email, first_name, last_name, password_hash, discipline, credits_earned, privilege)
            VALUES (?, ?, ?, ?, ?, ?, ?);
        ''', (data.email, data.first_name, data.last_name, digest, 'Computer Science', 0, 1))

        database.commit()

    def login_user(self, data: UserLogin):
        hash_object = hashlib.sha256(data.password.encode())

        digest: str = hash_object.digest()

        


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