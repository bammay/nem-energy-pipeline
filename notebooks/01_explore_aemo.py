# Exploring AEMO price and demand data
# October 2026, 5-minute wholesale price (RRP, $/MWh) and demand (MW) for the five NEM regions.

# %% Load the five files into one table
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

DATA_DIR = Path(__file__).resolve().parent.parent / "data" / "raw"
files = sorted(DATA_DIR.glob("price_demand_*.csv"))
df = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
df["SETTLEMENTDATE"] = pd.to_datetime(df["SETTLEMENTDATE"])
print(f"{len(files)} files, {df.shape[0]:,} rows, {df.shape[1]} columns")
print(df.head())

# %% Data quality checks
print("\nMissing values per column:")
print(df.isna().sum())
print("\nRows per region:")
print(df["REGION"].value_counts())

# %% Price by state
print("\nPrice by state ($/MWh):")
print(df.groupby("REGION")["RRP"].agg(["mean", "min", "max"]).round(2).sort_values("mean", ascending=False))

# %% Most expensive 5-minute interval
print("\nMost expensive interval:")
print(df.loc[df["RRP"].idxmax()])

# %% Negative-price intervals by state
neg = df[df["RRP"] < 0].groupby("REGION").size()
pct = (neg / df.groupby("REGION").size() * 100).round(1)
print("\nNegative-price intervals:")
print(pd.DataFrame({"negative_intervals": neg, "pct_of_intervals": pct}).sort_values("pct_of_intervals", ascending=False))

# %% Average NSW demand by hour of day
nsw = df[df["REGION"] == "NSW1"]
print("\nAverage NSW demand by hour (MW):")
print(nsw.groupby(nsw["SETTLEMENTDATE"].dt.hour)["TOTALDEMAND"].mean().round(0))

# %% Chart: average price by hour for each state
hourly = df.groupby([df["SETTLEMENTDATE"].dt.hour, "REGION"])["RRP"].mean().unstack()
hourly.plot(figsize=(10, 5), title="Average price by hour of day, October 2026")
plt.xlabel("Hour of day")
plt.ylabel("Average price ($/MWh)")
plt.tight_layout()
docs_dir = Path(__file__).resolve().parent.parent / "docs"
docs_dir.mkdir(exist_ok=True)
plt.savefig(docs_dir / "price_by_hour.png", dpi=150)
plt.show()