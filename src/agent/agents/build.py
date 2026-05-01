from google.adk.agents import llm_agent
from google.genai import types

from agent.agents.config import llm_model
from agent.agent import AgentClass
from agent.tools.user import get_user_stats

generation_config = types.GenerateContentConfig(
    temperature=0.25,
    max_output_tokens=10000,
    top_p=0.95
)

schedule_builder = AgentClass(llm_agent.LlmAgent(
    name='schedule_builder',
    model=llm_model,
    generate_content_config=generation_config,
    description=(
        'Agent specializes in building / generating course schedules for college/university students.'
    ),
    sub_agents=[],
    instruction='''
        Given a list of university requirements, student's academic transcript and student input, build a schedule plan for a following semester. 
        
        Use the following courses: 
        COSC 111 - Introduction to Computer Science I 4 credits *
        COSC 112 - Introduction to Computer Science II 4 credits
        COSC 220 - Data Structures and Algorithms 4 credits
        COSC 241 - Computer Systems and Digital Logic 3 credits
        COSC 281 - Discrete Structure 3 credits
        COSC 349 - Computer Networks 3 credits
        COSC 351 - Cybersecurity 3 credits
        COSC 352 - Organization of Programming Languages 3 credits
        COSC 354 - Operating Systems 3 credits
        COSC 458 - Software Engineering 3 credits
        COSC 459 - Database Design 3 credits
        COSC 490 - Senior Project 3 credits
        COSC 238 - Object Oriented Programming 4 credits
        COSC 239 - Java Programming 3 credits
        COSC 243 - Computer Architecture 3 credits
        COSC 251 - Introduction to Data Science 3 credits
        CLCO 261 - Introduction to Cloud Computing 3 credits
        
        MATH 241 - Calculus I 4 credits *
        MATH 242 - Calculus II 4 credits
        MATH 312 - Linear Algebra I 3 credits
        MATH 331 - Applied Probability and Statistics 3 credits

        ENGL 101 - Composition I 3 credits EC
        ENGL 111 - Composition I—Honors 3 credits EC
        ENGL 102 - Composition II 3 credits (EC)
        ENGL 112 - Composition II—Honors 3 credits (EC)

        For COSC use the following professors: 
            Dr. Radhouane Chouchane
            Dr. Amjad Ali
            Monireh Dabaghchian
            Dr. Jamell Dacon
            Dr. Jin Guo
            Dr. Guobin Xu
            Dr. Vahid Heydari
            Dr. Naja Mack
            Dr. Roshan Paudel
            Dr. Vojislav Stojkovic
        
        All other courses you may generate professor names.

        All classes must be between 8:00AM and 5:00PM

        Use the 'get_user_stats' tool to pull student's statistics and academic history. 

        Output as JSON in the following format: 

        {
            term: "Fall 2026",
            rationale: "This plan keeps you on track for graduation while targeting your ML interest. CS 421 and CS 461 are major requirements — both fit cleanly into your morning slots. STAT 432 double-counts toward the Stats minor and your CS technical elective. ENG 300 satisfies your writing requirement. Friday is intentionally light (one class) to give you a research/internship buffer.",
            totalCredits: 15,
            preferences: ["Morning bias", "Light Fridays", "ML focus"],
            courses: [
                {
                    code: "CS 421", name: "Programming Languages & Compilers",
                    credits: 3, instructor: "Prof. Vasilakis",
                    days: ["M", "W", "F"], startMin: 90, durationMin: 50, // 9:30-10:20
                    colorClass: "c1",
                    note: "Required for major"
                },
                {
                    code: "CS 461", name: "Computer Security",
                    credits: 3, instructor: "Prof. Bates",
                    days: ["T", "R"], startMin: 180, durationMin: 75, // 11:00-12:15
                    colorClass: "c4",
                    note: "Required for major"
                },
                {
                    code: "STAT 432", name: "Basics of Statistical Learning",
                    credits: 3, instructor: "Prof. Wong",
                    days: ["M", "W"], startMin: 360, durationMin: 75, // 2:00-3:15
                    colorClass: "c3",
                    note: "Counts toward CS + Stats minor"
                },
                {
                    code: "STAT 425", name: "Applied Regression & Design",
                    credits: 3, instructor: "Prof. Liang",
                    days: ["T", "R"], startMin: 510, durationMin: 75, // 4:30-5:45
                    colorClass: "c5",
                    note: "Stats minor requirement"
                },
                {
                    code: "ENG 300", name: "Tech Writing for Engineers",
                    credits: 3, instructor: "Dr. Reyes",
                    days: ["M", "W"], startMin: 540, durationMin: 50, // 5:00-5:50
                    colorClass: "c2",
                    note: "Writing requirement"
                },
            ]
            };
    ''',
    tools=[get_user_stats]
)) 