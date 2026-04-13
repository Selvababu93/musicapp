from signal import raise_signal
from uuid import uuid4
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from schemas.user_create import UserCreate, UserCreateResponse
from schemas.user_login import UserLogin
from models.user import User
from database import get_db
import bcrypt
import jwt


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

    return user_db
