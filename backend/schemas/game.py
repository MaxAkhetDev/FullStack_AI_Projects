from pydantic import BaseModel
from typing import Optional

class CreateGameRequest(BaseModel):
    player_name: str
    mode: str = "Débutant"

class CreateGameResponse(BaseModel):
    session_code: str
    player_id: str
    grid: list[list[int]]
    invite_link: str

class JoinGameRequest(BaseModel):
    player_name: str
    player_id: Optional[str] = None

class JoinGameResponse(BaseModel):
    session_code: str
    player_id: str
    grid: list[list[int]]
    players: list[dict]
