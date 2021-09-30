#!/bin/bash

###run from within the directory containing files of hmmsearch outputs filtered for significant hits from complete proteome files searched against hmms in the file phag_nonphag-allVall-any3diverse.hmmCAT.hmm

for f in *_sigHits.txt
do
perl mapsigmodels.pl $f [input directory containing subsampled fastas] [output directory to hold sigmodel files]
done

