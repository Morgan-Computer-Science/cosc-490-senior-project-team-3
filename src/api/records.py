from fastapi import Request

from api.router import router
from lib.util import clamp
from lib.database import fetch_table

N_LIMIT = 80
N_DEFAULT = 20

@router.get('/records')
async def fetch_records(request: Request) -> None:
    query_params = request.query_params

    table_name: str = query_params.get('table')
    offset: int = query_params.get('offset') or 0
    n: int = clamp(int(query_params.get('n')) or N_DEFAULT, 1, N_LIMIT)

    data = fetch_table(table_name, offset, n)

    return data