-- The NEM market floor is -$1,000/MWh, so no price should be lower
select *
from {{ ref('stg_price_demand') }}
where price_aud_per_mwh < -1000