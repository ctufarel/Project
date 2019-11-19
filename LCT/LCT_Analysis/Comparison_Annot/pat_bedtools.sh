''' Script-2.2 generates $path_outBED/only_tum_LCTs.bed file '''
echo \n
# input path: inflam_gtf_BED folder where all bed files for patient dataset are stored
path="/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Bedtools_trial/BED/patients_gtf_BED/"
# path to meta-data files
path_meta="/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Bedtools_trial/Meta_data_Infl"
# input path: cell_lines_gtf_BED folder where all bed files for cell line dataset are stored
path_cell="/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Bedtools_trial/BED/cell_lines_gtf_BED/"
# output path: where only normal and only tumour LCT consensus files are stored
path_outBED=$@
# creates new directory
mkdir -pv $path_out

for i in $path*
do 
	j=${i#$path_data_pat}
	l=${j%"_cov1.gtf.bed"}
	case "$l" in 
		*N_*_L*)
		echo $l
	esac > normal
	
	case "$l" in 
		*T_*_L*)
		echo $l
	esac > tumour

	while read line; do
		if [ $line = "$l" ];
		then
			#cp $path_data_pat$j $path_bam_c$l".bam" # copy bam_control files to bam_control directory (not necessary)
			total_n=$total_c" $i"
		fi
	done < normal
		
	while read line; do
		if [ $line = "$l" ];
		then
			#cp $path_data_pat$j $path_bam_t$l".bam" # copy bam_tumour files to bam_tumour directory (not necessary)
			total_t=$total_t" $i"
		fi
	done < tumour
done
rm -r normal | rm -r tumour
echo $total_n > $path_meta/normal.txt
echo $total_t > $path_meta/tum.txt

# paste all together each LCT detected by TECDetec from normal samples
cat $total_n > $path_outBED/all_norm_pat.bed
# sorts the output file with normal LCT information
sort -k1,1 -k2,2n $path_outBED/all_norm_pat.bed > $path_outBED/sorted_all_norm_pat.bed

## for loop to extract cell line bed files
for i in $path_cell*
do
	total_cell=$total_cell" $i"
done

# paste all together each LCT detected by TECDetec from tumours and cell lines
cat $total_t $total_cell > $path_outBED/all_tum.bed
# sorts the output file with tumour+cell_line LCT information
sort -k1,1 -k2,2n $path_outBED/all_tum.bed > $path_outBED/sorted_all_tum_pat.bed
# intersection of LCT tumour+cell_line and normal consensus bed files with -v (not equal), -s (strand specific), and -sorted (invokes a memory-efficient algorithm)
bedtools intersect -wa -wb -a $path_outBED/sorted_all_tum_pat.bed -b $path_outBED/sorted_all_norm_pat.bed -v -s -sorted > $path_outBED/only_tum_LCTs.bed
# -wa writes the original entry in file a for each overlap (-wb for file b)

echo "Jaccard stadistics for tumour versus normal tissue: "
bedtools jaccard \
    -a $path_outBED/sorted_all_tum_pat.bed \
    -b $path_outBED/sorted_all_norm_pat.bed

