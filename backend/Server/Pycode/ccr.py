from tkinter import image_types
import httpx
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import aiofiles
from pathlib import Path

app = FastAPI()

UPLOAD_DIR = Path("./snap")
UPLOAD_DIR.mkdir(exist_ok=True)

@app.post("/api/v1/upload")
async def rcmd_recipe(file: UploadFile = File(...)):
    file_path = UPLOAD_DIR / file.filename

    try:
        async with aiofiles.open(file_path, 'wb') as out_file:
            while content := await file.read(1024 * 1024):
                await out_file.write(content)
    except Exception as e:
        return {"error": "파일 저장 실패", "detail": str(e)}

    return {
        "message": "사진이 서버에 성공적으로 저장되었습니다.",
        "file_name": file.filename,
        "saved_path": str(file_path)
    }

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

