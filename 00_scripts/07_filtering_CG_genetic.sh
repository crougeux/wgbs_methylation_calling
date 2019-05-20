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
GENET="09_genotype_positions/sites_all_maf0.01_pctind0.2_CTs_temp"
METH="10_methylation_CG"
TEMP="99_tmp"
ID="BAL-11"

## Filtering for gentic CT polymorphisms
for file in $(ls $METH/*_CG.CGmap)

    do
        # Formatting the CGmap file
        base=$(basename $file)
        echo "Formating file:" $base
        file2=$(echo "$file" | perl -pe 's/_CG.CGmap//') 
        name=$(basename $file2)        
        awk '{print$1$3"\t"$0}' $file > "$TEMP"/"$base".temp
       
        # Filtering the CGmap file
        echo "Filtering:" $base
        awk 'NR==FNR{a[$1];next} !($1 in a)' $GENET "$TEMP"/"$base.temp" > "$TEMP"/"$base".temp2
        
        # Reformating the filtered file to CGmap format
        echo "Formating to CGmap format:" $base
        cut -f 2-  "$TEMP"/"$base.temp2" > "$METH"/"$name"_CG_noCT.CGmap
        
        # Removing TEMP files
        echo "Removed temp files for:" $name
        rm "$TEMP"/"$base.temp"
        rm "$TEMP"/"$base.temp2"

        echo "
        >>> "
done

