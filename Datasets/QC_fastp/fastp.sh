#!/bin/bash
#PBS -N fastp4.out
#PBS -e fastp4.error
#PBS -l walltime=10:00:00     # depends on size of dataset
#PBS -l vmem=120gb
#PBS -l nodes=1:ppn=20
#PBS -m bea
#PBS -V
#PBS -M rpg18@student.le.ac.uk

#FASTP paths
fastp="/scratch/colorect/rpg18/Datasets/FASTP_qc/fastp"       # path to fastp tool
path_data="/scratch/colorect/rpg18/Datasets/INPUT-FOLDER/"    # input dataset
path_fastp="/scratch/colorect/rpg18/Datasets/OUTPUT-FOLDER/"  # output directory for fastp

# creates new output directory where to store QC-processed paired-end fastq files
mkdir -pv $path_fastp

# for each folder stored in $path_data
for i in "$path_data"*
do 
	# suffixes for paired reads. FASTP also works with gzip files. However, fastq files are being gunzip here
	## for patient and cell datasets
	#fastq_1="_R1_001.fastq" 		# read 1 
	#fastq_2="_R2_001.fastq" 		# read 2
	## for inflammation dataset
	fastp_1="_1.fastq"				    # read 1		
	fastp_2="_2.fastq"				    # read 2
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir (in other words, $j is the name of the sample)
	j=${i#"$path_data"}
	chmod 755 $i/$j"_1.fastq.gz"
	chmod 755 $i/$j"_2.fastq.gz"
	gunzip -r $i
	chmod 755 $i/$j$fastq_1
	chmod 755 $i/$j$fastq_2
	#one and two are concatenated from previous parts to create the full path to the fastq files
	one="$path_data$j/$j$fastq_1"
	two="$path_data$j/$j$fastq_2"
  ## creates new output folders for each processed sample with paired fastq files
	mkdir -pv "$path_fastp$j" 
	one_fastp="$path_fastp$j/$j$fastq_1"
	two_fastp="$path_fastp$j/$j$fastq_2"
	## run FASTP:
	$fastp -i "$one" -I "$two" -o "$one_fastp" -O "$two_fastp"
done

# (optional) Continue workflow with different pipelines:
#sh ./star_bam.sh
#sh ./tetranscript.sh
#sh ./run_tecdetec.sh
