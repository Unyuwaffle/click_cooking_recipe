from functools import lru_cache
from typing import Any, Optional, Iterable

from sqlalchemy import bindparam, text
from sqlalchemy.orm import Session

from app.db import engine

FALLBACK_ALIASES = {
    "김치": "신김치",
    "쇠고기": "소고기 불고기용",
    "소고기 다짐육": "소고기다짐육",
}


def _unique_preserve_order(values: Iterable[str]) -> list[str]:
    result: list[str] = []
    seen: set[str] = set()

    for value in values:
        cleaned = str(value).strip()
        if not cleaned or cleaned in seen:
            continue
        seen.add(cleaned)
        result.append(cleaned)

    return result


def _normalize_ingredient_name(db: Session, name: str) -> str:
    cleaned_name = name.strip()

    query = text(
        """
        SELECT i.name AS canonical_name
        FROM igr i
        LEFT JOIN igr_alias ia ON ia.igr_id = i.igr_id
        WHERE lower(trim(i.name)) = lower(trim(:name))
           OR lower(trim(ia.alias_name)) = lower(trim(:name))
        LIMIT 1
        """
    )
    row = db.execute(query, {"name": cleaned_name}).mappings().first()
    if row:
        return row["canonical_name"]

    return FALLBACK_ALIASES.get(cleaned_name, cleaned_name)


@lru_cache(maxsize=1)
def _get_rcp_columns() -> frozenset[str]:
    with engine.connect() as conn:
        rows = conn.execute(
            text(
                """
                SELECT column_name
                FROM information_schema.columns
                WHERE table_schema = 'public'
                  AND table_name = 'rcp'
                """
            )
        )
        return frozenset(row[0] for row in rows)


def _get_recipe_meta(db: Session, rcp_id: int) -> Optional[dict]:
    columns = _get_rcp_columns()

    image_expr = "COALESCE(image_url, '') AS image_url" if "image_url" in columns else "'' AS image_url"
    difficulty_expr = "COALESCE(difficulty, '미정') AS difficulty" if "difficulty" in columns else "'미정' AS difficulty"
    estimated_time_expr = (
        "COALESCE(estimated_time, '미정') AS estimated_time"
        if "estimated_time" in columns
        else "'미정' AS estimated_time"
    )

    query = text(
        f"""
        SELECT
            rcp_id,
            title,
            {image_expr},
            {difficulty_expr},
            {estimated_time_expr}
        FROM rcp
        WHERE rcp_id = :rcp_id
        """
    )
    row = db.execute(query, {"rcp_id": rcp_id}).mappings().first()
    return dict(row) if row else None


def _get_recipe_ingredients(db: Session, rcp_id: int) -> list[dict[str, Any]]:
    query = text(
        """
        SELECT
            i.name,
            COALESCE(ri.amount, '') AS amount
        FROM rcp_igr ri
        JOIN igr i ON i.igr_id = ri.igr_id
        WHERE ri.rcp_id = :rcp_id
        ORDER BY i.igr_id
        """
    )
    rows = db.execute(query, {"rcp_id": rcp_id}).mappings().all()
    return [dict(row) for row in rows]


def _get_recipe_steps(db: Session, rcp_id: int) -> list[dict[str, Any]]:
    query = text(
        """
        SELECT
            step_number,
            description
        FROM rcp_step
        WHERE rcp_id = :rcp_id
        ORDER BY step_number
        """
    )
    rows = db.execute(query, {"rcp_id": rcp_id}).mappings().all()
    return [dict(row) for row in rows]


def search_recipes_payload(db: Session, raw_ingredients: list[str]) -> dict[str, Any]:
    recognized_ingredients = _unique_preserve_order(raw_ingredients)
    canonical_ingredients = _unique_preserve_order(
        _normalize_ingredient_name(db, name) for name in recognized_ingredients
    )

    if not canonical_ingredients:
        return {
            "recognizedIngredients": recognized_ingredients,
            "recipes": [],
        }

    match_query = (
        text(
            """
            SELECT
                ri.rcp_id,
                COUNT(DISTINCT ri.igr_id) AS match_count
            FROM rcp_igr ri
            JOIN igr i ON i.igr_id = ri.igr_id
            WHERE i.name IN :canonical_ingredients
            GROUP BY ri.rcp_id
            ORDER BY match_count DESC, ri.rcp_id ASC
            """
        )
        .bindparams(bindparam("canonical_ingredients", expanding=True))
    )

    match_rows = db.execute(
        match_query,
        {"canonical_ingredients": canonical_ingredients},
    ).mappings().all()

    canonical_set = set(canonical_ingredients)
    recipes: list[dict[str, Any]] = []

    for row in match_rows:
        rcp_id = int(row["rcp_id"])
        recipe_meta = _get_recipe_meta(db, rcp_id)
        if recipe_meta is None:
            continue

        recipe_ingredients = _get_recipe_ingredients(db, rcp_id)
        total_count = len(recipe_ingredients)
        owned_count = 0
        ingredient_payload: list[dict[str, Any]] = []

        for ingredient in recipe_ingredients:
            owned = ingredient["name"] in canonical_set
            if owned:
                owned_count += 1

            ingredient_payload.append(
                {
                    "name": ingredient["name"],
                    "owned": owned,
                }
            )

        step_payload = [
            {
                "stepNumber": int(step["step_number"]),
                "description": step["description"],
            }
            for step in _get_recipe_steps(db, rcp_id)
        ]

        match_rate = round((owned_count / total_count) * 100, 1) if total_count else 0.0

        recipes.append(
            {
                "recipeId": rcp_id,
                "title": recipe_meta["title"],
                "thumbnailUrl": recipe_meta["image_url"] or "",
                "matchRate": match_rate,
                "difficulty": recipe_meta["difficulty"] or "미정",
                "estimatedTime": recipe_meta["estimated_time"] or "미정",
                "ingredients": ingredient_payload,
                "steps": step_payload,
            }
        )

    recipes.sort(key=lambda item: (-item["matchRate"], item["recipeId"]))

    return {
        "recognizedIngredients": recognized_ingredients,
        "recipes": recipes,
    }