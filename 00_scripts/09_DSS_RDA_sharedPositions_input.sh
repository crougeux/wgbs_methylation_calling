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
POS="99_tmp/shared.positions"
METH="10_methylation_CG"
DSS="11_DSS"
RDA="12_RDA"
HEAD="01_archives/position"
HEAD1="01_archives/dss.header"
HEAD2="01_archives/header.meth"
TEMP="99_tmp"
ID=""

## Preparing shared positions file
#for file in $(ls $METH/*_CG_noCT.CGmap)

#    do
#        base=$(basename $file)
#        file2=$(echo "$file" | perl -pe 's/_CG_noCT.CGmap//')
#        name=$(basename $file2)
#        # Getting position for each file -> position file
#        echo "Extracting position for:" $name
#        awk '{print$1"_"$3}' $file > "$TEMP"/"$name"_positions
#done

#echo "Building shared positions file"
#cat "$TEMP"/*positions | sort | uniq -c | sed -n -e 's/^ *55 \(.*\)/\1/p' > "$TEMP"/shared.positions.temp
#cat "$HEAD" "$TEMP"/shared.positions.temp > "$TEMP"/shared.positions 

## Preparing the DSS input file with shared positions
#for file in $(ls $METH/*_CG_noCT.CGmap) 
    
#    do
#        base=$(basename $file)
#        file2=$(echo "$file" | perl -pe 's/_CG_noCT.CGmap//') 
#        name=$(basename $file2)
#        # Formating CGmap files
#        echo "Formating file:" $name
#        awk '{print$1"_"$3"\t"$0}' $file > "$TEMP"/"$name".temp2
#
#        # Filtering the CGmap file
#        echo "Filtering:" $name
#        #awk 'BEGIN{i=0} FNR==NR { a[i++]=$1; next } { for(j=0;j<i;j++) if(index($0,a[j])) {print $0;break} }' $POS "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp3
#        awk 'FNR==NR{arr[$1];next}($1) in arr {print $0}' $POS "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp3
##        
3        # Reformating the filtered file to CGmap format
#        echo "Formating to CGmap format:" $name
#        awk '{print$2"\t"$4"\t"$9"\t"$8}' "$TEMP"/"$name.temp3" > "$TEMP"/"$name".temp4
        
#        # Adding DSS header
#        cat "$HEAD1" "$TEMP"/"$name.temp4" > "$DSS"/"$name"_shared.dss
#        # Removing TEMP files
#        echo "Removed temp files for:" $name
#        rm "$TEMP"/"$name.temp"*
#        rm "$TEMP"/*_positions
#
#        echo "
#        >>> "
#done

## Preparing the RDA input file
for file in $(ls $METH/*_CG_noCT.CGmap)  

    do
        base=$(basename $file)
        file2=$(echo "$file" | perl -pe 's/_CG_noCT.CGmap//')
        name=$(basename $file2)
        # Formating CGmap files
        echo "Formating file:" $name
        awk '{print$1"_"$3"\t"$6}' $file > "$TEMP"/"$name".temp

        # Adding header to individual files
        #echo "Adding header to:" $name
        #cat "$HEAD" "$TEMP"/"$name.temp" > "$TEMP"/"$name".temp2

        # Keep only shared positions 
        echo "Keeping shared position in file:" $name
        #awk 'BEGIN{i=0} FNR==NR { a[i++]=$1; next } { for(j=0;j<i;j++) if(index($0,a[j])) {print $0;break} }' $POS "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp3
        awk 'FNR==NR{arr[$1];next}($1) in arr {print $0}' $POS "$TEMP"/"$name.temp" > "$TEMP"/"$name".temp2
        
        # Adding header to individual files
        echo "Adding header to:" $name
        cat "$HEAD2" "$TEMP"/"$name.temp2" > "$TEMP"/"$name".temp3

        # Add individual information to the header
        awk -v i=$name '{sub("meth","\t"i,$2); print}' "$TEMP"/"$name.temp3" | awk -v i=$name '{sub("./","",$2); print}' > "$TEMP"/"$name".temp4

        # Keep methylation per infdividual to all individuals matrix
        echo "Prepping methylation matrix"
        awk '{print$2}' "$TEMP"/"$name.temp4" > "$TEMP"/"$name".temp5

        echo "
        >>> "
done 

echo "Merge methylation proportion of all individuals"
paste "$TEMP"/*".temp5" > "$TEMP"/"$name".temp6
cut -f1 "$POS" > "$TEMP"/positions.temp
paste "$TEMP"/"positions.temp" "$TEMP"/"$name.temp6" > "$RDA"/RDA_shared_input.txt   

# Remove temp files
echo "Removing TEMP files"
rm "$TEMP"/*.temp*
echo "
DONE! Check your files" 
