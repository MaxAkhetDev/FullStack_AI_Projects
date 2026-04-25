import pytest

@pytest.mark.asyncio
async def test_create_game(client):
    r = await client.post("/games", json={"player_name": "Alice", "mode": "Débutant"})
    assert r.status_code == 201
    data = r.json()
    assert "session_code" in data
    assert data["session_code"].startswith("CBO-")
    assert len(data["grid"]) == 4

@pytest.mark.asyncio
async def test_join_game(client):
    create = await client.post("/games", json={"player_name": "Alice"})
    code = create.json()["session_code"]
    r = await client.post(f"/games/{code}/join", json={"player_name": "Bob"})
    assert r.status_code == 200
    assert len(r.json()["players"]) == 2

@pytest.mark.asyncio
async def test_join_nonexistent_game(client):
    r = await client.post("/games/CBO-XXXX/join", json={"player_name": "Bob"})
    assert r.status_code == 404

@pytest.mark.asyncio
async def test_get_game(client):
    create = await client.post("/games", json={"player_name": "Alice"})
    code = create.json()["session_code"]
    r = await client.get(f"/games/{code}")
    assert r.status_code == 200
    assert r.json()["status"] == "lobby"
