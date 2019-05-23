#!/bin/bash

# 1 CPU
# 15 Go


module load mugqic/bowtie2/2.2.6
module load mugqic/python/2.7.8 


cd "${PBS_O_WORKDIR}"

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

## Define options
REF="" 						# Genomic reference .fasta
INDREF=""					# Path to indexed reference directory
BAM="07_deduplicated_bam"
METH="08_methylation_call"
ID=""

## Call methylation in BATCH
for file in $(ls $BAM/"$ID"*.bam) # | perl -pe 's/HI.*Index_*.//g') 
    do
        base=$(basename $file)

        time /home/clem/00_soft/BSseeker2/bs_seeker2-call_methylation.py -i "$BAM"/$base -o "$METH"/$base --db="$INDREF"
done

