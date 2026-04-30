import sqlite3
import hashlib
import os

from typing import Annotated

from lib.types import UserRegistration, UserLogin, Course

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
    ''',(data.email, data.first_name, data.last_name, digest, 'Computer Science', 0, 1))

    database.commit()

    print('user registered in db')

    # INSERT INTO `users` (email, first_name, last_name, discipline, credits_earned, gpa, privilege)
    # VALUES ('test@example.com', 'user', 'first', 'last', 'Computer Science', 70, 3.95, 1);

def fetch_courses() -> list[Course]:
    cursor: sqlite3.Cursor = database.cursor()
    
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