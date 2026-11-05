select
    p.region_code,
    p.interval_date as date_day,
    cast(extract(hour from p.interval_start_at) as int) * 12
        + cast(floor(extract(minute from p.interval_start_at) / 5) as int)
        + 1 as interval_of_day,
    p.interval_start_at,
    p.interval_end_at,
    p.price_aud_per_mwh,
    p.demand_mw,
    p.is_negative_price
from {{ ref('stg_price_demand') }} p