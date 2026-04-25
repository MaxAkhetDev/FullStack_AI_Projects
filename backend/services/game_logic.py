import random
from typing import Optional

def generate_grid() -> list[list[int]]:
    numbers = list(range(1, 13))
    random.shuffle(numbers)
    return [numbers[i*3:(i+1)*3] for i in range(4)]

def roll_die() -> int:
    return random.randint(1, 12)

def _get_lines(grid: list[list[int]]) -> list[list[int]]:
    lines = []
    for row in grid:
        lines.append(row)
    # Vertical: 3-row windows (rows 0-2 and rows 1-3) per column
    for col in range(3):
        lines.append([grid[row][col] for row in range(3)])
        lines.append([grid[row][col] for row in range(1, 4)])
    lines.append([grid[0][0], grid[1][1], grid[2][2]])
    lines.append([grid[0][2], grid[1][1], grid[2][0]])
    lines.append([grid[1][0], grid[2][1], grid[3][2]])
    lines.append([grid[1][2], grid[2][1], grid[3][0]])
    return lines

def check_alignment(rolls: list[int], grid: list[list[int]]) -> Optional[dict]:
    rolls_set = set(rolls)
    for line in _get_lines(grid):
        if set(line) == rolls_set:
            return {"ordered": line}
    return None

def calculate_score(alignment: Optional[dict], rolls: list[int], grid: list[list[int]]) -> int:
    if alignment is None:
        return 0
    if rolls == alignment["ordered"]:
        return 9
    return 3

def detect_level(rounds: list[dict]) -> Optional[str]:
    aligned = [r for r in rounds if r.get("alignment")]
    if len(aligned) == 13 and len(set(tuple(r["alignment"]["ordered"]) for r in aligned)) == 1:
        return "Grand Maître"
    seqs = [tuple(r["alignment"]["ordered"]) for r in aligned]
    if len(seqs) != len(set(seqs)) and len(seqs) >= 2:
        return "Maître"
    return None
