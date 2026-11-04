-- Fails if the fact table has lost or gained rows compared with staging
select
    (select count(*) from {{ ref('stg_price_demand') }})    as staging_rows,
    (select count(*) from {{ ref('fact_dispatch_price') }}) as fact_rows
where (select count(*) from {{ ref('stg_price_demand') }})
   <> (select count(*) from {{ ref('fact_dispatch_price') }})