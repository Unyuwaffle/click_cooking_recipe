from ai.recognize_ingredients import recognize_ingredients

# 테스트할 이미지 목록 py
TEST_IMAGES = [
    "ai/apple.jpeg",
    "ai/banana_table.jpeg",
    "ai/apple_banana.jpeg",
    "ai/carrot_blurry.jpeg",
]

for path in TEST_IMAGES:
    print("\n===============================")
    print(f"📸 테스트 이미지: {path}")
    print("===============================")

    # 이미지 읽기
    with open(path, "rb") as f:
        img_bytes = f.read()

    # 인식 실행
    result = recognize_ingredients(img_bytes)

    # 출력
    print("➡ 인식 결과:", result)