import io
import pandas as pd
import requests
import pyarrow as pa
import pyarrow.parquet as pq

from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path
import itertools

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs):
    
    config_path = path.join(get_repo_path(), "io_config.yaml") 
    config_profile = 'dev'

    bucket_name = "de-zoomcamp-2024-alex-bucket"

    for month in range(1, 13):
        file_name = f"green_tripdata_2022-{month:02d}.parquet"
        url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/{file_name}"
        object_key = f"nyc_taxi_green_2022/{file_name}"

        print(f"request url: {url}")
        
        try:
            response = requests.get(url)
            response.raise_for_status()
            data = io.BytesIO(response.content)
            
            df = pq.read_table(data).to_pandas()
            print(f"Parquet loaded:\n{file_name}\nDataFrame shape:\n{df.shape}")
    
        except requests.HTTPError as e:
            print(f"HTPP Error: {e}")    


        GoogleCloudStorage.with_config(
            ConfigFileLoader(
                config_path,
                config_profile
                )
            ).export(
                df,
                bucket_name,
                object_key
            )


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    # assert output is not None, 'The output is undefined'