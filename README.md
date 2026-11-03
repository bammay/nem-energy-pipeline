# nem-energy-pipeline
End-to-end Azure data pipeline for Australian electricity market (NEM) price and demand data

## Data source
AEMO aggregated price and demand data: 5-minute regional wholesale price (RRP, $/MWh) and total demand (MW) for NSW, QLD, VIC, SA and TAS.

## Project structure
- `src/download_aemo.py`: downloads a month of price and demand data for all five regions into `data/raw/`. Re-running it is safe: files that already exist are skipped (idempotent).
- `notebooks/01_explore_aemo.ipynb`: first look at the data.

## How to run
1. Create and activate a virtual environment, then install dependencies:
   `python -m venv .venv`
   `.venv\Scripts\activate`
   `pip install -r requirements.txt`
2. Download a month of data:
   `python src/download_aemo.py`

## Roadmap
- [x] Download raw AEMO data with Python
- [ ] Load into PostgreSQL and query with SQL
- [ ] Model with dbt (star schema)
- [ ] Move to Azure: Data Lake Storage and Databricks (bronze, silver, gold)
- [ ] Orchestrate with Azure Data Factory
- [ ] CI with GitHub Actions
- [ ] Power BI report
