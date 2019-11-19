''' Script-2.1 generates $path_outBED/only_inflamed_LCTs.bed file '''
echo \n
# input path: inflam_gtf_BED folder where all bed files for inflammation dataset are stored
path="/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Bedtools_trial/BED/inflam_gtf_BED/"
# path to meta-data files
path_meta="/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Bedtools_trial/Meta_data_Infl"
# output path: where only inflamed and only normal LCT consensus files are stored
path_outBED=$@
# creates new directory
mkdir -pv $path_out

for i in $path*
do 
	j=${i#$path}
	#l=${j%"_cov1.gtf"}
	#l=${j%"tecout.gtf"}
	l=${j%"_cov1.gtf.bed"}
	#echo $l
	normal='/home/rpg18/Desktop/TFM/Datasets/Inflamation/Geo_Inflm_Data/Meta_data_Matrix/control.txt'
	inflamed='/home/rpg18/Desktop/TFM/Datasets/Inflamation/Geo_Inflm_Data/Meta_data_Matrix/sample.txt'
	#echo $j
	#echo $l
	while read line; do
		if [ $line = "$l" ];
		then
			#echo $j
			#cp $path_data_infl$j $path_bam_n$l".bam" # copy bam_normal files to bam_normal directory (not necessary)
			total_n=$total_n" $i"
			
		fi
	done < "$normal" # reads lines of $normal file
		
	while read line; do
		if [ $line = "$l" ];
		then
			#cp $path_data_infl$j $path_bam_i$l".bam" # copy bam_inflamed files to bam_inflamed directory (not necessary)
			total_i=$total_i" $i"
			
		fi
	done < "$inflamed" # reads lines of $inflamed file
done
echo $total_n > $path_meta/control.txt
echo $total_i > $path_meta/inflamed.txt

# paste all together each LCT detected by TECDetec from normal samples
cat $total_n > $path_outBED/all_norm.bed
# sorts the output file with normal LCT information
sort -k1,1 -k2,2n $path_outBED/all_norm.bed > $path_outBED/sorted_all_norm.bed
# paste all together each LCT detected by TECDetec from inflamed samples
cat $total_i > $path_outBED/all_infl.bed
# sorts the output file with inflamed LCT information
sort -k1,1 -k2,2n $path_outBED/all_infl.bed > $path_outBED/sorted_all_infl.bed
# intersection of LCT inflamed and normal consensus bed files with -v (not equal), -s (strand specific), and -sorted (invokes a memory-efficient algorithm)
bedtools intersect -wa -a $path_outBED/sorted_all_infl.bed -b $path_outBED/sorted_all_norm.bed -v -s -sorted > $path_outBED/only_inflamed_LCTs.bed
# -wa writes the original entry in file a for each overlap (-wb for file b)
#bedtools merge -i only_inflamed_LCTs.bed -d 20000 -s -c 6 -o distinct > only_merged_inflamed_LCTs.bed

echo "Jaccard stadistics for inflamed versus normal tissue: "
bedtools jaccard \
    -a $path_outBED/sorted_all_infl.bed \
    -b  $path_outBED/sorted_all_norm.bed

