import time
from typing import Any, Optional


def validate_step(step: dict[Any]) -> Optional[str]:
    errors = list[str]()
    if "duration" not in step:
        errors.append("duration")
    if "status" not in step:
        errors.append("status")
    if "mime_type" not in step:
        errors.append("mime_type")

    if len(errors) > 0:
        return ", ".join(errors)
    return None


class TimeKeeper:
    """
    This class has the only purpose of exposing
    the start_time to the test suite allowing it
    to be reset via the `set_time` method
    per each test run so it is possible
    to isolate each single test start time
    """

    start_time: float

    def __init__(self):
        self.set_time()

    def set_time(self):
        self.start_time = time.time()
