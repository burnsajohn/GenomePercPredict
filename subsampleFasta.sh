#!/bin/bash

###requires seqkit to be installed (https://bioinf.shenwei.me/seqkit/)

###usage: subsampleFasta.sh -d [fasta directory] -o [output directory]
###not particulary efficient, takes a while for lots of files.

while getopts d:o: flag
do
    case "${flag}" in
        d) directory=${OPTARG};; ###directory containing *.fasta files
        o) outdir=${OPTARG};; ###output directory for shuffled, subsampled fasta files
    esac
done


array=(0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95) ##percent increments subsample
for f in $directory/*.fa* ### subsamples all *.fasta files in directory
do
echo "subsampling file $f"
for i in ${array[*]} ##for each increment in the array
do
echo "working on subsample percent $i" 
for q in {1..20} ##do this 20 times--20 subsamples per percentage per fasta file
do
outname=$(echo $f | sed 's/$directory//'| sed 's/\///') 
numseqs=$(grep "^>" $f | wc -l) ##defining variable, counts numseqs
perc=$i ##defining percent increments
myint=$(printf "%.0f\n" $(echo | awk -v n=$numseqs -v p=$perc '{print n*p}')) ##compute number of sequences for $perc percent of proteome (rounding, defining variables, multiplication) 
grep "^>" $f | shuf | head -$myint | sed 's/>//' | seqkit grep -f - $f > $outdir/$i.$q.$outname ##shuffles fasta file and takes first $perc percent of sequences from the headers, then outputs new fasta file based on shuffled headers using seqkit
done 
done
done
