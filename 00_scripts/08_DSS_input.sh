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
POS="99_tmp/merged.sorted.positions"
METH="10_methylation_CG"
DSS="11_DSS"
INFO="01_archives/dss.header"
TEMP="99_tmp"
ID="BAL-11"

## Prep. files for DSS
for file in $(ls $METH/*_CG_noCT.CGmap)

    do
        base=$(basename $file)
        file2=$(echo "$file" | perl -pe 's/_CG_noCT.CGmap//')
        name=$(basename $file2)
        # Formating CGmap files
        echo "Formating file:" $name
        awk '{print$1"_"$3"\t"$0}' $file > "$TEMP"/"$name".temp2

        # Filtering the CGmap file
        #echo "Filtering:" $name
        #awk 'BEGIN{i=0} FNR==NR { a[i++]=$1; next } { for(j=0;j<i;j++) if(index($0,a[j])) {print $0;break} }' $POS "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp3
        #awk 'FNR==NR{arr[$1];next}($1) in arr {print $0}' $POS "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp3
        
        # Reformating the filtered file to CGmap format
        echo "Formating to CGmap format:" $name
        awk '{print$2"\t"$4"\t"$9"\t"$8}' "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp4
        
        # Adding DSS header
        cat "$INFO" "$TEMP"/"$name.temp4" > "$DSS"/"$name".dss
        # Removing TEMP files
        echo "Removed temp files for:" $name
        rm "$TEMP"/"$name.temp"*

        echo "
        >>> "
done

