from fastapi import Request

from api.router import router

@router.get('/records')
async def fetch_records(request: Request) -> None: 
    print(request)