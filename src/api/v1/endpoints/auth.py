from typing import Annotated
from fastapi import APIRouter, Form

from lib.types import UserRegistration, UserLogin
from lib.database import database

router = APIRouter()

@router.post("/signup", name="signup_endpoint")
async def signup(data: Annotated[UserRegistration, Form()]) -> None:
    if (data.password != data.confirm_password):
        return False
    
    database.register_user(data)
    
@router.post("/login", name="login_endpoint")
async def login(data: Annotated[UserLogin, Form()]):
    print('/api/v1/login', data)
    success = database.login_user(data)
    pass

@router.get("/courses", name="courses_endpoint")
async def get_courses():
    return database.fetch_courses()
