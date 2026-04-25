import uuid
from datetime import datetime
from sqlalchemy import String, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column
from backend.database import Base

class User(Base):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())
    total_games: Mapped[int] = mapped_column(default=0)
    total_score: Mapped[int] = mapped_column(default=0)
    best_game_score: Mapped[int] = mapped_column(default=0)
    ordered_alignments: Mapped[int] = mapped_column(default=0)
    highest_level: Mapped[str] = mapped_column(String(20), default="Débutant")
