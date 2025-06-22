#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Define required environment variables
REQUIRED_VARS=(PROJECT_ID DATASET_ID BUCKET_NAME FILE_PATH TABLE_NAME)

# Load environment variables from .env
if [ ! -f .env ]; then
  echo ".env file not found. Please create one based on .env.example."
  exit 1
fi

# Export variables from .env, ignoring comments and empty lines
export $(grep -v '^#' .env | grep -v '^\s*$' | xargs)

# Check if all required variables are set
for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Environment variable $var is not set in .env."
    exit 1
  fi
done

# Substitute variables in the SQL template
TEMPLATE_FILE="create_external_table.sql.template"
OUTPUT_SQL="create_external_table.sql"

if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "SQL template file '$TEMPLATE_FILE' not found."
  exit 1
fi

sed -e "s/{{PROJECT_ID}}/${PROJECT_ID}/g" \
    -e "s/{{DATASET_ID}}/${DATASET_ID}/g" \
    -e "s/{{BUCKET_NAME}}/${BUCKET_NAME}/g" \
    -e "s/{{FILE_PATH}}/${FILE_PATH}/g" \
    -e "s/{{TABLE_NAME}}/${TABLE_NAME}/g" \
    "$TEMPLATE_FILE" > "$OUTPUT_SQL"

echo "SQL script generated: $OUTPUT_SQL"

# Run the query
echo "Creating external table in BigQuery..."
bq query --use_legacy_sql=false --project_id="$PROJECT_ID" < "$OUTPUT_SQL"

echo "External table created successfully."
