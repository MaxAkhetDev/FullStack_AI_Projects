import pytest

@pytest.mark.asyncio
async def test_register(client):
    r = await client.post("/auth/register", json={
        "username": "alice",
        "email": "alice@example.com",
        "password": "secret123"
    })
    assert r.status_code == 201
    assert "access_token" in r.json()

@pytest.mark.asyncio
async def test_register_duplicate_email(client):
    payload = {"username": "bob", "email": "bob@example.com", "password": "secret"}
    await client.post("/auth/register", json=payload)
    r = await client.post("/auth/register", json={**payload, "username": "bob2"})
    assert r.status_code == 409

@pytest.mark.asyncio
async def test_login(client):
    await client.post("/auth/register", json={
        "username": "carol",
        "email": "carol@example.com",
        "password": "secret"
    })
    r = await client.post("/auth/login", json={"email": "carol@example.com", "password": "secret"})
    assert r.status_code == 200
    assert "access_token" in r.json()

@pytest.mark.asyncio
async def test_login_wrong_password(client):
    await client.post("/auth/register", json={
        "username": "dave", "email": "dave@example.com", "password": "right"
    })
    r = await client.post("/auth/login", json={"email": "dave@example.com", "password": "wrong"})
    assert r.status_code == 401
