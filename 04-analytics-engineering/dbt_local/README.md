1. rename [dev.env](dev.env) to `.env` and set all the env vars
1. start up postgres in docker
    ```shell
    docker compose up
    ```
1. `dbt-postgres` package is already a part of [requirements.txt](../../requirements.txt) make sure it's installed

1. run dbt init in the [dbt_local](../dbt_local/) folder
    ```shell
    dbt init
    ```

1. then to test connection switch into project forder [taxi_rides_ny](../taxi_rides_ny/)

    ```shell
    cd taxi_rides_ny
    dbt debug
    ```

1. 