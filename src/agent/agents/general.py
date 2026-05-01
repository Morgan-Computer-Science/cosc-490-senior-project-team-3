from google.adk.agents import llm_agent

from agent.agents.config import llm_model, generation_config
# from agent.agents.advisor import academic_advisor
from agent.agent import AgentClass
from agent.tools.course import course_info, course_info_name, courses_by_department, courses_by_department_name
from agent.tools.department import department_info, department_info_name, department_list, staff_info, department_staff
from agent.tools.user import get_user_stats


root_agent = AgentClass(llm_agent.LlmAgent(
    name='root_agent',
    model=llm_model,
    generate_content_config=generation_config,
    description=(
        'The role of this agent is to provide students with general academic support \nsuch as answering questions about certain courses in the department. For more specialized support in creating course plans, query the Academic Advisor subagent. '
    ),
    sub_agents=[],
    instruction='''Answer questions about courses, departments, colleges, or general questions about the Morgan State University system. Here is a good output formatting example for course info:
        **Course Title:** Computer Ethics
        **Course Code:** COSC 220
        **Credits:** 4
        **Department:** Computer Science
        **Level:** 200

        Data Structures and Algorithms. Fundamental data structures and the algorithms that act on them: strings, lists, arrays, stacks, queues, dictionaries, maps, trees, and graphs. Insertion, deletion, traversal, searching, and sorting algorithms with corresponding time and space complexity analysis. Three lecture hours and one lab hour. Prerequisite: COSC 112 with a grade of C or better. Offered Fall and Spring.

        # Available Sections:
        If no avaliable sections, exclude this part

        **Fall 2024**
        *   **Fall 2024, Section 001**: Taught by Dr. Sam Tannouri, M/W/F from 09:00 - 09:50. (33/35 enrolled)

        **Fall 2025**
        *   **Fall 2025, Section 001**: Taught by Dr. Sam Tannouri, M/W/F from 09:00 - 09:50. (33/35 enrolled)
        *   **Fall 2025, Section 002**: Taught by Ms. Grace Steele, M/W/F from 11:00 - 11:50. (30/35 enrolled)
        *   **Fall 2025, Section W01**: Taught by Dr. Sam Tannouri, M from 00:01 - 23:59. (28/30 enrolled)
        
        **Spring 2026**
        *   **Spring 2026, Section 001**: Taught by Ms. Grace Steele, M/W/F from 10:00 - 10:50. (30/35 enrolled)
        *   **Spring 2026, Section W01**: Taught by Dr. Sam Tannouri, M from 00:01 - 23:59. (24/30 enrolled)

        Frequently Asked Questions:
        
        Q: How do I request a course override? 
        A: To request an override you should get in contact with your assigned advisor to determine if you are eligible for an override.

        Q: Who is in charge of the HAX lab at morgan state university?
        A: Dr. Naja Mack is the staff in charge of the HAX lab at morgan state university.
    ''',
    tools=[
        course_info,
        course_info_name,
        courses_by_department,
        courses_by_department_name,
        department_info,
        department_info_name,
        department_list,
        department_staff,
        staff_info,
        get_user_stats
    ],
))