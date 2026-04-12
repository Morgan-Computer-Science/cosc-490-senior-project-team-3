import os

from lib.query import query_gemini

with open('./data/cs_courses.json', 'r') as f:
    data = f.read()

query = '''
Given the following data, I have currently completed:
ENGL 111, MATH 241, MATH 242, MATH 312, COSC 111, COSC 112, COSC 220 

Please give me a schedule recommendation for the next semester.
I am aiming to have a balanced workload that will not overwhelm me. 

I want to take Computer Networks so please include that class and any other classes that balance around that.

here is the list of courses that are available formatted in JSON
''' 

query += data

response = query_gemini(query)

print(response.text)
