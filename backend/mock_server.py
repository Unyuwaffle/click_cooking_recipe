# mock_server.py 수정본

from fastapi import FastAPI, UploadFile, File  # UploadFile 추가 임포트
from pydantic import BaseModel
from typing import List

app = FastAPI()

# 1. 이미지 업로드 테스트용 (수정된 부분)
@app.post("/api/v1/upload")
# file: UploadFile -> 타입 힌트
# = File(...) -> FastAPI에게 이것이 파일 데이터임을 알려주는 기본값
async def upload_image(file: UploadFile = File(...)):
    print(f"받은 파일명: {file.filename}")
    return {
        "recognizedIngredients": ["토마토", "계란", "양파"],
        "recipes": []
    }

# 2. 재료 리스트 테스트용 (기존 코드와 동일)
class IngredientRequest(BaseModel):
    ingredients: List[str]

@app.post("/api/v1/recipes/search")
async def search_recipes(request: IngredientRequest):
    print(f"받은 재료 목록: {request.ingredients}")
    return {
        "recognizedIngredients": request.ingredients,
        "recipes": [
            {
                "recipeId": 1,
                "title": "토마토 달걀 볶음",
                "thumbnailUrl": "https://img.danawa.com/cp_images/service/103/4102142/162814400732115206530.jpg",
                "matchRate": 98.5,
                "difficulty": "초급",
                "estimatedTime": "10분",
                "ingredients": [
                    {"name": "토마토", "amount": "2개", "owned": True},
                    {"name": "계란", "amount": "3개", "owned": True}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "토마토를 먹기 좋게 썹니다."},
                    {"stepNumber": 2, "description": "팬에 계란을 볶다가 토마토를 넣습니다."}
                ]
            }
        ]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)