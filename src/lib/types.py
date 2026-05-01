from pydantic import BaseModel, Field

class UserRegistration(BaseModel):
    first_name: str = Field(min_length=3, max_length=20, pattern="^[a-zA-Z]+$")
    last_name: str = Field(min_length=3, max_length=20, pattern="^[a-zA-Z]+$")
    email: str = Field(pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
    password: str = Field(min_length=8, max_length=20)
    confirm_password: str = Field(min_length=8, max_length=20)
    model_config = {"extra": "forbid"} # restrict to fields here

class UserLogin(BaseModel):
    email: str = Field(pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
    password: str = Field(min_length=8, max_length=20)
    model_config = {"extra": "forbid"}

class User(BaseModel):
    id: int
    email: str = Field(pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
    first_name: str = Field(min_length=3, max_length=20, pattern="^[a-zA-Z]+$")
    last_name: str = Field(min_length=3, max_length=20, pattern="^[a-zA-Z]+$")
    password_hash: str
    discipline: str
    begin_term: int
    created_at: str

class Query(BaseModel):
    id: int
    msg: str