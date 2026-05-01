from fastapi import APIRouter, Request, Response
from typing import Union

from lib.util import clamp
from lib.database import database

N_LIMIT = 80
N_DEFAULT = 20

router = APIRouter()

@router.get('/records')
async def fetch_records(table: str, offset: int = 0, n: int = N_DEFAULT, sort_by: Union[str, None] = None, sort_order: Union[bool, None] = False):
    n = clamp(n, 1, N_LIMIT)

    data = database.fetch_table(table, offset, n, sort_by, sort_order)

    return data

@router.get('/table_info')
async def table_info(table: str):
    data = database.table_info(table)

    return data

# @router.get('/user_stats', name="fetch_user_stats_endpoint")

# async def fetch_user_stats(request: Request, response: Response):
#     session_token = request.cookies.get('session_token')

#     if (session_token == None):
#         return None
    
#     user_data = database.validate_session(session_token)

#     if (user_data == None):
#         return None
