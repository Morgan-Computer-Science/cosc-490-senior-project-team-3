from typing import Annotated
from fastapi import APIRouter, Form, Request, Response, status
from fastapi.responses import RedirectResponse

from lib.types import UserRegistration, UserLogin, User
from lib.database import database

router = APIRouter()

@router.post("/signup", name="signup_endpoint")
async def signup(data: Annotated[UserRegistration, Form()]) -> None:
    if (data.password != data.confirm_password):
        return False
    
    user: User = database.register_user(data)

    # create login session

    token: str = database.create_session(user)

    response = RedirectResponse(url='/dashboard', status_code=status.HTTP_303_SEE_OTHER)

    response.set_cookie(
        key='session_token', 
        value=token,
        samesite='lax',
        httponly=True,
        secure=False # temp for local testing, for production set to true
    )

    return response
    
@router.post("/login", name="login_endpoint")
async def login(data: Annotated[UserLogin, Form()]):
    success, reason = database.login_user(data)

    if (success == False):
        return reason
    
    user = reason

    token = database.create_session(user)

    response = RedirectResponse(url='/dashboard', status_code=status.HTTP_303_SEE_OTHER)

    response.set_cookie(
        key='session_token', 
        value=token,
        samesite='lax',
        httponly=True,
        secure=False
    )

    return response