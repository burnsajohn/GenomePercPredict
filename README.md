# GenomePercPredict

These scripts were written as part of a research experience for undergraduates (REU) program in the summer of 2020 in a fully virtual REU program. They subsample whole proteome files of organisms that are confirmed to eat by phagocytosis or to have cells capable of phagocytosis in order to explore the relationship between genome completeness as measured by BUSCO counts and functional predictions that use a machine learning framework.

For the described functional prediction of phagocytosis, the prediction relies on the computational tool 

The procedure to observe the relationship went as follows:

1) Starting with a set of whole proteome files, search a set of hmms against all proteins in each file using the script 
