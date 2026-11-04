select
    region_code,
    state_name
from {{ ref('stg_region') }}