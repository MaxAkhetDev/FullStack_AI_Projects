import pytest
from backend.services.session_manager import SessionManager

@pytest.fixture
def manager():
    return SessionManager()

def test_create_session(manager):
    session = manager.create_session(mode="Débutant")
    assert session["mode"] == "Débutant"
    assert len(session["players"]) == 0
    assert session["status"] == "lobby"
    assert len(session["grid"]) == 4

def test_join_session(manager):
    session = manager.create_session()
    code = session["code"]
    manager.join_session(code, "player-1", "Alice")
    assert len(manager.get_session(code)["players"]) == 1

def test_max_6_players(manager):
    session = manager.create_session()
    code = session["code"]
    for i in range(6):
        manager.join_session(code, f"p{i}", f"Player{i}")
    with pytest.raises(ValueError, match="full"):
        manager.join_session(code, "p6", "Extra")

def test_start_session(manager):
    session = manager.create_session()
    code = session["code"]
    manager.join_session(code, "p1", "Alice")
    manager.start_session(code)
    assert manager.get_session(code)["status"] == "playing"

def test_session_not_found(manager):
    assert manager.get_session("INVALID") is None

def test_remove_session(manager):
    session = manager.create_session()
    code = session["code"]
    manager.remove_session(code)
    assert manager.get_session(code) is None
