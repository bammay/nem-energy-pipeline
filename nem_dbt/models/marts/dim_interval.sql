with slots as (

    select generate_series(0, 287) as slot_index

),

times as (

    select
        slot_index + 1                                       as interval_of_day,
        (time '00:00' + slot_index * interval '5 minutes')   as interval_start_time
    from slots

)

select
    interval_of_day,
    interval_start_time,
    extract(hour from interval_start_time)::int as hour_of_day,
    case
        when extract(hour from interval_start_time) < 6  then 'Overnight'
        when extract(hour from interval_start_time) < 10 then 'Morning'
        when extract(hour from interval_start_time) < 16 then 'Solar hours'
        when extract(hour from interval_start_time) < 21 then 'Evening peak'
        else 'Late evening'
    end as day_period
from times