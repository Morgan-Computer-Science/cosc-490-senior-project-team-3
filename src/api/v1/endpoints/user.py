from fastapi import APIRouter, Request, Response, status

from lib.types import User
from lib.database import database

router = APIRouter()

@router.get('/user_stats')
async def fetch_stats(request: Request, response: Response):
    token: str = request.cookies.get('session_token')

    user: User = database.validate_session(token)

    if (user == None):
        response.status_code = status.HTTP_401_UNAUTHORIZED
        
        return 'forbidden'
    
    # gpa: float = database.fetch_gpa(user)
    credits: int = database.fetch_credits(user)
    enrolled: dict = database.fetch_enrolled(user)
    history: list = database.fetch_course_history(user)

    gpa: dict = {}

    for i in range(1, 9):
        gpa[i] = database.fetch_semester_gpa(user, i)

    return {
        'first_name': user.first_name,
        'last_name': user.last_name,
        'email': user.email,
        'gpa': gpa,
        'credits': credits,
        'enrolled': enrolled,
        'history': history
    }