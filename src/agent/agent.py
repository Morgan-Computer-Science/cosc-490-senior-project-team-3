import vertexai

from google.genai import types
from google.adk.agents import Agent, llm_agent
from google.adk.sessions import vertex_ai_session_service
from vertexai.agent_engines import AdkApp
# from vertexai.preview.reasoning_engines import AdkApp

# from agents.root import root_agent
from agent.agents.root import root_agent

PROJECT_ID = 'project-d4c985c2-9db2-4bb7-a6c'
LOCATION = 'us-central1'

# auth
vertexai.init(
    project=PROJECT_ID,
    location=LOCATION
)

llm_model = 'gemini-2.5-flash'

VertexAiSessionService = vertex_ai_session_service.VertexAiSessionService

generation_config = types.GenerateContentConfig(
    temperature=0.25,
    max_output_tokens=2500,
    top_p=0.95
)

class AgentClass:
    def __init__(self):
        self.app = None

    def session_service_builder(self):
        return VertexAiSessionService()
    
    def set_up(self):
        # academic_advisor = llm_agent.LlmAgent(
        #     name='academic_advisor',
        #     model=llm_model,
        #     description=(
        #         'Specialized sub-agent to play the role of an academic advisor such as creating semester plans for students and '
        #     ),
        #     sub_agents=[],
        #     instruction='Create semester plans based on degree requirements, student\'s completed courses, and any input from the user. Degree requirements are below:\n\nBachelor of Science:\n\n- Minimum of 120 Credits Required\n- You meet the minimum overall 2.0 GPA requirement.\n- University Requirements\n- General Education Program Requirements\n- Major Requirements\n- Natural Science Complementary Studies Requirement\n- Free Electives\n\nGeneral Education and University Requirements 44 credits\nIn order to satisfy General Education Requirements, students must complete the courses listed below:\n\nENGL 101 - Composition I 3 credits EC\nOR\nENGL 111 - Composition I—Honors 3 credits EC\n \nENGL 102 - Composition II 3 credits (EC)\nOR\nENGL 112 - Composition II—Honors 3 credits (EC)\n \nMATH 241 - Calculus I 4 credits MQ*\nXXXX - HH General Education Req. 3 credits HH\nCOSC 111 - Introduction to Computer Science I 4 credits IM*\nXXXX - AH General Education Req. 3 credits AH\nXXXX - AH General Education Req. 3 credits AH\nXXXX - BP General Education Req. 4 credits with lab BP\nXXXX - BP General Education Req. 3 credits no lab req. BP\nXXXX - SB General Education Req. 3 credits SB\nXXXX - SB General Education Req. 3 credits SB\nXXXX - XXXX - CI General Education Req. 3 credits CI\nXXXX - CT General Education Req. 3 credits CT\nORNS 106 - Freshman Orientation for Majors in the School of Computer, Mathematical and Natural Sciences 1 credits\nXXXX - Phys. Activity or FIN 101 or MIND 101 1 credit\nNote\n\n* denotes a department required supporting/major course which may fulfill a general education requirement and must be completed with a grade of “C” or higher\n\nPlease see General Education Requirements Distribution Areas for courses that satisfy General Education Requirements where not specified by the department\n\nSupporting Courses 11 credits\nMATH 241 - Calculus I 4 credits *\nMATH 242 - Calculus II 4 credits\nMATH 312 - Linear Algebra I 3 credits\nMATH 331 - Applied Probability and Statistics 3 credits\nCOSC 201 - Computer Ethics 1 credits\nRequired Courses for Computer Science Major 65 credits\nIn order to satisfy Computer Science Major Requirements, students must complete the courses listed below with grades of “C” or higher.\n\nCOSC 111 - Introduction to Computer Science I 4 credits *\nCOSC 112 - Introduction to Computer Science II 4 credits\nCOSC 220 - Data Structures and Algorithms 4 credits\nCOSC 241 - Computer Systems and Digital Logic 3 credits\nCOSC 281 - Discrete Structure 3 credits\nCOSC 349 - Computer Networks 3 credits\nCOSC 351 - Cybersecurity 3 credits\nCOSC 352 - Organization of Programming Languages 3 credits\nCOSC 354 - Operating Systems 3 credits\nCOSC 458 - Software Engineering 3 credits\nCOSC 459 - Database Design 3 credits\nCOSC 490 - Senior Project 3 credits\nXXXX - COSC Group A Elective 3 credits1\nXXXX - COSC Group A Elective 3 credits1\nXXXX - COSC Group A Elective 3 credits1\nXXXX - COSC Group B Elective 3 credits2\nXXXX - COSC Group B Elective 3 credits2\nXXXX - COSC Group C Elective 3 credits3\nXXXX - COSC Group C Elective 3 credits3\nXXXX - COSC Group C Elective 3 credits3\nXXXX - COSC Group C Elective 3 credits3\nXXXX - COSC Group D Elective 3 credits4\nNote\n\n* denotes a department required supporting/major course which may fulfill a general education requirement and must be completed with a grade of “C” or higher\n\n1 COSC Group A Electives must be three (3) courses chosen from the Group A Electives listed\n\n2 COSC Group B Electives must be three (3) courses chosen from the Group B Electives listed\n\n3 COSC Group C Electives must be three (3) courses chosen from the Group C Electives listed\n\n4 COSC Group D Elective must be one (1) course chosen from the Group D Electives listed\n\nTOTAL 120\nComputer Science Electives\nGroup A Electives\n\nStudents must choose three (3) courses.\n\nCOSC 238 - Object Oriented Programming 4 credits\nCOSC 239 - Java Programming 3 credits\nCOSC 243 - Computer Architecture 3 credits\nCOSC 251 - Introduction to Data Science 3 credits\nCLCO 261 - Introduction to Cloud Computing 3 credits\nGroup B Electives\n\nStudents must choose two (2) courses.\n\nCOSC 320 - Algorithm Design and Analysis 3 credits\nCOSC 323 - Introduction to Cryptography 3 credits\nCOSC 332 - Introduction to Game Design and Development 3 credits\nCOSC 338 - Mobile App Design & Development 3 credits\nCOSC 383 - Numerical Methods and Programming 3 credits\nCOSC 385 - Theory of Languages and Automata 3 credits\nCOSC 386 - Introduction to Quantum Computing 3 credits\nMATH 313 - Linear Algebra II 3 credits\nEEGR 317 - Electronic Circuits 4 credits\nGroup C Electives\n\nStudents must choose four (4) courses.\n\nCOSC 470 - Artificial Intelligence 3 credits\nOR\nCOSC 472 - Introduction to Machine Learning 3 credits\n \nCOSC 460 - Computer Graphics 3 credits\nCOSC 480 - Introduction to Image Processing and Analysis 3 credits\nCOSC 486 - Applied Quantum Computing 3 credits\nCOSC 491 - Conference Course 3 credits\nCOSC 498 - Senior Internship 3 credits\nCOSC 499 - Senior Research or Teaching/Tutorial Assistantship 3 credits\nCLCO 471 - Data Analytics in Cloud 3 credits\nGroup D Electives\n\nStudents must choose one (1) course.\n\nINSS 391 - IT Infrastructure and Security 3 credits\nINSS 494 - Information Security and Risk Management 3 credits\nEEGR 481 - Introduction to Network Security 3 credits\nEEGR 483 - Introduction to Security Management 3 credits\nXXXX - 300 - 400 level COSC Course (not previously taken) 3 credits​',
        #     tools=[],
        # )
        # root_agent = llm_agent.LlmAgent(
        #     name='General',
        #     model=llm_model,
        #     description=(
        #         'The role of this agent is to provide students with general academic support \nsuch as answering questions about certain courses in the department. For more specialized support in creating course plans, query the Academic Advisor subagent. '
        #     ),
        #     sub_agents=[academic_advisor],
        #     instruction='Answer questions about courses or general department knowledge provided to you below:\n\n',
        #     tools=[],
        # )

        self.app = AdkApp(
            agent=root_agent
            # session_service_builder=self.session_service_builder
        )

    async def stream_query(self, query: str, user_id: str = 'test'):
        async for chunk in self.app.async_stream_query(
            user_id=user_id,
            message=query
        ):
            yield chunk

    async def query(self, query: str):
        async for response in self.stream_query(query):
            return response

agent = AgentClass()

agent.set_up()
