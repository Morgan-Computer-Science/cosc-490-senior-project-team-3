from google.adk import Agent
from google.adk.planners import BuiltInPlanner
from google.genai import types

import vertexai

vertexai.init(
  project='project-d4c985c2-9db2-4bb7-a6c',
  location='us-central1'
)

my_agent = Agent(
    model="gemini-flash-latest",
    planner=BuiltInPlanner(
        thinking_config=types.ThinkingConfig(
            include_thoughts=True,
            thinking_budget=1024,
        )
    ),
    # ... your tools here
)
