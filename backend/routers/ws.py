import json
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from backend.services.session_manager import session_manager
from backend.services.game_logic import roll_die, check_alignment, calculate_score, detect_level
from backend.database import AsyncSessionLocal
from backend.services.stats_service import persist_game

router = APIRouter()

async def broadcast(code: str, message: dict):
    session = session_manager.get_session(code)
    if not session:
        return
    dead = []
    for pid, ws in session["connections"].items():
        try:
            await ws.send_json(message)
        except Exception:
            dead.append(pid)
    for pid in dead:
        session["connections"].pop(pid, None)

@router.websocket("/ws/{code}")
async def game_ws(websocket: WebSocket, code: str):
    session = session_manager.get_session(code)
    if not session:
        await websocket.close(code=4004)
        return

    await websocket.accept()
    player_id = None

    try:
        async for raw in websocket.iter_text():
            msg = json.loads(raw)
            mtype = msg.get("type")
            payload = msg.get("payload", {})

            if mtype == "connect":
                player_id = payload.get("player_id")
                session["connections"][player_id] = websocket
                await broadcast(code, {"type": "player_joined", "payload": {
                    "players": list(session["players"].values()),
                    "status": session["status"],
                }})

            elif mtype == "start":
                if payload.get("player_id") != session["host"]:
                    await websocket.send_json({"type": "error", "payload": "Not host"})
                    continue
                session_manager.start_session(code)
                await broadcast(code, {"type": "game_started", "payload": {
                    "grid": session["grid"],
                    "current_round": session["current_round"],
                    "current_player": list(session["players"].keys())[0],
                    "rolls_remaining": session["rolls_per_round"],
                }})

            elif mtype == "roll":
                pid = payload.get("player_id")
                players = list(session["players"].keys())
                current = players[session["current_player_index"]]
                if pid != current:
                    await websocket.send_json({"type": "error", "payload": "Not your turn"})
                    continue

                player = session["players"][pid]
                roll = roll_die()
                round_data = player["rounds"]
                if not round_data or round_data[-1]["round"] != session["current_round"]:
                    round_data.append({"round": session["current_round"], "rolls": [], "score": 0, "alignment": None})

                current_round_data = round_data[-1]
                if len(current_round_data["rolls"]) >= session["rolls_per_round"]:
                    await websocket.send_json({"type": "error", "payload": "No rolls remaining"})
                    continue

                current_round_data["rolls"].append(roll)
                rolls_left = session["rolls_per_round"] - len(current_round_data["rolls"])

                alignment = None
                score = 0
                if len(current_round_data["rolls"]) >= 3:
                    alignment = check_alignment(current_round_data["rolls"][:3], session["grid"])
                    score = calculate_score(alignment, current_round_data["rolls"][:3], session["grid"])
                    current_round_data["alignment"] = alignment
                    current_round_data["score"] = score
                    player["score"] += score

                await broadcast(code, {"type": "roll_result", "payload": {
                    "player_id": pid,
                    "roll": roll,
                    "rolls": current_round_data["rolls"],
                    "rolls_left": rolls_left,
                    "alignment": alignment,
                    "score": score,
                    "total_score": player["score"],
                }})

                if rolls_left == 0:
                    level = detect_level([r for r in round_data if r.get("alignment")])
                    if level:
                        player["level"] = level

                    session["current_player_index"] += 1
                    if session["current_player_index"] >= len(players):
                        session["current_player_index"] = 0
                        session["current_round"] += 1

                    if session["current_round"] > 13:
                        session["status"] = "finished"
                        await broadcast(code, {"type": "game_over", "payload": {
                            "players": list(session["players"].values()),
                        }})
                        async with AsyncSessionLocal() as db:
                            await persist_game(session, db)
                    else:
                        next_player = players[session["current_player_index"]]
                        await broadcast(code, {"type": "next_turn", "payload": {
                            "current_round": session["current_round"],
                            "current_player": next_player,
                            "rolls_remaining": session["rolls_per_round"],
                        }})

    except WebSocketDisconnect:
        if player_id:
            session["connections"].pop(player_id, None)
        await broadcast(code, {"type": "player_disconnected", "payload": {"player_id": player_id}})
