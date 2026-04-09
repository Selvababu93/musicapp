from pickle import NONE
from annotated_types import T
import bcrypt
from fastapi import FastAPI, HTTPException
import uvicorn
from pydantic import BaseModel
from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary, create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import uuid

from dotenv import load_dotenv
import os

load_dotenv()

app = FastAPI()

DATABASE_URL= os.getenv("DATABASE_URL", "")

if DATABASE_URL is None:
    raise ValueError("DATABASE_URL is not set in .env")

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autoflush=False, autocommit=False, bind=engine)

db = SessionLocal()

class UserCreate(BaseModel):
    name : str
    email : str
    password : str

# to create table in DB
Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)

Base.metadata.create_all(engine)

@app.get("/")
def root():
    return "Music App Backend"


@app.post("/signup")
def signup(req: UserCreate):
    # check if user already exist in DB
    user_db = db.query(User).filter(User.email == req.email).first()
    if user_db:
        raise HTTPException(status_code=400, detail="User with same email already exists!")

    # hashing password
    hashed_pw = bcrypt.hashpw(req.password.encode(), salt=bcrypt.gensalt())

    # create user
    user_db = User(id=str(uuid.uuid4()), name=req.name, email = req.email, password=hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db



if __name__ == "__main__":
    uvicorn.run(app="main:app", host="127.0.0.1", port=8800, reload=True,)
