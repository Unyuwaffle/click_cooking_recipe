from typing import List

from pydantic import BaseModel, Field


class SearchRecipesRequest(BaseModel):
    ingredients: List[str] = Field(default_factory=list)


class IngredientResponse(BaseModel):
    name: str
    owned: bool


class StepResponse(BaseModel):
    stepNumber: int
    description: str


class RecipeOut(BaseModel):
    recipeId: int
    title: str
    thumbnailUrl: str
    matchRate: float
    difficulty: str
    estimatedTime: str
    ingredients: List[IngredientResponse] = Field(default_factory=list)
    steps: List[StepResponse] = Field(default_factory=list)


class RecipeResponse(BaseModel):
    recognizedIngredients: List[str] = Field(default_factory=list)
    recipes: List[RecipeOut] = Field(default_factory=list)