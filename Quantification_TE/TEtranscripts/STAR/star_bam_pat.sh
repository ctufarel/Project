#!/bin/bash
#PBS -N star_pat.out
#PBS -e star_pat.error
#PBS -l walltime=10:00:00
#PBS -l vmem=120gb
#PBS -l nodes=1:ppn=20
#PBS -m bea
#PBS -V
#PBS -M rpg18@student.le.ac.uk


### Run STAR indexing
module load 'star/2.7.1a'

## Alignment requirements
input_fastq="/scratch/colorect/rpg18/Datasets/Patients_scratch_qc/"	# multiple folder directory for each preprocessed paired-end fastq files
#hg19_gtf="/scratch/colorect/rpg18/STAR/GTF/hg19.gtf" 	            # hg19 gencodev32 (optional, but I didn't use it)
index_hg19="/scratch/colorect/rpg18/STAR/index_hg19"	              # hg19 genome index
path_out="/scratch/colorect/rpg18/STAR/Bam_Server/"		              # output directory

# for each fastq file in fastq directory
for i in $input_fastq*
do
	# extracts folder name (sample name)
	j=${i#$input_fastq}
	fastq_1=$i/$j"_1.fastq"		# path to folder named as sample name, where both paired-end fastq files are stored (read 1)
	fastq_2=$i/$j"_2.fastq"		# path to folder named as sample name, where both paired-end fastq files are stored (read 2)
	### Run STAR alignment
	STAR --genomeDir $index_hg19 \
	#--sjdbGTFfile $hg19_gtf \
	--runThreadN 12 \
	--readFilesIn "$fastq_1" "$fastq_2" \
	--outFileNamePrefix $path_out$j \
	--outSAMtype BAM SortedByCoordinate \
	--outSAMattributes Standard \
	--winAnchorMultimapNmax 100 \
	--outFilterMultimapNmax 100 
done
