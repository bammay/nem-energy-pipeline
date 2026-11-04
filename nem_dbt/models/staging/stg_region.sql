select
    region     as region_code,
    state_name
from {{ source('raw', 'region') }}