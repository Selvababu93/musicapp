from fastapi import Header, HTTPException
import jwt
import os
from dotenv import load_dotenv


SECRET_KEY = os.getenv("SECRET_KEY", "")
ALGORITHM= os.getenv("ALGORITHM", "")

def auth_middleware(x_auth_token= Header()):
    try:
        # get the user token from header
        if not x_auth_token:
            raise HTTPException(401, detail="No auth token, access denied")

        # decode the token
        verified_token = jwt.decode(x_auth_token, SECRET_KEY, algorithms=ALGORITHM)
        if not verified_token:
            raise HTTPException(401, detail="Token verification failed, authorization denied")
        # get the id from the decoded token
        uid = verified_token.get('id')
        return {'uid' : uid, 'token' : x_auth_token}
        

    except jwt.PyJWTError:
        raise HTTPException(401, detail="No auth token, access denied")
