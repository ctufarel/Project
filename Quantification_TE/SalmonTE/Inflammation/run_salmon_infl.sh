
#!/bin/bash

# Script that quantifies and generate differential expression analysis for inflammation dataset using SalmonTE in three steps

### Step 1: TE-quantification
path_fastq="/home/rpg18/Desktop/TFM/Server_alice2/Datasets/GEO_all/"
path="/home/rpg18/Desktop/TFM/Pipelines/SalmonTE/SRR_sal_1/"

# check if the suffix of your reads is specified in /SalmonTE/snakemake/Snakemake.(file)
for i in "$path_fastq"*
do	
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir (name of the sample)
	j=${i#"$path_fastq"}
	# creates folder for each sample
	mkdir "$path$j"
	# run SalmonTE quantification
	python3 SalmonTE.py quant --reference=hs --exprtype=count --num_threads=4 --outpath="$path$j" "$i"
done

### Step 2: Merging all EXPR.csv count tables calculated per sample, using quant-SalmonTE. Also, creates a new directory where to store the total EXPR.csv count table and copy condition.csv and clades.csv files. Finally, SalmonTE is run with test parameter to generate the differential expression (DE) analysis. DE analysis output will be stored in the test folder in the quant-output directory.

## Requirements
#path="/home/rpg18/Desktop/TFM/Pipelines/SalmonTE/SRR_sal_1/"
path_pru="/home/rpg18/Desktop/TFM/Pipelines/SalmonTE/EXPR_file_processing"
path_out="/home/rpg18/Desktop/TFM/Pipelines/SalmonTE/out_all_22"
path_out_test="$path_out/test"

# creates directory where to store test-output
mkdir -pv $path_out_test

# create temporary directory to store subfiles generated by the script: EXPR_file_processing
if [ ! -f "$path_pru" ]; then
	mkdir -pv "$path_pru"
	mkdir -pv "$path_out"
fi

# for each folder (for each sample) in $path 
for i in "$path"*
do
	#j becomes the current file path, minus the dir path - i.e. the name of the subdir
	j=${i#"$path"}
	cp "$path"$j/clades.csv $path_out/clades.csv
	control='/home/rpg18/Desktop/TFM/Datasets/Inflamation/Geo_Inflm_Data/Meta_data_Matrix/control.txt'
	sample='/home/rpg18/Desktop/TFM/Datasets/Inflamation/Geo_Inflm_Data/Meta_data_Matrix/sample.txt'
	#n=1
	while read line; do
		if [ "$line" = "$j" ];
		then
			echo $j',control' #>> /home/rpg18/Desktop/TFM/Pipelines/LIONS/controls/input3.list
		fi
	done < "$control"
		
	while read line; do
		if [ "$line" = "$j" ];
		then
			echo $j',inflamed' #>> /home/rpg18/Desktop/TFM/Pipelines/LIONS/controls/input3.list
		fi
	done < "$sample"

	#echo $path$j/$j
done > "$path_out/condition.csv"
echo "SampleID,condition\n$(cat $path_out/condition.csv)" > $path_out/condition.csv


# copy EXPR.csv file generated by SalmonTE-counts for each sample
for i in "$path"*
do
	j=${i#"$path"}
	# j becomes the current file path, minus the dir path - i.e. the name of the subdir
	expr="$path$j/EXPR.csv"
	mkdir "$path_pru/$j"
	expr_headerless="$path_pru/$j/"$j"EXPR.csv"		
	sed '1d' $expr > $expr_headerless
	find $path_pru/$j -maxdepth 1 -type f -name ""$j"EXPR.csv" -exec cp -i {} $path_pru ';' 

done

# header creation: TE	+ SampleID
for i in "$path"*
do
	j=${i#$path}
	echo -n "$j\t"
	
done > header.csv 
echo "TE\t$(cat header.csv)"  > header.csv 

# paste first column of the EXPR.csv file: TE_names
for f in $path_pru/*.csv
do
    name=`basename $f`
    #kepp all column excep the first one of each csv file 
    cut -d"," -f2- $f > "new$name"
    #files using the same names are stored in directory new/  
	awk -F "\"*,\"*" '{print $1}' OFS="\t" $f  > /home/rpg18/Desktop/TFM/Pipelines/SalmonTE/column.csv

done

# join all counts without: header and TE_names
paste -d "\t" $(ls new*)  > EXPR_num.csv

# join first column with TE_names and counts
pr -mts column.csv EXPR_num.csv > "$path_out/EXPR.csv" 

# add header into the final EXPR.csv file
vim +'0r header.csv|wq' "$path_out/EXPR.csv" 2>/dev/null

# remove subproducts
rm -r new*.csv | rm -r $path_pru | rm -r column.csv | rm -r  header.csv | rm -r EXPR_num.csv | rm -r treatment | rm -r control

### Step 3: DE analysis with test-parameter
# Check before EXPR.csv file in output SalmonTE quant out_directory. Open and save as CSV file.

## Run below lines:
var1=$path_out
var2=$path_out_test
var3='control'
var4='inflamed'

#sh test_salmon.sh $var1 $var2 $var3 $var4

