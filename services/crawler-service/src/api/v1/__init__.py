from fastapi import APIRouter


v1_router = APIRouter(prefix="/v1", tags=["V1"])


__all__ = ["v1_router"]