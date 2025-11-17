import psycopg2
from psycopg2 import OperationalError
import aiofiles
from pathlib import Path
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI() 

UPLOAD_DIR = Path("./snap")
UPLOAD_DIR.mkdir(exist_ok=True)

DB_HOST = "localhost"
DB_NAME = "Recipes"
DB_USER = "postgres"
DB_PASSWORD = "1235712357"
DB_PORT = 5432

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
        "message": "서버에 사진이 저장.",
        "file_name": file.filename,
    }

@app.get("/api/v1/db-test")
def test_db_connection():
    conn = None
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=DB_PORT,
        )
        with conn.cursor() as cur:
            cur.execute("SELECT version()")
            db_version = cur.fetchone()

        return {
            "status": "success",
            "message": "DB 연결 성공",
            "db_version": db_version[0]
        }

    except OperationalError as e:
        return {"status": "failure", "detail": f"OperationalError: {e}"}

    except Exception as e:
        return {"status": "failure", "detail": f"Exception: {e}"}

    finally:
        if conn:
            conn.close()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)