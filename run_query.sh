#!/bin/bash
set -e

# Load environment variables from .env
if [ ! -f .env ]; then
  echo ".env file not found! Please create one based on .env.example"
  exit 1
fi

export $(grep -v '^#' .env | xargs)

# Replace variables in the SQL template and save to create_external_table.sql
sed -e "s/{{PROJECT_ID}}/$PROJECT_ID/g" \
    -e "s/{{DATASET_ID}}/$DATASET_ID/g" \
    -e "s/{{BUCKET_NAME}}/$BUCKET_NAME/g" \
    -e "s/{{FILE_PATH}}/$FILE_PATH/g" \
    -e "s/{{TABLE_NAME}}/$TABLE_NAME/g" \
    create_external_table.sql.template > create_external_table.sql

# Run the query using bq CLI
bq query --use_legacy_sql=false --project_id=$PROJECT_ID < create_external_table.sql

echo "External table created successfully."
