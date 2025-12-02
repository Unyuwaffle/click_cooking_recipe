from google.cloud import vision

# ---------------------------------------
#  0) 한글 매핑 테이블 (KOR_MAP)
# ---------------------------------------
KOR_MAP = {
    # 🥩 고기류
    "Pork": "돼지고기",
    "Beef": "소고기",
    "Chicken": "닭고기",
    "Duck": "오리고기",
    "Lamb": "양고기",
    "Ham": "햄",
    "Bacon": "베이컨",
    "Sausage": "소시지",

    # 🐟 해산물
    "Salmon": "연어",
    "Tuna": "참치",
    "Mackerel": "고등어",
    "Anchovy": "멸치",
    "Shrimp": "새우",
    "Squid": "오징어",
    "Octopus": "문어",
    "Crab": "게",
    "Lobster": "랍스터",
    "Clam": "조개",
    "Mussel": "홍합",
    "Scallop": "가리비",

    # 🥚 달걀/유제품
    "Egg": "계란",
    "Boiled egg": "삶은 계란",
    "Milk": "우유",
    "Butter": "버터",
    "Cheese": "치즈",
    "Yogurt": "요거트",
    "Cream": "생크림",

    # 🥕 채소
    "Onion": "양파",
    "Red onion": "적양파",
    "Green onion": "대파",
    "Spring onion": "쪽파",
    "Garlic": "마늘",
    "Ginger": "생강",
    "Carrot": "당근",
    "Potato": "감자",
    "Sweet potato": "고구마",
    "Tomato": "토마토",
    "Cherry tomato": "방울토마토",
    "Cucumber": "오이",
    "Zucchini": "주키니",
    "Eggplant": "가지",
    "Cabbage": "양배추",
    "Red cabbage": "적양배추",
    "Chinese cabbage": "배추",
    "Lettuce": "상추",
    "Spinach": "시금치",
    "Kale": "케일",
    "Broccoli": "브로콜리",
    "Cauliflower": "콜리플라워",
    "Mushroom": "버섯",
    "King oyster mushroom": "새송이",
    "Enoki mushroom": "팽이버섯",
    "Bean sprout": "숙주나물",
    "Asparagus": "아스파라거스",

    "Pumpkin": "호박",
    "Butternut squash": "단호박",
    "Chili pepper": "고추",
    "Green pepper": "풋고추",
    "Bell pepper": "파프리카",
    "Red bell pepper": "빨강 파프리카",
    "Yellow bell pepper": "노랑 파프리카",

    # 🍎 과일
    "Apple": "사과",
    "Lemon": "레몬",
    "Lime": "라임",
    "Banana": "바나나",
    "Pineapple": "파인애플",
    "Strawberry": "딸기",
    "Blueberry": "블루베리",
    "Peach": "복숭아",
    "Pear": "배",
    "Grape": "포도",
    "Avocado": "아보카도",

    # 🌾 곡물/면/콩류
    "Rice": "쌀",
    "Brown rice": "현미",
    "Barley": "보리",
    "Noodle": "면",
    "Pasta": "파스타",
    "Spaghetti": "스파게티",
    "Bean": "콩",
    "Red bean": "팥",
    "Black bean": "검은콩",
    "Soybean": "대두",
    "Tofu": "두부",

    # 🧂 양념류
    "Salt": "소금",
    "Sugar": "설탕",
    "Black pepper": "후추",
    "Soy sauce": "간장",
    "Vinegar": "식초",
    "Sesame oil": "참기름",
    "Olive oil": "올리브유",
    "Gochujang": "고추장",
    "Doenjang": "된장",
    "Ssamjang": "쌈장",
    "Ketchup": "케첩",
    "Mayonnaise": "마요네즈",
    "Honey": "꿀",
    "Mustard": "머스타드",

    # 🥪 기타
    "Flour": "밀가루",
    "Bread": "빵",
    "Toast": "식빵",

    # Vision이 자주 내는 불필요 라벨(필터용)
    "Ingredient": "식재료",
    "Produce": "농산물",
}

# ---------------------------------------
#  1) 불필요한 상위 카테고리 제거 (사과만 나오게 하는 핵심)
# ---------------------------------------
CATEGORY_BLACKLIST = [
    "Food", "Fruit", "Vegetable",
    "Ingredient", "Produce",  # Vision이 자주 내는 상위 라벨
    "농산물", "식재료", "야채", "과일"
]

# ---------------------------------------
#  2) 신뢰도 컷오프 기준
# ---------------------------------------
CONFIDENCE_THRESHOLD = 0.50


# ---------------------------------------
# 3) 실제 AI 메인 함수
# ---------------------------------------
def recognize_ingredients(image_bytes: bytes) -> list:
    """
    Vision API → 한글 재료 리스트로 변환하는 최종 함수
    """

    client = vision.ImageAnnotatorClient.from_service_account_file(
        "ai/flawless-psyche-477511-f3-5b998b6f531e.json"
    )
    image = vision.Image(content=image_bytes)

    # label_detection 사용 (1개 사물 사진에서 효과적)
    response = client.label_detection(image=image)
    labels = response.label_annotations

    results = []

    for item in labels:
        eng = item.description   
        score = item.score 


        # 1) 신뢰도 컷오프
        if score < CONFIDENCE_THRESHOLD:
            continue

        # 2) 상위 카테고리 제거
        if eng in CATEGORY_BLACKLIST:
            continue

        # 3) 한글 매핑된 재료만 허용
        if eng not in KOR_MAP:
            continue

        # 4) 한글 변환
        kor = KOR_MAP[eng]
        results.append(kor)

    # 5) 중복 제거
    return list(set(results))

def recognize_ingredients_json(image_bytes: bytes) -> dict:
    ingredients = recognize_ingredients(image_bytes)
    return {
        "recognizedIngredients": ingredients
    }
