import logging

from fastapi import Depends, FastAPI, File, HTTPException, Request, UploadFile
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.db import SessionLocal
from app.file_handler import save_upload_file
from app.mapping_service import map_classes_to_ingredients
from app.schemas import RecipeResponse, SearchRecipesRequest
from app.services import search_recipes_payload
from app.vision_service import detect_classes

logger = logging.getLogger(__name__)

app = FastAPI(title="Click Cooking Recipe API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.exception_handler(HTTPException)
async def http_exception_handler(_: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"message": str(exc.detail)},
    )


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(_: Request, exc: RequestValidationError):
    message = "; ".join(error["msg"] for error in exc.errors()) or "잘못된 요청입니다."
    return JSONResponse(status_code=422, content={"message": message})


@app.exception_handler(Exception)
async def general_exception_handler(_: Request, exc: Exception):
    logger.exception("Unhandled server error: %s", exc)
    return JSONResponse(
        status_code=500,
        content={"message": "서버 내부 오류가 발생했습니다."},
    )


@app.get("/")
def root():
    return {"message": "Recipe API server is running"}


@app.get("/api/v1/health")
def health_check(db: Session = Depends(get_db)):
    db.execute(text("SELECT 1"))
    return {"message": "ok"}


@app.post("/api/v1/upload", response_model=RecipeResponse)
def upload_and_recognize(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
):
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="이미지 파일만 업로드할 수 있습니다.")

    saved_path = save_upload_file(file)
    detected_classes = detect_classes(saved_path)
    recognized_ingredients = map_classes_to_ingredients(detected_classes)

    return search_recipes_payload(db, recognized_ingredients)


@app.post("/api/v1/recipes/search", response_model=RecipeResponse)
def search_recipes(
    request: SearchRecipesRequest,
    db: Session = Depends(get_db),
):
    return search_recipes_payload(db, request.ingredients)