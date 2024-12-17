#!/bin/bash

# Load variables from .env
export $(grep -v '^#' .env | xargs)

# Check if file exists
if [[ ! -f ./configs/mysql/$DB_FILE_NAME.sql ]]; then
    echo "SQL file not found: ./configs/mysql/$DB_FILE_NAME.sql"
    exit 1
fi

# Copy file to container
echo "Copying $DB_FILE_NAME.sql to container $DB_CONTAINER..."
docker cp ./configs/mysql/$DB_FILE_NAME.sql $DB_CONTAINER:/docker-entrypoint-initdb.d/$DB_FILE_NAME.sql
docker exec $DB_CONTAINER chown root:root /docker-entrypoint-initdb.d/$DB_FILE_NAME.sql
docker exec $DB_CONTAINER chmod 644 /docker-entrypoint-initdb.d/$DB_FILE_NAME.sql
if [[ $? -ne 0 ]]; then
    echo "Failed to copy SQL file to container."
    exit 1
fi

# Check if database exists
DB_EXISTS=$(docker exec $DB_CONTAINER mysql -u $DB_USER -p$DB_ROOT_PASSWORD -e "SHOW DATABASES LIKE '$DB_NAME';" | grep $DB_NAME)
if [[ -z "$DB_EXISTS" ]]; then
    echo "Database $DB_NAME does not exist. Please create it before proceeding."
    exit 1
fi
echo "Database $DB_NAME exists."

# Check if tables exist
TABLE_COUNT=$(docker exec $DB_CONTAINER mysql -u $DB_USER -p$DB_ROOT_PASSWORD -D $DB_NAME -e "SHOW TABLES;" | wc -l)
if [[ "$TABLE_COUNT" -le 1 ]]; then
    echo "No tables found in $DB_NAME. Importing SQL file..."
    docker exec $DB_CONTAINER bash -c 'mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME < /docker-entrypoint-initdb.d/$DB_FILE_NAME.sql'
    if [[ $? -ne 0 ]]; then
        echo "Failed to import SQL file into $DB_NAME."
        exit 1
    fi
    echo "Import completed successfully."
else
    echo "Tables found in $DB_NAME. No import needed."
fi
