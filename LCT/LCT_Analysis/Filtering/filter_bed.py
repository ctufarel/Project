#!/usr/bin/python3
''' Script to filter LCTs by coverage rate: extracts all LCTs with cov=1 and creates  the ./GTF-folder/Filter directory, where are stored each new fitered file. (Expected running time with all three datasets in Linux x86_64 system with 15.5GB RAM at 2.40GHz x4: ~1m20s)'''

import os

#TRY ONLY (-) STRAND
import sys
var1 = sys.argv[1]
var2 = sys.argv[2]
var3 = sys.argv[3]
## Edit folder of interest
#folder_cell = './cell_lines_gtf/'
folder_pat = var1 
folder_infl = var2
folder_cell = var3

## Function that filters LCTs with cov > 1
def filter(folder):
	files = os.listdir(folder)	# lists of files in folder of interest
	#print(files)
	new =str(folder)+'Filter/'	# defines new variable for ./folder-of-interest/Filter/
	os.mkdir(new)	# make directory ./folder-of-interest/Filter/
	total_list = []	# creates empty list
	for file in files:	# for loop for each file stored in ./folder-of-interest/
		#print(file)
		with open(folder+str(file)) as ref:	# opens ./folder-of-interest/<original-gtf-file>
			name = str(file.strip('tecout.gtf'))	# Strips suffix of original gtf file name. Change according to the suffix used in the file name
			with open(new+name+'_cov1.gtf','w') as filtered:	# write new filtered gtf file 
				#with open(new+name+'+_cov1.gtf','w') as filtered_plus:
				lines = ref.readlines()	# list of lines in gtf file stored in ./folder-of-interest/<original-gtf-file>
				num = len(lines)	# number of unfiltered LCTs
				for line in lines:	# each of the items in lines list 
					line = line.replace('\n','')	# eliminates new-line space
					line = line.split(";")	# lists by ';'
					if (line[1] > 'cov=1') & (line[2] == 'fromte=1'):	# filters lines with cov=1
#						antisense= line[0].split('\t')
#						if antisense[6]=="-":
						line = ';'.join(line)	# lists to strings separated by tab space
						filtered.writelines(line + '\n')	# writes new filtered LCTs in ./folder-of-interest/Filter/<new_filtered_gtf_file>

		with open(new+name+'_cov1.gtf') as dif:	# opens ./folder-of-interest/Filter/<new_filtered_gtf_file>
			lines = dif.readlines()	# list of lines in the <new_filtered_gtf_file> 	
			numFilt = len(lines)	# number of LCTs in new filtered file
			total = int(num - numFilt)	# number of filtered LCTs
			total_info = str(name+';from='+str(num)+';to='+str(numFilt)+';Filtered='+str(total)+'\n')	# add information to the total number of filtered LCTs
			total_list.append(total_info)	# appends the below ('total') information in total_list
			with open(new+'results.csv','w') as res:	# writes the 'total' information in ./folder-of-interest/Filter/results.csv 
				total = ''.join(total_list)	# list to strings
				res.write('Number of LCTs that were filtered\n')	# writes first line of results.csv
				res.writelines(total)	# writes new lines with 'total' information to ./folder-of-interest/Filter/results.csv file
	return
# Run function with folder of interest
filter(folder_infl)
filter(folder_cell)
filter(folder_pat)



