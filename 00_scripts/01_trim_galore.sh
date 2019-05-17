#!/bin/bash

# 2 CPU
# 10 Go


cd $SLURM_SUBMIT_DIR 

SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Load the software with module if applicable:
module load cutadapt

# variables
QUAL=25
ERROR_RATE="0.1"
INPUT="03_raw_data"
OUTPUT="04_trimmed_reads"
ID=""

# Let's trimm & clean the data
for file in $(ls $INPUT/"$ID"*.fastq.gz | perl -pe 's/R[12]\.fastq\.gz//g' | grep -v '.md5') 
do

base=$(basename $file)

time /home/clrou103/00-soft/TrimGalore-0.4.5/trim_galore \
    --paired "$INPUT"/"$base"R1.fastq.gz "$INPUT"/"$base"R2.fastq.gz\
    --no_report_file \
    -e $ERROR_RATE \
    --illumina \
    --quality $QUAL \
    --gzip \
    -o $OUTPUT
    
done 2>&1 | tee 98_log_files/"$TIMESTAMP"_trimmgalore_"$ID".log

