import re

from typing import Annotated
from fastapi import APIRouter, Request, Form
from pydantic import BaseModel, Field

from lib.types import UserRegistration, UserLogin
from lib.database import register_user


VERSION = 'v1'

router = APIRouter(prefix=f'/api/{VERSION}')

@router.post("/signup", name="signup_endpoint")
async def signup(data: Annotated[UserRegistration, Form()]) -> None:
    if (data.password != data.confirm_password):
        return False
    
    register_user(data)
    
    
@router.post("/login", name="login_endpoint")
async def login(data: Annotated[UserLogin, Form()]):
    pass

import api.records
import api.query