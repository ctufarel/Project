'''BED conversion: this bash script converts GTF to BED file. It takes as input-argument the folder with GTF files to convert: sh bed_file.sh <path-to-gtf-Folder> . Example: sh bed_file.sh inflam_gtf -> DONE
'''
PWD=`pwd`
path=$PWD
path_out=""

for direct in "$@"
do
	mkdir -pv $path/"BED"
	mkdir -pv $path/"BED"/$direct"_BED"
done

for i in $path/$@/Filter
do
	k=$i/*
	for l in $k
	do 
		m=${l#$k}
		all_m=$all_m" $m"
	done
done 

for m in $all_m
do
	find $path/$@/Filter -maxdepth 1 -type f -name $m -exec cat {} + |  awk 'OFS="\t" {print $1,$4-1,$5,$2,$3,$7,$6,$9}' > $path/"BED"/$@"_BED"/$m".bed"
	#find $path/$@/Filter -maxdepth 1 -type f -name $m -exec cat {} + |  awk 'OFS="\t" {print $1,$4-1,$5,$2,$3,$7,$6,$9}' | tr -d ';' > $path/"BED"/$@"_BED"/$m".bed"
	#find $path/$@/Filter -maxdepth 1 -type f -name $m -exec cat {} + |  awk 'OFS="\t" {print $1,$4-1,$5,$7,$9}' | tr -d ';' > $path/"BED"/$@"_BED"/$m".bed"
	#find ./hg19.txt -maxdepth 1 -type f -name hg19.txt -exec cat {} + |  awk 'OFS="\t" {print $1,$2-1,$3,$4}' > hg19.bed
done
rm $path/"BED"/$@"_BED"/results.csv.bed

