FROM python:3.11-slim

# Install wget
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data.py ./

ENTRYPOINT [ "python", "ingest_data.py" ]