#!/bin/bash
#PBS -N pat_12..out
#PBS -e pat_12..error
#PBS -l walltime=12:00:00
#PBS -l vmem=100gb
#PBS -l nodes=1:ppn=20
#PBS -m bea
#PBS -V
#PBS -M rpg18@student.le.ac.uk

module load 'bowtie2/2.3.5.1'
module load 'tophat/2.1.1'
module load 'samtools/1.9'
module load 'perl/5.24.0-threaded'

fastp="/scratch/colorect/rpg18/Datasets/FASTP_qc/fastp" # fastp path
path_data="/scratch/colorect/rpg18/Datasets/12" # input dataset
path_fastp="/scratch/colorect/rpg18/Datasets/12_qc" # output directpry fastp -> Run this script for each patient

# TECDetec paths
path_L1=/scratch/colorect/rpg18/L1_5end_bowtie2_index/L1_5end_dfam # TE-library
path_mkd=/scratch/colorect/rpg18/hg19/Masked_Index_hg19/mskd_hg19 # masked genome path+bowtie index
path_unmkd=/scratch/colorect/rpg18/hg19/Index_hg19/hg19 # unmasked genome path+bowtie index

# Fpr loop for each folder in path_data
for i in "$path_data"/*
do 
	#suffixes for paired reads in their gzip files
	fastq1="_R1_001.fastq" #_R1_001.fastq #_1.fastq
	fastq2="_R2_001.fastq" #_R2_001.fastq #_2.fastq
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir (name of the sample)
	j=${i#"$path_data"}
	#one and two are concatenated from previous parts to create the full path to the fastq files
	one="$i$j$fastq1"
	two="$i$j$fastq2"
	if [ ! -f "$one" ]; then
   		gunzip -r $i # if input files are compressed, uncompressed them
	fi	
	mkdir -pv "$path_fastp$j" # create new output folders with processed fastq files
	one_fastp="$path_fastp$j$j$fastq1"
	two_fastp="$path_fastp$j$j$fastq2"
	# check if qc_fastp already exists, if not, run fastp (quality-control)
	if [ ! -f "$one_fastp" ]; then 
		$fastp -i "$one" -I "$two" -o "$one_fastp" -O "$two_fastp"
	fi
	
	# run TECDetec
	/scratch/colorect/rpg18/Pipelines_scripts/TECDetec1.0/tecdetect.pl -p 8 -lib_type rf -idx_te $path_L1 -idx_mskge $path_mkd -idx_ge $path_unmkd -r1 "$one_fastp" -r2 "$two_fastp" -o /scratch/colorect/rpg18/Output_tecdetec/patient_12$j
	# (r1 is one_fastp, but QC using FASTP for inflammation and cell_line is already done)
done
