from annotated_types import T
import bcrypt
from fastapi import FastAPI, HTTPException
import uvicorn
from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary
from sqlalchemy.orm import sessionmaker
import uuid
from dotenv import load_dotenv
import os
from models.base import Base
from database import engine
from routes.auth import auth_route

load_dotenv()

app = FastAPI()

app.include_router(auth_route, prefix='/auth')


Base.metadata.create_all(engine)

@app.get("/")
def root():
    return "Music App Backend"


if __name__ == "__main__":
    uvicorn.run(app="main:app", host="127.0.0.1", port=8800, reload=True,)
