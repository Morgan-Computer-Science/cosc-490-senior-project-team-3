import os
from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

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

@router.post("/login")
async def post_login(request):
    print('login attempted')

@router.get("/signup", name="signup")
async def get_signup(request: Request):
    return templates.TemplateResponse(
        request=request,
        name='signup.html'
    )

@router.get("/dashboard", name="dashboard")
async def get_dashboard(request: Request):
    # session stuff

    return templates.TemplateResponse(
        request=request,
        name='dashboard.html'
    )

@router.get("/panel", name="admin-panel")
async def get_panel(request: Request):
    return templates.TemplateResponse(
        request=request,
        name='panel.html'
    )