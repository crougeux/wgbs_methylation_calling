#!/bin/bash

# 2 CPU
# 10 Go


module load bwa
module load samtools

cd $SLURM_SUBMIT_DIR

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"


# Global variables
GENOMEFOLDER="02_reference"
GENOME=""					# The .fasta file of the genomic reference
BAM="05_aligned_bam"
SORTBAM="06_sorted_bam"

# Remove duplicate in dataset
ls -1 $BAM/*.bam |
    sort -u |
    while read i
    do
        echo $i
        samtools sort -o "$SORTBAM"/$(basename $i _.bam).sorted.bam "$i"
        samtools index "$SORTBAM"/$(basename $i _.bam).sorted.bam $SORTBAM/$(basename $i _.bam.sorted.bam).sortedI.bam
done

