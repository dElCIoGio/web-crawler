from pydantic_settings import BaseSettings, SettingsConfigDict



class Settings(BaseSettings):
    postgres_database_url: str


settings = Settings()


