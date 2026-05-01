import os
from fastapi import APIRouter, Request, status
from fastapi.templating import Jinja2Templates
from fastapi.responses import RedirectResponse

from lib.database import database

router = APIRouter()

TEMPLATE_DIR: str = os.path.dirname(__file__)

templates = Jinja2Templates(directory=TEMPLATE_DIR)

@router.get("/")
async def get_landing(request: Request):
    return templates.TemplateResponse(
        request=request,
        name='home.html',
    )

@router.get("/login", name="login")
async def get_login(request: Request):
    return templates.TemplateResponse(
        request=request,
        name='login.html'
    )

@router.get("/signup", name="signup")
async def get_signup(request: Request):
    return templates.TemplateResponse(
        request=request,
        name='signup.html'
    )

def logged_in(request: Request) -> bool:
    token: str | None = request.cookies.get('session_token')

    if token == None:
        return False

    if database.validate_session(token) == None :
        return False
    
    return True

@router.get("/dashboard", name="dashboard")
async def get_dashboard(request: Request):
    # session stuff
    if logged_in(request) == False:
        return RedirectResponse(url='/login')

    return templates.TemplateResponse(
        request=request,
        name='dashboard.html'
    )

@router.get('/chat', name='chat')
async def get_chat(request: Request):
    if logged_in(request) == False:
        return RedirectResponse(url='/login')
    
    return templates.TemplateResponse(
        request=request,
        name='chat.html'
    )

@router.get('/courses', name='courses')
async def get_courses(request: Request):
    if logged_in(request) == False:
        return RedirectResponse(url='/login')
    
    return templates.TemplateResponse(
        request=request,
        name='courses.html'
    )

@router.get('/build', name='build')
async def get_builder(request: Request):
    if logged_in(request) == False:
        return RedirectResponse(url='/login')
    
    return templates.TemplateResponse(
        request=request,
        name='builder.html'
    )

@router.get('/settings', name='settings')
async def get_settings(request: Request):
    if logged_in(request) == False:
        return RedirectResponse(url='/login')
    
    return templates.TemplateResponse(
        request=request,
        name='settings.html'
    )

@router.get('/help', name='help')
async def get_help(request: Request):
    if logged_in(request) == False:
        return RedirectResponse(url='/login')
    
    return templates.TemplateResponse(
        request=request,
        name='help.html'
    )

@router.get("/panel", name="admin-panel")
async def get_panel(request: Request):
    return templates.TemplateResponse(
        request=request,
        name='panel.html'
    )