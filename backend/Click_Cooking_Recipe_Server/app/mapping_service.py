CLASS_TO_INGREDIENT = {
    "potato": "감자",
    "egg": "계란",
    "chili": "고추",
    "kimchi": "김치",
    "chicken": "닭고기",
    "carrot": "당근",
    "green_onion": "대파",
    "pork": "돼지고기",
    "tofu": "두부",
    "napa_cabbage": "배추",
    "shiitake": "표고버섯",
    "shrimp": "새우",
    "zucchini": "애호박",
    "onion": "양파",
    "bean_sprout": "콩나물",
    "chive": "쪽파",
    "beef": "쇠고기",
    "ground_beef": "소고기 다짐육",
}


def map_classes_to_ingredients(detected_classes: list[str]) -> list[str]:
    mapped: list[str] = []
    seen: set[str] = set()

    for cls_name in detected_classes:
        ingredient = CLASS_TO_INGREDIENT.get(cls_name)
        if ingredient and ingredient not in seen:
            seen.add(ingredient)
            mapped.append(ingredient)

    return mapped