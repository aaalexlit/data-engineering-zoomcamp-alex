{{
    config(
        materialized='table'
    )
}}

with green_tripdata as (
    select *,
    'Green' as service_type
    from {{ ref('stg_green_tripdata_19_20') }}
),
yellow_tripdata as (
    select *,
    'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata_19_20') }}
), 
all_trips as (
    select * from green_tripdata
    union all
    select * from yellow_tripdata
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select all_trips.tripid, 
    all_trips.vendorid, 
    all_trips.service_type,
    all_trips.ratecodeid, 
    all_trips.pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    all_trips.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    all_trips.pickup_datetime, 
    all_trips.dropoff_datetime, 
    all_trips.store_and_fwd_flag, 
    all_trips.passenger_count, 
    all_trips.trip_distance, 
    all_trips.trip_type, 
    all_trips.fare_amount, 
    all_trips.extra, 
    all_trips.mta_tax, 
    all_trips.tip_amount, 
    all_trips.tolls_amount, 
    all_trips.ehail_fee, 
    all_trips.improvement_surcharge, 
    all_trips.total_amount, 
    all_trips.payment_type, 
    all_trips.payment_type_description
from all_trips
join dim_zones as pickup_zone 
on all_trips.pickup_locationid = pickup_zone.locationid
join dim_zones as dropoff_zone 
on all_trips.dropoff_locationid = dropoff_zone.locationid