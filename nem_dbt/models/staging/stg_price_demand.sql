{% if target.type == 'databricks' %}

-- On Databricks, cleaning already happens in the silver notebook,
-- so staging just selects the columns the marts need.
select
    region_code,
    interval_end_at,
    interval_start_at,
    interval_date,
    price_aud_per_mwh,
    demand_mw,
    is_negative_price
from {{ source('silver', 'price_demand') }}

{% else %}

with source as (

    select * from {{ source('raw', 'price_demand') }}

),

cleaned as (

    select
        region                                        as region_code,
        settlementdate                                as interval_end_at,
        settlementdate - interval '5 minutes'         as interval_start_at,
        (settlementdate - interval '5 minutes')::date as interval_date,
        rrp::numeric(12, 2)                           as price_aud_per_mwh,
        totaldemand::numeric(12, 2)                   as demand_mw,
        rrp < 0                                       as is_negative_price
    from source

)

select * from cleaned

{% endif %}