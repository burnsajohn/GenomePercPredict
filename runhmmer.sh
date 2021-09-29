#!/bin/bash

###runs hmmsearch on a list of fasta files
###takes as input: 1) a control file formatted as: species_name,filename; 2) directory containing fasta files (from control file); 3) output directory; 4) location of hmm file "phag_nonphag-allVall-any3diverse.hmmCAT.hmm" from the predictTrophicMode software
###outputs "sigModel" files containing a list of all significant hmms found in the species fasta file
###can be parallelized depending on computer/hpc architecture

###usage: bash runhmmer.sh -d [fasta directory] -o [output directory] -c [control_file] -h [hmm file location] -t [number of threads]

# Defaults:
threads=1

while getopts d:o:c:h:t: flag
do
    case "${flag}" in
        d) directory=${OPTARG};; ###directory containing *.fasta files
        o) outdir=${OPTARG};; ###output directory for shuffled, subsampled fasta files
		c) control=${OPTARG};; ###control file 
		h) hmmfile=${OPTARG};; ###location of hmmfile "phag_nonphag-allVall-any3diverse.hmmCAT.hmm"
		t) threads=${OPTARG};; ###number of threads for hmmsearch. default 1
    esac
done


IFS=$'\r\n' GLOBIGNORE='*' command eval  'fileOrg=($(cat $control))'


numfiles=$(echo $(($(echo ${#fileOrg[@]})-1))) ###size of array/control file

for i in $(eval echo "{0..$numfiles}") ###loop through files listed in control file. Loop can be removed and parallelized according to computer architecture.
do
species=$(echo "${fileOrg[$i]}" | awk -F "," '{print $1}')
filename=$(echo "${fileOrg[$i]}" | awk -F "," '{print $2}')

hmmsearch --tblout $outdir/$species.x.phag_nonphag-allVall-any3diverse.hmmsearchOUT-tbl --cpu $threads $hmmfile $directory/$filename

#cd hmmOUT/

sigfile=${species}_sigHits.txt
sigModel=${sigfile//_sigHits.txt/_sigModels.txt}
grep -v "^#" $species.x.phag_nonphag-allVall-any3diverse.hmmsearchOUT-tbl | awk '$5<=1e-5 && $8<=1e-4' > $sigfile
awk '{print $3}' $sigfile | sort -u > $sigModel
done
