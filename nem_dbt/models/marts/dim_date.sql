with bounds as (

    select min(interval_date) as start_date,
           max(interval_date) as end_date
    from {{ ref('stg_price_demand') }}

),

{% if target.type == 'databricks' %}

dates as (
    select explode(sequence(start_date, end_date, interval 1 day)) as date_day
    from bounds
)

select
    date_day,
    year(date_day)                 as year,
    month(date_day)                as month,
    date_format(date_day, 'MMM')   as month_name,
    weekday(date_day) + 1          as day_of_week,
    date_format(date_day, 'E')     as day_name,
    weekday(date_day) >= 5         as is_weekend
from dates

{% else %}

dates as (
    select generate_series(start_date, end_date, interval '1 day')::date as date_day
    from bounds
)

select
    date_day,
    extract(year from date_day)::int        as year,
    extract(month from date_day)::int       as month,
    to_char(date_day, 'Mon')                as month_name,
    extract(isodow from date_day)::int      as day_of_week,
    to_char(date_day, 'Dy')                 as day_name,
    extract(isodow from date_day) in (6, 7) as is_weekend
from dates

{% endif %}