#!/bin/bash

###requires BUSCO to be installed (https://busco.ezlab.org/)

###usage: runBuscoSubs.sh -d [subsample directory] -o [output directory] -e [busco directory]
###removes busco directory after each run, but saves short summary file
###can be parallelized; can likely be optimized to only run BUSCO once on whole protein file and search for hits using shuffled subsample fasta headers. Fairly slow and inefficient when run linearly


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
outname="$(basename -- $f)"
busco -m protein -i $f -o busco$outname -l $eukdb
mv busco$outname/short_summary* $outdir
rm -r busco$outname/
done
