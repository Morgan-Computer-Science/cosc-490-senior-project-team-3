from fastapi import Request

from api.router import router
from lib.agent import agent

@router.get('/query')
async def query_agent(query: str):
    response = await agent.query(query)

    response = response['content']['parts']
    
    print('/agent ')

    return response