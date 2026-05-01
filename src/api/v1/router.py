from fastapi import APIRouter

from api.v1.endpoints import auth, agent, user, chat, database

API_VERSION = 'v1'

router = APIRouter(prefix=f'/api/{API_VERSION}')

router.include_router(auth.router)
router.include_router(agent.router)
router.include_router(user.router)
router.include_router(chat.router)
router.include_router(database.router)