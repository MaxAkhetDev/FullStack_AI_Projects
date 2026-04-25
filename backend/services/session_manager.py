import random
import string
from backend.services.game_logic import generate_grid

class SessionManager:
    def __init__(self):
        self._sessions: dict[str, dict] = {}

    def _generate_code(self) -> str:
        while True:
            code = "CBO-" + "".join(random.choices(string.ascii_uppercase + string.digits, k=4))
            if code not in self._sessions:
                return code

    def create_session(self, mode: str = "Débutant") -> dict:
        code = self._generate_code()
        rolls_per_round = 4 if mode == "Débutant" else 3
        session = {
            "code": code,
            "mode": mode,
            "rolls_per_round": rolls_per_round,
            "grid": generate_grid(),
            "status": "lobby",
            "players": {},
            "host": None,
            "current_round": 0,
            "current_player_index": 0,
            "rounds_history": [],
            "connections": {},
        }
        self._sessions[code] = session
        return session

    def get_session(self, code: str) -> dict | None:
        return self._sessions.get(code)

    def join_session(self, code: str, player_id: str, name: str) -> dict:
        session = self._sessions[code]
        if len(session["players"]) >= 6:
            raise ValueError("Session is full")
        if not session["host"]:
            session["host"] = player_id
        session["players"][player_id] = {
            "id": player_id,
            "name": name,
            "score": 0,
            "rounds": [],
            "level": session["mode"],
        }
        return session

    def start_session(self, code: str) -> None:
        self._sessions[code]["status"] = "playing"
        self._sessions[code]["current_round"] = 1

    def remove_session(self, code: str) -> None:
        self._sessions.pop(code, None)

session_manager = SessionManager()
