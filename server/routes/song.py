import os
from uuid import uuid4
from dotenv import load_dotenv
import cloudinary.uploader
from fastapi import APIRouter, Depends, Form, UploadFile, File
from sqlalchemy.orm import Session
from database import get_db
from middleware.auth_middleware import auth_middleware
import cloudinary
load_dotenv()

song_route = APIRouter()

# Configuration
cloudinary.config(
    cloud_name = "dpkxksbae",
    api_key = os.getenv("API_KEY", ""),
    api_secret = os.getenv("API_SECRET", ""), # Click 'View API Keys' above to copy your API secret
    secure=True
)

@song_route.post("/upload")
def upload_song(song: UploadFile = File(...), thumbnail : UploadFile = File(...), artist : str = Form(...), song_name : str= Form(...), hex_code : str = Form(...), db: Session = Depends(get_db), auth_dict = Depends(auth_middleware)):
    # uploading files to cloudinary
    song_id  = uuid4()
    song_result = cloudinary.uploader.upload(file=song.file, resource_type='auto', folder=f'song/{song_id}')
    print(f"Song_Result: {song_result}")

    thumbnail_result = cloudinary.uploader.upload(file=thumbnail.file, resource_type= 'image', folder = f'song/{song_id}')
    print(f"Thumnail_Result: {thumbnail_result}")


    # add records to DB
    return "Ok"
