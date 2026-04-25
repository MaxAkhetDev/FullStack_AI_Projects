import uuid
from datetime import datetime
from sqlalchemy import String, Integer, DateTime, ForeignKey, JSON, func
from sqlalchemy.orm import Mapped, mapped_column
from backend.database import Base

class GameRecord(Base):
    __tablename__ = "game_records"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    session_code: Mapped[str] = mapped_column(String(10), unique=True, index=True)
    mode: Mapped[str] = mapped_column(String(10), default="Débutant")
    grid: Mapped[list] = mapped_column(JSON)
    played_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())

class RoundRecord(Base):
    __tablename__ = "round_records"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    game_id: Mapped[str] = mapped_column(String, ForeignKey("game_records.id"))
    user_id: Mapped[str | None] = mapped_column(String, ForeignKey("users.id"), nullable=True)
    player_name: Mapped[str] = mapped_column(String(50))
    round_number: Mapped[int] = mapped_column(Integer)
    rolls: Mapped[list] = mapped_column(JSON)
    score: Mapped[int] = mapped_column(Integer, default=0)
    alignment_type: Mapped[str | None] = mapped_column(String(20), nullable=True)
