import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()

RAW_DIR = Path("data/raw")


def get_engine():
    url = (
        f"postgresql+psycopg2://{os.getenv('PG_USER')}:{os.getenv('PG_PASSWORD')}"
        f"@{os.getenv('PG_HOST')}:{os.getenv('PG_PORT')}/{os.getenv('PG_DB')}"
    )
    return create_engine(url)


def load_raw() -> None:
    files = sorted(RAW_DIR.glob("price_demand_*.csv"))
    df = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
    df.columns = [c.lower() for c in df.columns]
    df["settlementdate"] = pd.to_datetime(df["settlementdate"])

    engine = get_engine()
    with engine.begin() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))
    df.to_sql("price_demand", engine, schema="raw", if_exists="replace", index=False)
    print(f"Loaded {len(df):,} rows into raw.price_demand")


if __name__ == "__main__":
    load_raw()