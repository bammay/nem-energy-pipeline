select
    p.region_code,
    p.interval_date      as date_day,
    i.interval_of_day,
    p.interval_start_at,
    p.interval_end_at,
    p.price_aud_per_mwh,
    p.demand_mw,
    p.is_negative_price
from {{ ref('stg_price_demand') }} p
join {{ ref('dim_interval') }} i
    on p.interval_start_at::time = i.interval_start_time