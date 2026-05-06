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
        "recognizedIngredients": ["콩나물", "표고버섯", "양파"],
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
                "title": "소불고기",
                "thumbnailUrl": "https://loremflickr.com/600/400/bulgogi,beef,koreanfood",
                "matchRate": 98.5,
                "difficulty": "중급",
                "estimatedTime": "40분",
                "ingredients": [
                    {"name": "소고기 불고기용", "amount": "300g", "owned": False},
                    {"name": "양파", "amount": "1/2개", "owned": True},
                    {"name": "당근", "amount": "1/4개", "owned": False},
                    {"name": "표고버섯", "amount": "2개", "owned": True},
                    {"name": "간장", "amount": "4큰술", "owned": False}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "소고기는 핏물을 제거하고 양념장에 20분 정도 재워둡니다."},
                    {"stepNumber": 2, "description": "양파, 당근, 버섯을 채 썰어 준비합니다."},
                    {"stepNumber": 3, "description": "팬에 양념된 고기를 볶다가 채소를 모두 넣고 함께 볶습니다."},
                    {"stepNumber": 4, "description": "고기가 완전히 익으면 깨를 뿌려 마무리합니다."}
                ]
            },
            {
                "recipeId": 2,
                "title": "감자전",
                "thumbnailUrl": "https://loremflickr.com/600/400/pancake,potato,koreanfood",
                "matchRate": 92.0,
                "difficulty": "중급",
                "estimatedTime": "30분",
                "ingredients": [
                    {"name": "감자", "amount": "3개", "owned": True},
                    {"name": "양파", "amount": "1/4개", "owned": True},
                    {"name": "표고버섯", "amount": "1개", "owned": True},
                    {"name": "소금", "amount": "0.5작은술", "owned": False},
                    {"name": "식용유", "amount": "적당량", "owned": False}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "감자와 양파는 강판에 갈거나 믹서기로 곱게 갈아줍니다."},
                    {"stepNumber": 2, "description": "갈아낸 재료를 채반에 받쳐 수분을 분리하고, 가라앉은 전분만 다시 반죽과 섞습니다."},
                    {"stepNumber": 3, "description": "표고버섯은 얇게 채 썰어 고명용으로 준비하거나 반죽에 섞습니다."},
                    {"stepNumber": 4, "description": "팬에 기름을 넉넉히 두르고 반죽을 한 입 크기로 올려 노릇하게 부쳐냅니다."}
                ]
            },
            {
                "recipeId": 3,
                "title": "콩나물 비빔밥",
                "thumbnailUrl": "https://loremflickr.com/600/400/bibimbap,rice",
                "matchRate": 85.0,
                "difficulty": "초급",
                "estimatedTime": "20분",
                "ingredients": [
                    {"name": "쌀", "amount": "2컵", "owned": False},
                    {"name": "콩나물", "amount": "200g", "owned": True},
                    {"name": "소고기 다짐육", "amount": "100g", "owned": False},
                    {"name": "쪽파", "amount": "약간", "owned": False},
                    {"name": "참기름", "amount": "1큰술", "owned": False}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "콩나물은 깨끗이 씻어 물기를 제거합니다."},
                    {"stepNumber": 2, "description": "씻은 쌀 위에 콩나물과 고기를 얹고 평소보다 물을 적게 잡아 밥을 짓습니다."},
                    {"stepNumber": 3, "description": "간장, 고춧가루, 파를 섞어 비빔 양념장을 따로 만듭니다."},
                    {"stepNumber": 4, "description": "완성된 밥을 잘 섞어 양념장과 함께 비벼냅니다."}
                ]

            }

        ]
    }

# --- 서버 실행부 ---
if __name__ == "__main__":
    # 0.0.0.0으로 설정해야 에뮬레이터나 실제 기기에서 접속이 가능합니다.
    uvicorn.run(app, host="0.0.0.0", port=8000)