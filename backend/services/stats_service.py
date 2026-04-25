from sqlalchemy.ext.asyncio import AsyncSession
from backend.models.game import GameRecord, RoundRecord
import uuid

async def persist_game(session_data: dict, db: AsyncSession) -> None:
    record = GameRecord(
        id=str(uuid.uuid4()),
        session_code=session_data["code"],
        mode=session_data["mode"],
        grid=session_data["grid"],
    )
    db.add(record)

    for pid, player in session_data["players"].items():
        for round_data in player.get("rounds", []):
            rr = RoundRecord(
                id=str(uuid.uuid4()),
                game_id=record.id,
                user_id=None,
                player_name=player["name"],
                round_number=round_data["round"],
                rolls=round_data["rolls"],
                score=round_data.get("score", 0),
                alignment_type=round_data["alignment"]["type"] if round_data.get("alignment") and "type" in round_data["alignment"] else None,
            )
            db.add(rr)

    await db.commit()
