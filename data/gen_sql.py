import os 
import json

__dir__ = os.path.dirname(__file__)

with open(os.path.join(__dir__, 'cs_courses.json'), 'r') as file:
    cs_data = json.loads(file.read())

    id = 0

    for course in cs_data:
        discipline, code = course['code'].split(' ')

        id += 1

        print(f'({id}, \'{course['title']}\', \'{discipline}\', {code}, {course['credits']}),')