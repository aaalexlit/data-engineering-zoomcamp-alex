{{
    config(
        materialized='table'
    )
}}
with dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select fhv.dispatching_base_num,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone
from {{ ref('stg_fhv_tripdata_2019') }} as fhv
join dim_zones as pickup_zone 
on fhv.pickup_locationid = pickup_zone.locationid
join dim_zones as dropoff_zone 
on fhv.dropoff_locationid = dropoff_zone.locationid 