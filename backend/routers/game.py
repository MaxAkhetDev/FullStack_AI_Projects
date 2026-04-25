import uuid
from fastapi import APIRouter, HTTPException
from backend.schemas.game import CreateGameRequest, CreateGameResponse, JoinGameRequest, JoinGameResponse
from backend.services.session_manager import session_manager

router = APIRouter()

BASE_URL = "https://cbo.app"

@router.post("", response_model=CreateGameResponse, status_code=201)
async def create_game(body: CreateGameRequest):
    session = session_manager.create_session(mode=body.mode)
    code = session["code"]
    player_id = str(uuid.uuid4())
    session_manager.join_session(code, player_id, body.player_name)
    return CreateGameResponse(
        session_code=code,
        player_id=player_id,
        grid=session["grid"],
        invite_link=f"{BASE_URL}/join/{code}",
    )

@router.post("/{code}/join", response_model=JoinGameResponse)
async def join_game(code: str, body: JoinGameRequest):
    session = session_manager.get_session(code)
    if not session:
        raise HTTPException(404, "Session not found")
    if session["status"] != "lobby":
        raise HTTPException(409, "Game already started")
    player_id = body.player_id or str(uuid.uuid4())
    try:
        session_manager.join_session(code, player_id, body.player_name)
    except ValueError as e:
        raise HTTPException(409, str(e))
    updated = session_manager.get_session(code)
    return JoinGameResponse(
        session_code=code,
        player_id=player_id,
        grid=updated["grid"],
        players=list(updated["players"].values()),
    )

@router.get("/{code}")
async def get_game(code: str):
    session = session_manager.get_session(code)
    if not session:
        raise HTTPException(404, "Session not found")
    return {k: v for k, v in session.items() if k not in ("connections",)}
