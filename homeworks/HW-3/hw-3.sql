  -- Create external table from parquet files on GCS
CREATE OR REPLACE EXTERNAL TABLE
  `eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_ext` OPTIONS ( format = 'parquet',
    uris = ['gs://de-zoomcamp-2024-alex-bucket/nyc_taxi_green_2022/*.parquet'] );
  -- Create a non partitioned table from external table
CREATE OR REPLACE TABLE
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_non_partitoned AS
SELECT
  VendorID,
  TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 AS INT64)) AS lpep_pickup_datetime,
  TIMESTAMP_MICROS(CAST(lpep_dropoff_datetime / 1000 AS INT64)) AS lpep_dropoff_datetime,
  store_and_fwd_flag,
  RatecodeID,
  PULocationID,
  DOLocationID,
  passenger_count,
  trip_distance,
  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  ehail_fee,
  improvement_surcharge,
  total_amount,
  payment_type,
  trip_type,
  congestion_surcharge
FROM
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_ext;
  -- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
  -- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
SELECT
  COUNT(DISTINCT PULocationID)
FROM
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_non_partitoned;
  -- How many records have a fare_amount of 0?
SELECT
  COUNT(*)
FROM
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_non_partitoned
WHERE
  fare_amount = 0;
SELECT
  column_name
FROM
  `eighth-jigsaw-412620.ny_taxi.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'green_tripdata_2022_ext';
  -- Create a new table with the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime
  -- Partition by lpep_pickup_datetime Cluster on PUlocationID
CREATE OR REPLACE TABLE
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_partitoned_clustered
PARTITION BY
  DATE(lpep_pickup_datetime)
CLUSTER BY
  PUlocationID AS
SELECT
  VendorID,
  TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 AS INT64)) AS lpep_pickup_datetime,
  TIMESTAMP_MICROS(CAST(lpep_dropoff_datetime / 1000 AS INT64)) AS lpep_dropoff_datetime,
  store_and_fwd_flag,
  RatecodeID,
  PULocationID,
  DOLocationID,
  passenger_count,
  trip_distance,
  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  ehail_fee,
  improvement_surcharge,
  total_amount,
  payment_type,
  trip_type,
  congestion_surcharge
FROM
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_ext;
  -- Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
  -- Use the materialized table you created earlier in your from clause and note the estimated bytes.

  Select distinct PULocationID
  from eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_partitoned_clustered
  WHERE lpep_pickup_datetime >= TIMESTAMP('2022-06-01') AND lpep_pickup_datetime < TIMESTAMP('2022-07-01');

-- Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed.
    Select distinct PULocationID
  from eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_non_partitoned
  WHERE lpep_pickup_datetime >= TIMESTAMP('2022-06-01') AND lpep_pickup_datetime < TIMESTAMP('2022-07-01');

