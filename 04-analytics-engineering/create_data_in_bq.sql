create or replace table `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20_19_20` as
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2019`
union all
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2020`;

create or replace table `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20_19_20` as
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2019`
union all
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2020`;

 -- Fixes yellow table schema
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN pickup_datetime TO tpep_pickup_datetime;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN dropoff_datetime TO tpep_dropoff_datetime;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.yellow_tripdata_19_20`
  RENAME COLUMN dropoff_location_id TO DOLocationID;

  -- Fixes green table schema
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN pickup_datetime TO lpep_pickup_datetime;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN dropoff_datetime TO lpep_dropoff_datetime;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `eighth-jigsaw-412620.taxi_trips_dbt.green_tripdata_19_20`
  RENAME COLUMN dropoff_location_id TO DOLocationID;


    -- Create external table from parquet files on GCS
CREATE OR REPLACE EXTERNAL TABLE
  `eighth-jigsaw-412620.taxi_trips_dbt.fhv_tripdata_2019_ext` OPTIONS ( format = 'csv',
    uris = ['gs://de-zoomcamp-2024-alex-bucket/fhv_tripdata_2019/*.csv'] );

  -- Create a non partitioned table from external FHV table
CREATE OR REPLACE TABLE
  eighth-jigsaw-412620.taxi_trips_dbt.fhv_tripdata_2019 AS
SELECT
dispatching_base_num,		
pickup_datetime,
dropOff_datetime,
PUlocationID,
DOlocationID,
SR_Flag,
Affiliated_base_number
FROM
  eighth-jigsaw-412620.taxi_trips_dbt.fhv_tripdata_2019_ext;
