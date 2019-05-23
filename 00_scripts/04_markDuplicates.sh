#!/bin/bash

# 2 CPU
# 30 Go


module load bowtie/2.1.0
module load java/jdk/1.8.0_73

cd $SLURM_SUBMIT_DIR

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Variables
PIC="/prg/picard-tools/1.119/MarkDuplicates.jar"
BAM="06_sorted_bam"
DEDUP="07_deduplicated_bam"
METRIC="07_deduplicated_bam"

# Remove duplicate in dataset
ls -1 $BAM/*.sorted.bam |
    sort -u |
    while read i
    do
        echo $i
        java -jar $PIC \
                INPUT="$i" \
                OUTPUT="$DEDUP"/$(basename $i).dedup_reads.bam \
                METRICS_FILE="$METRIC"/metrics.txt
                VALIDATION_STRINGENCY=SILENT \
                #REMOVE_DUPLICATES=true 						# Your choice..!
done
