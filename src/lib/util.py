def clamp(x: int, _min: int, _max: int) -> int:
    return max(min(x, _max), _min)