import datetime
import hashlib


def sha256(filename: str) -> str:
    sha256_hash = hashlib.sha256()
    with open(filename, 'rb') as f:
        while True:
            data = f.read(65536)
            if not data:
                break
            sha256_hash.update(data)
    return sha256_hash.hexdigest()


def is_new_day(timestamp: float) -> bool:
    date = datetime.datetime.fromtimestamp(timestamp).date()
    today = datetime.date.today()
    return date != today
