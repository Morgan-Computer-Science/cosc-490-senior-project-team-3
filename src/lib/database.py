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
database: sqlite3.Connection = sqlite3.connect(os.path.join(DATABASE_FOLDER, 'database.db'))

# initialize blank database
def db_init() -> None:
    # fetch database schema
    schema: str = ''

    with open(SCHEMA_FILE, 'r') as file:
        schema = file.read()

    try:
        cursor: sqlite3.Cursor = database.cursor()

        cursor.executescript(schema)

        print('Success initialization databse.')
    except sqlite3.Error as err:
        print('Failure to initialize database.', err)

    # populate the database t

    populate: str = ''

    with open(POPULATE_FILE, 'r') as file:
        populate = file.read()

    try: 
        cursor: sqlite3.Cursor = database.cursor()

        cursor.executescript(populate)

        print('Success populating the database.')
    except sqlite3.Error as err:
        print('Failed to populate database.', err)

def register_user(data: UserRegistration) -> None:
    hash_object = hashlib.sha256(data.password.encode())
    
    digest: str = hash_object.digest()

    cursor: sqlite3.Cursor = database.cursor()

    cursor.execute('''
        INSERT INTO `users` (email, first_name, last_name, password_hash, discipline, credits_earned, privilege)
        VALUES (?, ?, ?, ?, ?, ?, ?);
    ''', (data.email, data.first_name, data.last_name, digest, 'Computer Science', 0, 1))

    database.commit()

    # INSERT INTO `users` (email, first_name, last_name, discipline, credits_earned, gpa, privilege)
    # VALUES ('test@example.com', 'user', 'first', 'last', 'Computer Science', 70, 3.95, 1);

def login_user(data: UserLogin):
    hash_object = hashlib.sha256(data.password.encode())

    digest: str = hash_object.digest()

def fetch_table(table_name: str, offset: int, n: int, sort_by: str | None, sort_order: bool = False) -> dict:
    cursor: sqlite3.Cursor = database.cursor()

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

    print('field names: ', field_names)

    rows = cursor.fetchall()

    return {
        'fields': field_names,
        'rows': rows
    }