import os

DATABASE_URL = os.getenv("DATABASE_URL")
YOLO_MODEL_PATH = os.getenv("YOLO_MODEL_PATH", "best.pt")
UPLOAD_DIR = os.getenv("UPLOAD_DIR", "uploads")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL 환경변수가 설정되지 않았습니다.")