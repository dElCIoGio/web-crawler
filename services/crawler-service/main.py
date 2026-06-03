from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse
from src.api import api_router


class BaseError(Exception):
    pass

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins = ["*"],
    allow_credentials = True,
    allow_methods = ["*"],
    allow_headers = ["*"],
)

app.include_router(api_router)


@app.exception_handler(BaseError)
async def handle_error(_: Request, exc: BaseError) -> JSONResponse:
    status_code = 404 if isinstance(exc, BaseError) else 400
    return JSONResponse(
        status_code=status_code,
        content={"detail": exc.__class__.__name__, "message": str(exc)},
    )


@app.get("/health")
async def health() -> JSONResponse:
    return "healthy"

@app.get("/")
async def root() -> dict:
    return {"name": "Crawler Service"}


