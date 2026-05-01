from lib.database import database
from lib.types import User

target_user = None

def set_target_user(user: User):
    global target_user
    target_user = user

def get_user_stats() -> dict:
    '''Pulls academic statistics of the current user such as GPA, courses they are currently enrolled in and past courses they have taken in their academic career.

    Args: N/A

    Returns: 
        dict: A dictionary containing statistics and information about the user.
    '''
    global target_user

    credits: int = database.fetch_credits(target_user)
    gpa: int = database.fetch_semester_gpa(target_user, 9)
    
    enrolled: dict = database.fetch_enrolled(target_user)
    history: list = database.fetch_course_history(target_user)

    return {
        'gpa': gpa,
        'credits': credits,
        'enrolled': enrolled,
        'history': history
    }