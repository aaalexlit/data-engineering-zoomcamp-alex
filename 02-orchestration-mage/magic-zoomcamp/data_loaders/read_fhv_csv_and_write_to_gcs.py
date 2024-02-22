import pandas as pd
from os import path

from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs) -> None:
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'dev'

    for month in range(1, 13):
        file_name = f"fhv_tripdata_2019-{month:02d}.csv"
        url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/{file_name}.gz"

        print(f"request url: {url}")

        parse_dates = ['pickup_datetime', 'dropOff_datetime']
        taxi_dtypes = {
            'dispatching_base_num': str,
            'PULocationID': pd.Int64Dtype(),
            'DOLocationID': pd.Int64Dtype(),
            'Affiliated_base_number': str
        }
        df = pd.read_csv(url, compression='gzip', parse_dates=parse_dates, dtype=taxi_dtypes,)
        print(f"CSV loaded:\n{file_name}\nDataFrame shape:\n{df.shape}")

        bucket_name = "de-zoomcamp-2024-alex-bucket"
        object_key = f"fhv_tripdata_2019/{file_name}"

        GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
            df,
            bucket_name,
            object_key,
        )
