import os

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from pages.router import router as pagerouter
from api.router import router as apirouter
from lib.query import query_gemini
from lib.database import db_init

app: FastAPI = FastAPI()

# STATIC_DIR = os.path.join(__file__, 'static')
STATIC_DIR: str = 'static'
TEMPLATE_DIR: str = 'pages'

app.mount("/static", StaticFiles(directory=STATIC_DIR), name='static')

app.include_router(pagerouter)
app.include_router(apirouter)

@app.get('/endpoints/query')
async def handle_query(request: Request):
    print('this endpoint as requested')
