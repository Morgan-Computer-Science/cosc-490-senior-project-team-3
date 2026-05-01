import os

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

from pages.router import router as pagerouter
from api.v1.router import router as apirouter

app: FastAPI = FastAPI()

# STATIC_DIR = os.path.join(__file__, 'static')
STATIC_DIR: str = 'static'
TEMPLATE_DIR: str = 'pages'

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*']
)

app.mount("/static", StaticFiles(directory=STATIC_DIR), name='static')

app.include_router(pagerouter)
app.include_router(apirouter)

@app.get('/endpoints/query')
async def handle_query(request: Request):
    print('this endpoint as requested')
