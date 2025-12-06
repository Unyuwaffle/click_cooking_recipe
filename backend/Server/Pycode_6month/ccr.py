import os
import psycopg2
from psycopg2 import OperationalError
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from google.cloud import storage

from ai.recognize_ingredients import recognize_ingredients

app = FastAPI()

BUCKET_NAME = os.environ.get("BUCKET_NAME")

def get_db_connection():
    db_user = os.environ.get("DB_USER", "postgres")
    db_password = os.environ.get("DB_PASSWORD")
    db_name = os.environ.get("DB_NAME", "postgres")
    instance_connection_name = os.environ.get("INSTANCE_CONNECTION_NAME")

    if instance_connection_name:
        db_socket_dir = os.environ.get("DB_SOCKET_DIR", "/cloudsql")
        try:
            return psycopg2.connect(
                user=db_user,
                password=db_password,
                database=db_name,
                host=f"{db_socket_dir}/{instance_connection_name}"
            )
        except OperationalError as e:
            print(f"Cloud SQL 연결 실패: {e}")
            raise e
    else:
        return psycopg2.connect(
            host="localhost",
            database=db_name,
            user=db_user,
            password=db_password,
            port="5433"
        )

@app.post("/api/v1/upload")
async def rcmd_recipe(file: UploadFile = File(...)):
    try:
        contents = await file.read()

        print(" Ai 분석 시작")
        ingredients_found = recognize_ingredients(contents)
        print(f"분석 결과: {ingredients_found}")

        storage_client = storage.Client()
        bucket = storage_client.bucket(BUCKET_NAME)
        blob = bucket.blob(file.filename)

        blob.upload_from_string(contents, content_type=file.content_type)

        gcs_path = f"gs://{BUCKET_NAME}/{file.filename}"

    except Exception as e:
        return {"error": "업로드 실패", "detail": str(e)}

    return {
        "message": "성공적으로 처리되었습니다.",
        "file_name": file.filename,
        "recognized_ingredients": ingredients_found,
        "gcs_path": gcs_path
    }

@app.get("/api/v1/db-test")
def test_db_connection():
    conn = None
    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT version()")
            db_version = cur.fetchone()
        return {"status": "success", "message": "DB 연결 성공", "db_version": db_version[0]}
    except Exception as e:
        return {"status": "failure", "detail": str(e)}
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