from google.adk.agents import llm_agent

from agent.agents.config import llm_model, generation_config
from agent.agent import AgentClass

title_gen = AgentClass(llm_agent.LlmAgent(
    name='title_gen',
    model=llm_model,
    generate_content_config=generation_config,
    description=(
        'Agent generates titles for chat bot conversations.'
    ),
    sub_agents=[],
    instruction='Given a sample question asked to a chatbot, generate an appropriate title for a conversation, max 255 characters in length. Output as a single string',
    tools=[],
))