## Creating data in BQ to work on with dbt

1. To create tables containing NY taxi rides data for 2019 and 2020 for yellow and green (`yellow_tripdata_19_20` and `green_tripdata_19_20`) 
run statements from [create_data_in_bq.sql](create_data_in_bq.sql) in BQ. This will copy the data from the public dataset to the said tables.

1. To create 2019 FHV data 
    1. spin up Mage in [02-orchestration-mage](../02-orchestration-mage/) with `docker compose up` and execute `fhv_2019_csv_to_gcs` pipeline
    1. execute [create_data_in_bq.sql](create_data_in_bq.sql) statements in BQ

