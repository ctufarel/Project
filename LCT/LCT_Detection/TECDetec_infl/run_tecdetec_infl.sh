# Attempt 1 : run TECDetec -> qsub 
#!/bin/bash
#PBS -N test_SRR.out
#PBS -e test_SRR_again.error
#PBS -l walltime=24:00:00
#PBS -l vmem=100gb
#PBS -l nodes=1:ppn=20
#PBS -m bea
#PBS -V
#PBS -M rpg18@student.le.ac.uk

#FASTP paths
fastp="/scratch/colorect/rpg18/Datasets/FASTP_qc/fastp" # fastp path
path_data="/scratch/colorect/rpg18/Datasets/Raw_data_GEO_fastp" # input dataset
#path_fastp="/scratch/colorect/rpg18/Datasets/Raw_fastp_trial_SRR" # output directory fastp

# TECDetec paths
path_L1=/scratch/colorect/rpg18/L1_5end_bowtie2_index/L1_5end_dfam # TE-library
path_mkd=/scratch/colorect/rpg18/hg19/Masked_Index_hg19/mskd_hg19 # masked genome path+bowtie index
path_unmkd=/scratch/colorect/rpg18/hg19/Index_hg19/hg19 # unmasked genome path+bowtie index

# Fpr loop for each folder in path_data
for i in "$path_data"/*
do 
	#suffixes for paired reads in their gzip or gunzip files (specify unique suffix of file)
	fastq1="_1.fastq" #_R1_001.fastq #_1.fastq
	fastq2="_2.fastq" #_R2_001.fastq #_2.fastq
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir (name of the sample)
	j=${i#"$path_data"}
	#one and two are concatenated from previous parts to create the full path to the fastq files
	one="$i$j$fastq1"
	two="$i$j$fastq2"
	if [ ! -f "$one" ]; then	# if input files are compressed, uncompressed them
   		gunzip -r $i	
	fi	
		
	# run TECDetec pipeline for each sample (paired-reads: read _1 "one" and read_2 "two") (library type "rf" for stranded reads where read_two = sense read)
	/scratch/colorect/rpg18/Pipelines_scripts/TECDetec1.0/tecdetect.pl -p 8 -lib_type rf -idx_te $path_L1 -idx_mskge $path_mkd -idx_ge $path_unmkd -r1 "$one" -r2 "$two" -o /scratch/colorect/rpg18/Output_tecdetec/Run_server/test_SRR$j

done
