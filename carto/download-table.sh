#!/bin/bash

col_query="SELECT column_name FROM information_schema.columns WHERE table_name = '$1'"
col_url="https://$2.carto.com/api/v2/sql"

col=$(curl -G --data-urlencode "q=$col_query" --data-urlencode "api_key=$3" --data-urlencode "format=csv" $col_url)

count=$(echo "$col" | wc -l)
if [ $count == 1 ]; then
    echo -e "\nWARN: Table $1 fail "
    exit 1
fi


## Delete first row (csv headers):
#   tail -n +2
## Clean "ctrl+M" cars from csv:
#   sed -e "s/\r//g"
## Change new lines form commas:
#   tr '\n' ','
## Clean last coma and add new line:
#   sed '$s/,$/\n/'

columns=$(echo "$col" | tail -n +2 | sed -e "s/\r//g" | tr '\n' ',' | sed '$s/,$/\n/')

## To copy views the query used sould be (it's much slower):
#   "COPY+(SELECT $columns FROM $1)+TO+stdout+WITH(FORMAT+csv,HEADER+true)"

copy_query="COPY+$1+($columns)+TO+stdout+WITH(FORMAT+csv,HEADER+true)"
copy_file="$1.csv"
copy_url="https://$2.carto.com/api/v2/sql/copyto"

if curl \
    --output $copy_file \
	--compressed \
    --data "q=$copy_query" \
    --data-urlencode "api_key=$3" \
    $copy_url; then
    echo "DOWNLOAD: $copy_file" >> status.txt
    gzip $copy_file
    zip_file="$copy_file.gz"
    mkdir -p tables
    mv $zip_file tables/
    date=$(date +"%Y_%m_%d")
    
    if aws s3 cp tables/$zip_file s3://opi-trupper/backups/carto/$1/$date.csv; then 
        echo "UPLOAD: $zip_file" >> status.txt
        rm tables/$zip_file
    else
        exit 1
    fi
else 
    exit 1
fi