with bounds as (

    select min(interval_date) as start_date,
           max(interval_date) as end_date
    from {{ ref('stg_price_demand') }}

),

dates as (

    select generate_series(start_date, end_date, interval '1 day')::date as date_day
    from bounds

)

select
    date_day,
    extract(year from date_day)::int      as year,
    extract(month from date_day)::int     as month,
    to_char(date_day, 'Mon')              as month_name,
    extract(isodow from date_day)::int    as day_of_week,
    to_char(date_day, 'Dy')               as day_name,
    extract(isodow from date_day) in (6, 7) as is_weekend
from dates