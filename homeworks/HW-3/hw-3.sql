  -- Create external table from parquet files on GCS
CREATE OR REPLACE EXTERNAL TABLE
  `eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_ext`
  -- (
  --   VendorID INTEGER,
  --   lpep_pickup_datetime TIMESTAMP64,
  --   lpep_dropoff_datetime TIMESTAMP64,
  --   passenger_count FLOAT64,
  --   trip_distance FLOAT64,
  --   RatecodeID FLOAT64,
  --   store_and_fwd_flag STRING,
  --   PULocationID INTEGER,
  --   DOLocationID INTEGER,
  --   payment_type FLOAT64,
  --   fare_amount FLOAT64,
  --   extra FLOAT64,
  --   mta_tax FLOAT64,
  --   tip_amount FLOAT64,
  --   tolls_amount FLOAT64,
  --   improvement_surcharge FLOAT64,
  --   total_amount FLOAT64,
  --   congestion_surcharge FLOAT64,
  --   airport_fee INTEGER
  -- )
  OPTIONS ( format = 'parquet',
    uris = ['gs://de-zoomcamp-2024-alex-bucket/nyc_taxi_green_2022/*.parquet'] );
  -- Create a non partitioned table from external table
CREATE OR REPLACE TABLE
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_non_partitoned AS
SELECT
  *
FROM
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_ext;
  -- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
  -- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
SELECT
  COUNT(DISTINCT PULocationID)
FROM
  eighth-jigsaw-412620.ny_taxi.green_tripdata_2022_non_partitoned;


