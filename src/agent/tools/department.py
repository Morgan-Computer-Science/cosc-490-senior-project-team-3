from lib.database import database

def department_info(code: str) -> dict:
    '''Returns information about a department given it's code. It provides information such as department name, description, and department staff like the chair

    Args:
        code (str): The code of the department for which information is needed. (EX: COSC, MATH)

    Returns:
        dict: A dictonary containing information about the department, name, description
    '''

    return database.fetch_course(code)

def department_info_name(name: str) -> dict:
    '''Returns information about a department given it's name. It provides information such as department name, description, and department staff like the chair
    
    Args:
        name (str): The name of the department for which information is needed. (EX: Computer Science)

    Returns:
        dict: A dictionary containing information about the department, name, description
    '''

    return database.fetch_department_byname(name)

def department_list() -> list:
    '''Returns a list of departments.

    Args: N/A

    Returns:
        list: A list of dictionaries containing information about departments, include: name, code, description    
    '''

    return database.fetch_departments_list()

def staff_info(first_name: str, last_name: str, prefix: str = '') -> dict:
    '''Returns information about a staff member
    
    Args:
        first_name (str): First name of staff member
        last_name (str): Last name of staff member
        prefix (str, optional): Name prefix such as: Mr, Ms, Dr
    
    Returns:
        dict: A dictionary containing information about the queried staff member, including full name, department, and a biography (optional)    
    '''

    return database.fetch_staff(first_name, last_name)

def department_staff(name: str) -> list:
    '''Returns a list of staff given a department name
    
    Args: 
        name (str): The name of the department for which we want a list of staff. (EX: Computer Science)

    Returns:
        list: A list of staff from the queried department.
    '''

    return database.fetch_department_staff(name) 