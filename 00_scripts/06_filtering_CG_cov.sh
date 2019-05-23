#!/bin/bash

# 1 CPU
# 3 Go

cd $SLURM_SUBMIT_DIR

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

## Define variables
RAWMETH="08_methylation_call"
FILTMETH="10_methylation_CG"
ID=""

## Basic filtering on coverage and on methylation type
for file in $(ls $RAWMETH/"$ID"*.sorted.bam.dedup_reads.bam.CGmap.gz) 
    do
        base=$(basename $file)
        echo 'Filtering file' $base
        file2=$(echo "$file" | perl -pe 's/.sorted.bam.dedup_reads.bam.CGmap.gz//')
        name=$(basename $file2)
        echo $file        
        gunzip -c $file | 
            awk '$4~/CG/'| 
            awk '$7>=10' |
            awk '$8>=10' |
            awk '$7<100' |
            awk '$8<100' > "$FILTMETH"/"$name"_CG.CGmap
done
