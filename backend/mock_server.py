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

# [수정 1] 엔드포인트 변경: /recipes/recommend -> /upload
# api_service.dart의 baseUrl이 .../api/v1 이고, post('/upload')를 호출하므로
# 최종 경로는 /api/v1/upload 가 됩니다.
@app.post("/api/v1/upload")
# [수정 2] 받는 변수명 변경: image -> file
# api_service.dart에서 FormData 키를 "file"로 보냈으므로 여기서도 file로 받아야 합니다.
async def recommend_recipes(file: UploadFile = File(...)):
    print(f"📸 이미지 수신 성공: {file.filename}")

    # 로딩 시뮬레이션 (1.5초)
    time.sleep(1.5)

    # [유지] 상세 페이지 테스트를 위한 풍성한 Mock Data
    return {
        "recognizedIngredients": ["돼지고기", "양파", "대파"],
        "recipes": [
            {
                "recipeId": 101,
                "title": "백종원표 제육볶음",
                # 실제 로딩 가능한 이미지 URL
                "thumbnailUrl": "https://i.namu.wiki/i/GTPc7XqX4M9oaQfDuv4aE3h8wV7L_yV4fOqJ2hXZ6kYx9lW8mN0pQrs1tUv3wXz5.jpg",
                "matchRate": 98.5,
                "difficulty": "중급",
                "estimatedTime": "30분",
                "ingredients": [
                    {"name": "돼지고기", "amount": "300g", "owned": True},
                    {"name": "양파", "amount": "1/2개", "owned": True},
                    {"name": "대파", "amount": "1대", "owned": True},
                    {"name": "고추장", "amount": "2큰술", "owned": False},
                    {"name": "설탕", "amount": "1큰술", "owned": False}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "돼지고기는 먹기 좋은 크기로 썰어 설탕 1큰술로 밑간을 합니다."},
                    {"stepNumber": 2, "description": "대파와 양파, 당근은 채 썰어 준비합니다."},
                    {"stepNumber": 3, "description": "프라이팬에 기름을 두르고 고기를 먼저 볶다가 야채를 넣습니다."},
                    {"stepNumber": 4, "description": "고추장과 간장을 넣고 센 불에서 빠르게 볶아냅니다."}
                ]
            },
            {
                "recipeId": 102,
                "title": "얼큰한 돼지고기 김치찌개",
                "thumbnailUrl": "https://static.wtable.co.kr/image/production/service/recipe/689/16a53696-0158-4560-93Z7-024c08436159.jpg",
                "matchRate": 85.0,
                "difficulty": "초급",
                "estimatedTime": "20분",
                "ingredients": [
                    {"name": "돼지고기", "amount": "150g", "owned": True},
                    {"name": "김치", "amount": "1/4포기", "owned": False},
                    {"name": "두부", "amount": "1/2모", "owned": False},
                    {"name": "대파", "amount": "송송", "owned": True}
                ],
                "steps": [
                    {"stepNumber": 1, "description": "냄비에 돼지고기와 김치를 넣고 참기름에 달달 볶습니다."},
                    {"stepNumber": 2, "description": "물을 붓고 끓어오르면 다진 마늘과 고춧가루를 넣습니다."},
                    {"stepNumber": 3, "description": "마지막에 두부와 대파를 넣고 한소끔 더 끓입니다."}
                ]
            }
        ]
    }

if __name__ == "__main__":
    # 서버 실행 (포트 8000)
    uvicorn.run(app, host="0.0.0.0", port=8000)