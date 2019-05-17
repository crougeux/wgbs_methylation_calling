#!/bin/bash

# 1 CPU
# 12 Go

cd $SLURM_SUBMIT_DIR

module load bowtie2

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
REF="02_reference/"		# .fasta file
INDREF="02_reference"


# Index the reference with BSseeker2
time ~/00-soft/BSseeker2/bs_seeker2-build.py -f "$REF" --aligner=bowtie2 -d "$INDREF"
