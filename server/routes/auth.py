from json import load
from signal import raise_signal
from typing import Dict
from uuid import uuid4
from fastapi import APIRouter, HTTPException, Depends, Header
from sqlalchemy.orm import Session
from middleware.auth_middleware import auth_middleware
from schemas.user_create import UserCreate, UserCreateResponse
from schemas.user_login import UserLogin
from models.user import User
from database import get_db
import bcrypt
import jwt
import os
from dotenv import load_dotenv
load_dotenv()


SECRET_KEY= os.getenv("SECRET_KEY", "")
ALGORITHM=os.getenv("ALGORITHM", "")
if not SECRET_KEY and ALGORITHM:
     raise ValueError("SECRET_KEY and ALGORITHM is not set in .env")

auth_route = APIRouter(tags=['Auth'])


@auth_route.post("/signup", response_model=UserCreateResponse, status_code=201)
def signup(req: UserCreate, db : Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == req.email).first()

    if user_db:
        raise HTTPException(status_code=400, detail='User with this email already exist!')
    hashed_password = bcrypt.hashpw(req.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid4()), name=req.name, email=req.email, password=hashed_password)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db


@auth_route.post("/login")
def login(req : UserLogin, db : Session = Depends(get_db)):

    user_db = db.query(User).filter(User.email == req.email).first()
    if not user_db:
        raise HTTPException(status_code=404, detail='User not found')
    is_match = bcrypt.checkpw(req.password.encode(), user_db.password) # type: ignore

    if not is_match:
        raise HTTPException(status_code=401, detail='Invalid password')

    # creting JWT
    token = jwt.encode({"id" : user_db.id}, SECRET_KEY, algorithm=ALGORITHM)
    return {"token" : token, "user" : user_db}


@auth_route.get("/")
def current_user_data(db: Session = Depends(get_db), user_dict  = Depends(auth_middleware)):
    # postgres database get the user info
    user_info = db.query(User).filter(User.id == user_dict['uid']).first()
    if not user_info:
        raise HTTPException(404, detail="User not found")

    return user_info
