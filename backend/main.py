from contextlib import asynccontextmanager
from fastapi import FastAPI
from backend.database import engine, Base
from backend.routers import auth, game, ws

@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield

app = FastAPI(title="CBO API", lifespan=lifespan)
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(game.router, prefix="/games", tags=["games"])
app.include_router(ws.router, tags=["ws"])
