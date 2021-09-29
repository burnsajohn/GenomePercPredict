#!/bin/bash

###requires BUSCO to be installed (https://busco.ezlab.org/)

###usage: runBuscoSubs.sh -d [subsample directory] -o [output directory] -e [busco directory]
###removes busco directory after each run, but saves short summary file
###can be parallelized; can likely be optimized to only run BUSCO once on whole protein file and search for hits using shuffled subsample fasta headers. Fairly slow and inefficient when run linearly
###writes table at end: BUSCOtable.csv that is used for compiling results


while getopts d:o:e: flag
do
    case "${flag}" in
        d) directory=${OPTARG};; ###directory containing *.fasta files
        o) outdir=${OPTARG};; ###output directory for busco outfile
		e) eukdb=${OPTARG};; ###path to busco eukdb (eukaryota_odb10)
    esac
done


for f in $directory/*.fa* ##for all subsample fasta files 
do
echo "working on file $f"
outname="$(basename -- $f)" ###remove directory info
outname2=$(echo "$outname" | cut -f 1 -d '.') ###remove file extension (.fasta or .fa, etc.)
busco -m protein -i $f -o busco$outname2 -l $eukdb
mv busco$outname2/short_summary* $outdir
rm -r busco$outname2/
done

echo "finished BUSCO, collating table"

for f in $outdir/*.txt ##making a data table  
do
var=$(grep -v "^#" $f | grep "Missing" | sed 's/Missing BUSCOs (M)//' | sed -e 's/^[[:space:]]*//') ##collect number missing from busco short summary 
outname="$(basename -- $f)"
label=$(echo $outname | sed 's/short_summary.specific.eukaryota_odb10.busco//' | sed 's/.txt//' | sed 's/\///' | sed -e 's/\./,/2;s/\./,/2') ##remove unnecessary addons, remove period and replace with a comma, but retain period in fractional percentage number  
echo "$label,$var" >> $outdir/BUSCOtable.csv
done

