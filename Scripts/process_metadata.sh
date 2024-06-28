#!/bin/bash
set -e

# Creates the "fastq" directory
mkdir -p fastq

process_metadata() {
    local csv_file=$1

    # Ignores the first row as it is the name of each column
    sed '1d' "$csv_file" | while IFS=',' read -r accn name
    do
        # Replace spaces and hyphens with underscores in the name for consistency 
        name=$(echo "$name" | tr ' -' '__')

        # Download the FASTQ file using fasterq-dump
        fasterq-dump "$accn"

        # Rename and compress the downloaded FASTQ file
        head -n 200000 "${accn}.fastq" | gzip > "fastq/${name}_R1.fastq.gz"
        rm "${accn}.fastq"
        
    done
    #chmod -R 777 .

}

# Process metadata files
process_metadata ./metadata.csv
