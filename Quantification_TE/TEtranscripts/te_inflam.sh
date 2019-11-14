#!/bin/bash
#### Script that runs TEtranscripts for inflammation dataset  
### Input Dataset - Inflammation
path_data_infl="/home/raquel/Desktop/RFS_ALICE2/Inflammation/Bam_inflam/"

### TEtranscript requirements
path_L1="/home/raquel/Desktop/Scratch_ALICE2/Pipelines_scripts/TEtranscript/GTF/hg19_L1.gtf"		# filtered hg19_rmsk.gtf (only LINE-1 elements)
path_gtf="/home/raquel/Desktop/Scratch_ALICE2/Pipelines_scripts/TEtranscript/GTF/hg19_refGene.gtf"	# hg19 annotation file with gene_name information
path_out="/home/raquel/Desktop/Scratch_ALICE2/Pipelines_scripts/TEtranscript/Sample_infl"		# output directory

# make output directory
mkdir -pv $path_out

# for each file in $path_data_infl
for i in $path_data_infl*
do 
	# extracts file names without path extension
	j=${i#$path_data_infl}
	# extracts prefix of each file name
	l=${j%"Aligned.sortedByCoord.out.bam"} # specify the suffix of each file name
	# locates control and sample text files that store the name of samples per condition (normal and inflamed)
	normal='/home/raquel/Desktop/Scratch_ALICE2/Pipelines_scripts/TEtranscript/Metadata/control.txt'  # each line represents a sample name for normal tissue
	inflamed='/home/raquel/Desktop/Scratch_ALICE2/Pipelines_scripts/TEtranscript/Metadata/sample.txt' # each line represents a sample name for inflamed tissue
	# read each line
	while read line; do
		# if sample name ($l) is found in $normal file
		if [ $line = "$l" ];
		then
			total_n=$total_n" $path_data_infl$j"	# stores string with all normal(uninflamed)-sample names
		fi
	done < "$normal" # reads lines of $normal file
	# read each line
	while read line; do
		# if sample name ($l) is found in $inflamed file
		if [ $line = "$l" ];
		then
			total_i=$total_i" $path_data_infl$j"	# stores string with all inflamed-sample name
		fi
	done < "$inflamed" # reads lines of $inflamed file
done

### Run TEtransript 
TEtranscripts --sortByPos --stranded reverse --format BAM --mode multi -t $total_i -c $total_n --TE $path_L1 --GTF $path_gtf --project $path_out/rev_infl
