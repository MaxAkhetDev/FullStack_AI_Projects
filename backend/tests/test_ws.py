import pytest
from httpx import AsyncClient, ASGITransport
from backend.main import app

@pytest.mark.asyncio
async def test_ws_connect_and_start():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        r = await ac.post("/games", json={"player_name": "Alice"})
        data = r.json()
        code = data["session_code"]
        player_id = data["player_id"]

    from starlette.testclient import TestClient
    client = TestClient(app)
    with client.websocket_connect(f"/ws/{code}") as ws:
        ws.send_json({"type": "connect", "payload": {"player_id": player_id}})
        msg = ws.receive_json()
        assert msg["type"] == "player_joined"

        ws.send_json({"type": "start", "payload": {"player_id": player_id}})
        msg = ws.receive_json()
        assert msg["type"] == "game_started"
        assert msg["payload"]["current_round"] == 1

def test_ws_invalid_session():
    from starlette.testclient import TestClient
    client = TestClient(app)
    with pytest.raises(Exception):
        with client.websocket_connect("/ws/CBO-INVALID") as ws:
            ws.receive_json()
