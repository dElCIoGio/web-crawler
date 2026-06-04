import os
import psycopg
from dotenv import load_dotenv
from src.core import settings

DATABASE_URL = settings.postgres_database_url

def get_connection():
    return psycopg.connect(DATABASE_URL)