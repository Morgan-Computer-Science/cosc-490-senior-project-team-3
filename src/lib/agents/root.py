from google.adk.agents import llm_agent

from lib.agents.config import llm_model, generation_config
from lib.agents.advisor import academic_advisor

root_agent = llm_agent.LlmAgent(
    name='root_agent',
    model=llm_model,
    generate_content_config=generation_config,
    description=(
        'The role of this agent is to provide students with general academic support \nsuch as answering questions about certain courses in the department. For more specialized support in creating course plans, query the Academic Advisor subagent. '
    ),
    sub_agents=[academic_advisor],
    instruction='Answer questions about courses or general department knowledge provided to you below:\n\n',
    tools=[],
)
