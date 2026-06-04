from http import HTTPStatus

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse
from src.api import api_router
from src.core import settings

class BaseError(Exception):
    pass

app = FastAPI()
app.state.settings = settings
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
    status_code = HTTPStatus.NOT_FOUND if isinstance(exc, BaseError) else HTTPStatus.BAD_REQUEST
    return JSONResponse(
        status_code=status_code,
        content={"detail": exc.__class__.__name__, "message": str(exc)},
    )


@app.get("/health")
async def health() -> JSONResponse:
    return JSONResponse(
        status_code=HTTPStatus.OK,
        content={"status": "ok"}
    )