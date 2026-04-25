import pytest
from backend.services.game_logic import (
    generate_grid, roll_die, check_alignment, calculate_score, detect_level
)

def test_generate_grid_has_12_cells():
    grid = generate_grid()
    flat = [n for row in grid for n in row]
    assert sorted(flat) == list(range(1, 13))

def test_generate_grid_is_4x3():
    grid = generate_grid()
    assert len(grid) == 4
    assert all(len(row) == 3 for row in grid)

def test_roll_die_in_range():
    for _ in range(100):
        result = roll_die()
        assert 1 <= result <= 12

def test_no_alignment_returns_none():
    grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    result = check_alignment([1, 5, 10], grid)
    assert result is None

def test_horizontal_alignment_detected():
    grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    result = check_alignment([1, 2, 3], grid)
    assert result is not None

def test_vertical_alignment_detected():
    grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    result = check_alignment([1, 4, 7], grid)
    assert result is not None

def test_diagonal_alignment_detected():
    grid2 = [[3, 2, 1], [6, 5, 4], [9, 8, 7], [10, 11, 12]]
    result2 = check_alignment([3, 5, 7], grid2)
    assert result2 is not None

def test_score_no_alignment():
    assert calculate_score(None, [1, 2, 3], [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]) == 0

def test_score_unordered_alignment():
    grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    alignment = {"ordered": [1, 2, 3]}
    assert calculate_score(alignment, [3, 1, 2], grid) == 3

def test_score_ordered_alignment():
    grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    alignment = {"ordered": [1, 2, 3]}
    assert calculate_score(alignment, [1, 2, 3], grid) == 9

def test_detect_level_maitre():
    rounds = [
        {"rolls": [1, 2, 3], "alignment": {"ordered": [1, 2, 3]}},
        {"rolls": [4, 5, 6], "alignment": None},
        {"rolls": [1, 2, 3], "alignment": {"ordered": [1, 2, 3]}},
    ]
    assert detect_level(rounds) == "Maître"

def test_detect_level_grand_maitre():
    seq = [1, 2, 3]
    rounds = [{"rolls": seq, "alignment": {"ordered": seq}} for _ in range(13)]
    assert detect_level(rounds) == "Grand Maître"

def test_detect_level_none():
    rounds = [{"rolls": [1, 2, 3], "alignment": {"ordered": [1, 2, 3]}}]
    assert detect_level(rounds) is None
