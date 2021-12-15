if ! bash list-tables.sh $1 $2; then
    exit 1
fi

echo "DATE: $(date)" >> status.txt
rm -f fail-downloads.txt
rm -f correct-downloads.txt
while read line; do
    if bash download-table.sh $line $1 $2; then
        echo "$line" >> correct-downloads.txt
        echo "OK: $line" >> status.txt
    else
        echo -e "\n\nATTEMPT 1 FAIL.. RETRY...\n$line\n"
        if bash download-table.sh $line $1 $2; then
            echo "$line" >> correct-downloads.txt
            echo "OK: $line" >> status.txt
        else
            echo -e "\n\nATTEMPT 2 FAIL. RETRY...\n$line\n"
            if bash download-table.sh $line $1 $2; then
                echo "$line" >> correct-downloads.txt
                echo "OK: $line" >> status.txt
            else
                echo -e "\n\nATTEMPT 3 FAIL!\n$line\n"
                echo "$line" >> fail-downloads.txt
                echo "FAIL: $line" >> status.txt
            fi
        fi
    fi
done < tables.txt
echo -e "\n\n" >> status.txt