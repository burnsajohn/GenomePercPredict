# GenomePercPredict

These scripts were written as part of a research experience for undergraduates (REU) program in the summer of 2020 in a fully virtual REU program. They subsample whole proteome files of organisms that are confirmed to eat by phagocytosis or to have cells capable of phagocytosis in order to explore the relationship between genome completeness as measured by BUSCO counts and functional predictions that use a machine learning framework.

For the described functional prediction of phagocytosis, the prediction relies on the computational tool: https://github.com/burnsajohn/predictTrophicMode
It also requires BUSCO and its broad eukaryote set of BUSCOs, eukaryota_odb10.
In R it requires the packages ggplot2 and drc

The procedure to observe the relationship went as follows:

1) Starting with a set of whole proteome files, search the set of hmms from the predictTrophicMode tool against all proteins in each file using the script runhmmer.sh as follows: bash runhmmer.sh -d [fasta directory] -o [output directory] -c [control_file] -h [hmm file location] -t [number of threads]
2) Subsample the proteome files using the script subsampleFasta.sh: bash subsampleFasta.sh -d [fasta directory] -o [output directory]
3) Run BUSCO on the subsamples using the script runBuscoSubs.sh, it will output a data table of the compiled BUSCO runs from all of the subsamples (BUSCOtable.csv): bash runBuscoSubs.sh -d [subsample directory] -o [output directory] -e [busco directory]
4) Map all of the proteome subsamples to significant hits to hmms using the script runmapping.sh from within the directory with the hmmsearch output files, which calls the perl script mapsigmodels.pl: bash runmapping.sh
5) Run the "sigModel" output files from the mapping step (step 4) through the predictTrophicMode tool by placing all of the "sigModel" files into the "TestGenomes" directory of the tool and running it in default mode. It will output a data table containing the predictions.
6) Combine the compiled BUSCO output data (BUSCOtable.csv) and the compiled predictions data table (
