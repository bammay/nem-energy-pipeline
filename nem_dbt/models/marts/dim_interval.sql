with slots as (

    {% if target.type == 'databricks' %}
    select explode(sequence(0, 287)) as slot_index
    {% else %}
    select generate_series(0, 287) as slot_index
    {% endif %}

),

parts as (

    select
        slot_index,
        cast(floor(slot_index / 12) as int) as hour_of_day,
        (slot_index % 12) * 5               as minute_of_hour
    from slots

)

select
    slot_index + 1 as interval_of_day,
    lpad(cast(hour_of_day as {{ dbt.type_string() }}), 2, '0')
        || ':' ||
        lpad(cast(minute_of_hour as {{ dbt.type_string() }}), 2, '0') as interval_start_time,
    hour_of_day,
    case
        when hour_of_day < 6  then 'Overnight'
        when hour_of_day < 10 then 'Morning'
        when hour_of_day < 16 then 'Solar hours'
        when hour_of_day < 21 then 'Evening peak'
        else 'Late evening'
    end as day_period
from parts