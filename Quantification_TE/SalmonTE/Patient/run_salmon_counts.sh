#!/bin/bash
### Script that runs SalmonTE quant, re-creates the sampleID vs Condition table, and runs SalmonTE test DE analysis 
## SalmonTE requirements		
path="/home/rpg18/Desktop/TFM/Server_alice2/Datasets/Fastq_files_pat/"				# input path where all paired-fastq files are stored
path_out="/home/rpg18/Desktop/TFM/Pipelines/SalmonTE/Salmon_Patients_fastq/"		# output path for count matrix storing (SalmonTE quant funciton)
path_out_test="/home/rpg18/Desktop/TFM/Pipelines/SalmonTE/Salmon_out_pat/"			# output path for DE analysis (SalmonTE test function)

## creates new output path directories
mkdir -pv $path_out
mkdir -pv $path_out_test

# for each fastq file stored in $path
for i in $path*
do
	total=$total" $i" # $total stores all fastq files
done

## run TE quantification with SalmonTE quant
python3 SalmonTE.py quant --reference=hs --exprtype=count --num_threads=4 --outpath="$path_out" $total

## re-write updated condition.csv file
python3 condition_file.py $path_out

## run DE analysis using SalmonTE test function
var1=$path_out
var2=$path_out_test

sh run_test_salmon.sh $var1 $var2
