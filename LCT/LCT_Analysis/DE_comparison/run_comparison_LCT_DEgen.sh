#!/bin/bash
''' Script-4 that extracts gene names from annotated shared-Infl-Tumour-LCTs if there are differentially expressed in both patients (normal vs tumour) and Inflammation (normal vs inflamed) datasets '''
echo \n

outpath=$@
# add prefix 'infl' for inflammation and 'pat' for patient dataset
var1='./TEtrans_out/infl_DEfold2_gene_TE.txt' 			# path to DEGenes for inflammation 
var2='./TEtrans_out/pat_sample_4_sigdiff_gene_TE.txt'	# path to DEGenes for patient dataset

# generates finalgenes_func.txt file
python3 geneDE2geneLCT.py $outpath $var1 $var2
