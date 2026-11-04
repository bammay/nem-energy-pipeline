-- Fails if any region has more than one row for the same 5-minute interval
select
    region_code,
    interval_end_at,
    count(*) as row_count
from {{ ref('stg_price_demand') }}
group by region_code, interval_end_at
having count(*) > 1