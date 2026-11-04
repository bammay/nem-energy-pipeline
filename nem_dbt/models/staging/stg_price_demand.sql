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