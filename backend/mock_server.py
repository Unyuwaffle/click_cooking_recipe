# mock_server.py
from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
from typing import List
import uvicorn

app = FastAPI()

# --- 모델 정의 ---
class IngredientRequest(BaseModel):
    ingredients: List[str]

# --- [1단계] 이미지 업로드 엔드포인트 ---
# 사진을 찍어서 보내면 인식된 재료 리스트만 먼저 반환합니다.
@app.post("/api/v1/upload")
async def upload_image(file: UploadFile = File(...)):
    print(f"📸 이미지 수신 완료: {file.filename}")

    # YOLOv8 등이 분석한 결과라고 가정하는 가짜 데이터
    return {
        "recognizedIngredients": ["토마토", "계란", "양파"],
        "recipes": []  # 이 단계에서는 레시피를 주지 않고 재료만 확인시킵니다.
    }

# --- [3단계] 최종 레시피 검색 엔드포인트 ---
# 유저가 수정한 최종 재료 리스트를 받아 어울리는 요리를 반환합니다.
@app.post("/api/v1/recipes/search")
async def search_recipes(request: IngredientRequest):
    print(f"🍳 최종 재료 리스트로 레시피 검색 중: {request.ingredients}")

    # 이미지 깨짐 방지를 위해 안정적인 이미지 서비스(LoremFlickr) 주소를 사용합니다.
    return {
        "recognizedIngredients": request.ingredients,
        "recipes": [
            {
                "recipeId": 1,
                "title": "토마토 달걀 볶음",
                "thumbnailUrl": "https://loremflickr.com/600/400/tomato,egg,cooking",
                "matchRate": 98.5,
                "difficulty": "초급",
                "estimatedTime": "10분",
                "ingredients": [
                    {"name": "토마토", "amount": "2개", "owned": True},
                    {"name": "계란", "amount": "3개", "owned": True},
                    {"name": "대파", "amount": "약간", "owned": False}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "토마토를 한입 크기로 썹니다."},
                    {"stepNumber": 2, "description": "달걀을 풀어 팬에서 스크램블하듯 볶아 따로 둡니다."},
                    {"stepNumber": 3, "description": "팬에 기름을 두르고 토마토를 볶다가 달걀을 합칩니다."},
                    {"stepNumber": 4, "description": "소금과 설탕으로 간을 하여 완성합니다."}
                ]
            },
            {
                "recipeId": 2,
                "title": "양파 계란 덮밥",
                "thumbnailUrl": "https://loremflickr.com/600/400/onion,rice,bowl",
                "matchRate": 85.0,
                "difficulty": "초급",
                "estimatedTime": "15분",
                "ingredients": [
                    {"name": "양파", "amount": "1개", "owned": True},
                    {"name": "계란", "amount": "2개", "owned": True},
                    {"name": "간장", "amount": "2큰술", "owned": True}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "양파를 채 썹니다."},
                    {"stepNumber": 2, "description": "간장 양념에 양파를 졸이다가 계란물을 붓습니다."},
                    {"stepNumber": 3, "description": "따뜻한 밥 위에 올려 맛있게 드세요."}
                ]
            }
        ]
    }

# --- 서버 실행부 ---
if __name__ == "__main__":
    # 0.0.0.0으로 설정해야 에뮬레이터나 실제 기기에서 접속이 가능합니다.
    uvicorn.run(app, host="0.0.0.0", port=8000)