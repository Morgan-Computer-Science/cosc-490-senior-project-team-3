import json

from fastapi import APIRouter, Request, Body

from lib.types import User, Query
from lib.database import database

from agent.agents.general import root_agent
from agent.agents.advisor import academic_advisor
from agent.agents.title_gen import title_gen
from agent.agents.build import schedule_builder

from agent.tools.user import set_target_user

router = APIRouter()

@router.get('/conversation')
async def get_messages(request: Request):
    token: str = request.cookies.get('session_token')

    if (token == None):
        return

    user: User = database.validate_session(token)

    if (user == None):
        return
    
    conversation_id = request.query_params.get('id')
    
    data = database.fetch_conversation(user, conversation_id)
    
    return data

@router.post('/query')
async def process_msg(request: Request, body: str = Body(...)):
    token: str = request.cookies.get('session_token')

    if (token == None):
        return
    
    user: User = database.validate_session(token)

    if (user == None):
        return
    
    payload = json.loads(body)

    conversation_id: int = payload['id']
    query: str = payload['msg']

    set_target_user(user)

    if (payload['agent'] == 'advising'):

        response = await academic_advisor.query(query)
    else:
        response = await root_agent.query(query)

    # content = response['content']['parts'][0]['text']

    id: int = database.post_message(user, conversation_id, query, response)

    return {
        'id': id,
        'response': response
    }

@router.post('/create')
async def process_msg(request: Request, body: str = Body(...)):
    token: str = request.cookies.get('session_token')

    if (token == None):
        return
    
    user: User = database.validate_session(token)

    if (user == None):
        return
    
    payload = json.loads(body)

    query: str = payload['msg']

    title = await title_gen.query(query)

    set_target_user(user)

    if (payload['agent'] == 'advising'):
        response = await academic_advisor.query(query)
    else:
        response = await root_agent.query(query)

    conv_id: int = database.create_conversation(user, title)

    msg_id: int = database.post_message(user, conv_id, query, response)

    return {
        'conversation_id': conv_id,
        'msg_id': msg_id,
        'response': response
    }

@router.post('/build')
async def build(request: Request, body: str = Body(...)):
    token: str = request.cookies.get('session_token')

    if (token == None):
        return
    
    user: User = database.validate_session(token)

    if (user == None):
        return
    
    payload = json.loads(body)

    query: str = payload['msg']

    set_target_user(user)

    response = await schedule_builder.query(query)

    opening_bracket_index: int = response.find('{')
    closing_bracket_idx: int = response.rfind('}')

    output: str = response[opening_bracket_index:closing_bracket_idx + 1]

    return json.loads(output)

@router.get('/conversations')
async def get_conversations(request: Request):
    token: str = request.cookies.get('session_token')

    if (token == None):
        return
    
    user: User = database.validate_session(token)

    if (user == None):
        return
    
    conversations = database.fetch_convo_list(user)

    return conversations
    