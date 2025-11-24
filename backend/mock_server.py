# backend/mock_server.py
from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import time

app = FastAPI()

# CORS 설정 (앱에서 접속 허용)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/v1/recipes/recommend")
async def recommend_recipes(image: UploadFile = File(...)):
    print(f"📸 이미지 수신: {image.filename}")

    # 2초간 로딩 흉내 (LoadingIndicator 테스트용)
    time.sleep(2)

    # 성공 시 반환할 가짜 JSON (API 명세서 v1.0)
    return {
        "recognizedIngredients": ["돼지고기", "양파", "계란"],
        "recipes": [
            {
                "recipeId": 101,
                "title": "테스트용 돼지고기 덮밥",
                "thumbnailUrl": "https://via.placeholder.com/150",
                "matchRate": 95.5,
                "difficulty": "초급",
                "estimatedTime": "15분",
                "ingredients": [],
                "steps": []
            },
            {
                "recipeId": 102,
                "title": "실패하지 않는 계란국",
                "thumbnailUrl": "https://via.placeholder.com/150",
                "matchRate": 80.0,
                "difficulty": "중급",
                "estimatedTime": "30분",
                "ingredients": [],
                "steps": []
            }
        ]
    }

if __name__ == "__main__":
    # 내 컴퓨터의 모든 IP에서 접속 허용
    uvicorn.run(app, host="0.0.0.0", port=8000)