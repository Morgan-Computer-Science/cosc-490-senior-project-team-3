from fastapi import APIRouter
from typing import Union

from lib.util import clamp
from lib.database import database

N_LIMIT = 80
N_DEFAULT = 20

router = APIRouter()

@router.get('/records')
async def fetch_records(table: str, offset: int = 0, n: int = N_DEFAULT, sort_by: Union[str, None] = None, sort_order: Union[bool, None] = False):
    n = clamp(n, 1, N_LIMIT)

    # print('/records :', table, offset, n, sort_by, sort_order)
    
    data = database.fetch_table(table, offset, n, sort_by, sort_order)

    return data