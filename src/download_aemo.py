from pathlib import Path
import requests

REGIONS = ["NSW1", "QLD1", "VIC1", "SA1", "TAS1"]
BASE_URL = "https://aemo.com.au/aemo/data/nem/priceanddemand/PRICE_AND_DEMAND_{month}_{region}.csv"
OUT_DIR = Path("data/raw")

def download_month(month: str) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for region in REGIONS:
        out_file = OUT_DIR / f"price_demand_{month}_{region}.csv"
        if out_file.exists():
            print(f"Skipping {out_file.name}, already downloaded")
            continue
        url = BASE_URL.format(month=month, region=region)
        response = requests.get(url, headers={"User-Agent": "nem-energy-pipeline/0.1"}, timeout=60)
        response.raise_for_status()
        out_file.write_bytes(response.content)
        print(f"Saved {out_file.name}")


if __name__ == "__main__":
    months = [
        "202511", "202512", "202601", "202602", "202603", "202604",
        "202605", "202606", "202607", "202608", "202609", "202610",
    ]
    for month in months:
        download_month(month)  