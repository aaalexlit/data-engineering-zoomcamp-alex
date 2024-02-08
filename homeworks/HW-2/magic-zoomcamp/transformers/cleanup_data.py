import pandas as pd
import re

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


def camel_to_snake(name):
    """
    Convert camel case string to snake case.
    """
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


@transformer
def transform(data, *args, **kwargs):
    # Remove rows where the passenger count is equal to 0 and the trip distance is equal to zero
    data = data[data['passenger_count'] > 0]
    data = data[data['trip_distance'] > 0]

    # Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date.
    data['lpep_pickup_date'] = data.lpep_pickup_datetime.dt.date
    
    old_columns = data.columns
    # Rename columns in Camel Case to Snake Case, e.g. VendorID to vendor_id.
    data.columns = data.columns.map(camel_to_snake)

    print(f'number of renamed columns {(old_columns != data.columns).sum()}')

    print(f'vendor_id values: {data.vendor_id.unique()}')

    return data


@test
def test_vendor_id_column(output, *args) -> None:
    assert 'vendor_id' in output.columns, "there's no column `vendor_id`"


@test
def test_no_passangerless_rides(output, *args) -> None:
    assert not len(output[output['passenger_count'] == 0]), 'There are rides with 0 passangers'


@test
def test_trip_positive_distance(output, *args) -> None:
    assert not len(output[output['trip_distance'] <= 0]), 'There are rides with '