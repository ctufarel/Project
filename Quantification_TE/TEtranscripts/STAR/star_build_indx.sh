#!/bin/bash
#PBS -N star_5.out
#PBS -e star_5.error
#PBS -l walltime=16:00:00
#PBS -l vmem=120gb
#PBS -l nodes=1:ppn=20
#PBS -m bea
#PBS -V
#PBS -M rpg18@student.le.ac.uk

# -> I had problems with genomeGenerate. I deactivated my conda environments and re-run the script. I also exited from the server (alice2) and re-entered with spcetre2, and I download gencode hg19 reference genome and annotation files. Then, it worked. Afterwards, I re-ran again the same STAR script in alice2, just to check if there is any difference between running from spectre2 or alice2. I realised that there is not difference, it worked with alice2 too.

## genomeGenerate
hg19_gtf="/scratch/colorect/rpg18/STAR/GTF/hg19.gtf"    #hg19 gencodev32
hg19_fa="/scratch/colorect/rpg18/STAR/hg19_fa/hg19.fa"  #hg19 gencode
index_hg19="/scratch/colorect/rpg18/STAR/index_hg19"    # output directory 

### Run STAR indexing
module load 'star/2.7.1a'

#STAR --runThreadN 12 \
--runMode genomeGenerate \
--genomeDir $index_hg19 \
--genomeFastaFiles $hg19_fa \
--sjdbGTFfile $hg19_gtf \
--sjdbOverhang 76 \
--genomeSAsparseD 6
