from lib.database import database

def course_info(code: str) -> dict:
    '''Returns information about a course and sections for when the course is offered given it's code.

    Args:
        code (str): The code of the course for which information is needed. (EX: COSC 111)

    Returns:
        dict: A dictionary containing information about the course such as title, credits, level, description, and a list of sections for when this course is offered across various terms.
    '''

    return {
        'information': database.fetch_course(code),
        'sections': database.fetch_sections(code)
    }

def course_info_name(name: str) -> dict:
    '''Returns information about a course given it's name.

    Args:
        code (str): The name of the course for which information is needed. (EX: Introduction to Computer Science I, Computer Ethics)

    Returns:
        dict: A dictionary containing information about the course such as title, credits, level, description.
    '''

    return database.fetch_course_name(name)

def courses_by_department(code: str) -> list:
    '''Returns a list of courses given a department code.

    Args:
        code (str): The code of the department for which a list of courses is needed. (EX: COSC, MATH, ENGL)

    Returns:
        list: A list of dictonaries containing individual course information.
    '''

    return database.fetch_course_list(code)

def courses_by_department_name(name: str) -> list:
    '''Returns a list of courses given a department name.

    Args:
        name (str): The name of the department for which a list of courses is needed. (EX: Computer Science, Mathematics)

    Returns:
        list: A list of dictionaries containing individual course information.
    '''

    return database.fetch_course_list_name(name)