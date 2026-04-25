from pydantic import BaseModel
from typing import Any, Optional

class WSMessage(BaseModel):
    type: str
    payload: Any = None

class RollRequest(BaseModel):
    player_id: str

class StartRequest(BaseModel):
    player_id: str
