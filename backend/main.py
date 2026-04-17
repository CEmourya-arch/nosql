from __future__ import annotations
from fastapi import FastAPI, HTTPException
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
import uuid

app = FastAPI(title="Bloks API")

# MongoDB connection
MONGO_DETAILS = "mongodb://localhost:27017"
client = AsyncIOMotorClient(MONGO_DETAILS)
database = client.bloks
pages_collection = database.get_collection("pages")

class BlockModel(BaseModel):
    id: str
    type: str
    content: str
    metadata: dict = {}
    nestedBlocks: List[BlockModel] = []

# For Pydantic v2 recursive models
BlockModel.model_rebuild()

class PageModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    icon: Optional[str] = None
    coverImage: Optional[str] = None
    blocks: List[BlockModel] = []
    createdAt: datetime = Field(default_factory=datetime.utcnow)
    updatedAt: datetime = Field(default_factory=datetime.utcnow)

@app.post("/pages/", response_model=PageModel)
async def create_page(page: PageModel):
    page_dict = page.model_dump()
    await pages_collection.insert_one(page_dict)
    return page_dict

@app.get("/pages/{page_id}", response_model=PageModel)
async def get_page(page_id: str):
    page = await pages_collection.find_one({"id": page_id})
    if page:
        return page
    raise HTTPException(status_code=404, detail="Page not found")

@app.get("/pages/", response_model=List[PageModel])
async def list_pages():
    pages = await pages_collection.find().to_list(1000)
    return pages

@app.put("/pages/{page_id}", response_model=PageModel)
async def update_page(page_id: str, page: PageModel):
    page_dict = page.model_dump()
    page_dict["updatedAt"] = datetime.utcnow()
    await pages_collection.replace_one({"id": page_id}, page_dict)
    return page_dict

@app.delete("/pages/{page_id}")
async def delete_page(page_id: str):
    await pages_collection.delete_one({"id": page_id})
    return {"message": "Page deleted"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
