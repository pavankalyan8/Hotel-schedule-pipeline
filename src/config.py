from dotenv import load_dotenv
import os

load_dotenv()

WIW_EMAIL = os.getenv("WIW_EMAIL")
WIW_PASSWORD = os.getenv("WIW_PASSWORD")

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
