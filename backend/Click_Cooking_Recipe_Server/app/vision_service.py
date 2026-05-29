from functools import lru_cache

from ultralytics import YOLO

from app.config import YOLO_MODEL_PATH


@lru_cache(maxsize=1)
def get_model() -> YOLO:
    return YOLO(YOLO_MODEL_PATH)


def detect_classes(image_path: str) -> list[str]:
    """Detect ingredient class names from an uploaded image.

    The service uses the existence of ingredients rather than exact counts,
    so duplicated detections are removed while preserving the detection order.
    """
    model = get_model()
    results = model(image_path, conf=0.1, iou=0.7, verbose=False)

    detected: list[str] = []
    seen: set[str] = set()
    names = model.names

    for result in results:
        if result.boxes is None or result.boxes.cls is None:
            continue

        cls_list = result.boxes.cls.tolist()
        conf_list = result.boxes.conf.tolist()

        for cls_id, conf in zip(cls_list, conf_list):
            class_name = names[int(cls_id)]
            print(f"detected class: {class_name}, confidence: {conf:.4f}")

            if class_name not in seen:
                seen.add(class_name)
                detected.append(class_name)

    print("detected classes:", detected)
    return detected
