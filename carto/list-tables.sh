#!/bin/bash

col_query="SELECT table_name  FROM information_schema.tables where table_type = 'BASE TABLE' AND table_schema = '$1'"

col_url="https://$1.carto.com/api/v2/sql"

col=$(curl -G --data-urlencode "q=$col_query" --data-urlencode "api_key=$2" --data-urlencode "format=csv" $col_url)

count=$(echo "$col" | wc -l)
if [ $count == 1 ]; then
    echo -e "\n\nWARN: list tables query fail or no tables for schema_user='$1'"
    exit 1
fi

# Delete first row (csv headers)
# tail -n +2

# Clean "ctrl+M" cars from csv
# sed -e "s/\r//g"
tables=$(echo "$col" | tail -n +2 | sed -e "s/\r//g")

echo "$tables" | sort > tables.txt