import os
import shutil
import uuid

from fastapi import UploadFile

from app.config import UPLOAD_DIR


def save_upload_file(upload_file: UploadFile) -> str:
    os.makedirs(UPLOAD_DIR, exist_ok=True)

    original_filename = upload_file.filename or "image.jpg"
    ext = os.path.splitext(original_filename)[1].lower() or ".jpg"
    saved_filename = f"{uuid.uuid4()}{ext}"
    saved_path = os.path.join(UPLOAD_DIR, saved_filename)

    with open(saved_path, "wb") as buffer:
        shutil.copyfileobj(upload_file.file, buffer)

    return saved_path