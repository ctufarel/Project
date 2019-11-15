#!/bin/bash
#### Script that runs TEtranscripts for patient dataset  
### Input Dataset - Patients
path_data_pat="/home/rpg18/Desktop/TFM/Scratch_alice2/Raquel_Pro/Patients/Bam_patients/"

## TEtranscript requirements
path_L1="/home/rpg18/Desktop/TFM/Pipelines/tetoolkit/GTF/hg19_L1.gtf" 						# filtered hg19_rmsk.gtf (only LINE-1 elements)
path_gtf="/home/rpg18/Desktop/TFM/Pipelines/tetoolkit/GTF/hg19_refGene.gtf"					# hg19 annotation file with gene_name information
path_out="/home/rpg18/Desktop/TFM/Pipelines/tetoolkit/Sample_pat_TE"						# output directory

# make output directory
mkdir -pv $path_out

# for each file in $path_data_pat
for i in $path_data_pat*
do 
	# extracts file names without path extension
	j=${i#$path_data_pat}
	# extracts prefix of each file name
	l=${j%"Aligned.sortedByCoord.out.bam"}		# specify the suffix of each file name
	# create file with sample names ($l) if complete sample name ($j) contains 'N' from normal tissue
	case "$j" in 
		*N_*_L*.bam)
		echo $l			# write sample name in control file
	esac > control
	# create file with sample names ($l) if complete sample name ($j) contains 'T' from tumour tissue
	case "$j" in 
		*T_*_L*.bam)
		echo $l			# write sample name in tumour file
	esac > tumour
	# read each line
	while read line; do
		# if sample name ($l) is found in $control file
		if [ $line = "$l" ];
		then
			total_c=$total_c" $path_data_pat$j"	# stores string with all control-sample names
		fi
	done < control		# reads lines of $control file
	# read each line	
	while read line; do
		if [ $line = "$l" ];
		then
			total_t=$total_t" $path_data_pat$j"	# stores string with all tumour-sample names
		fi
	done < tumour		# reads lines of $tumour file

done
# remove control and tumour files
rm -r control | rm -r tumour

### Run TEtranscripts
TEtranscripts --sortByPos --stranded reverse --format BAM --mode multi -t $total_t -c $total_c --TE $path_L1 --GTF $path_gtf --project $path_out/all_TE
