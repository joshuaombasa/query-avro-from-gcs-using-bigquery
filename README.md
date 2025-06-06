# Query AVRO from GCS Using BigQuery

This repo shows how to create an external BigQuery table pointing to a large AVRO file stored in a Google Cloud Storage bucket, so you can query it using SQL.

## Setup

1. Copy `.env.example` to `.env` and fill in your GCP project ID, BigQuery dataset, GCS bucket, AVRO file path, and desired table name.

   ```bash
   cp .env.example .env
   # edit .env file with your values
   ```

2. Run the `run_query.sh` script to create the external table.

   ```bash
   bash run_query.sh
   ```

This will create the external table in your BigQuery dataset, enabling you to query the AVRO data using standard SQL.

---
