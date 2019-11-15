## Script that re-writes condition.csv output SamonTE quant file with updated information about conditions (i.e: control vs treatment)

import sys
path_out = sys.argv[1]		# calls first and unique argument from run_salmonTE_counts.sh bash script

## open condition.csv file
with open(path_out+'/condition.csv') as ref:
	## re-writes condition.csv file
	with open(path_out+'/condition.csv','w') as ref2:
		lines = ref.readlines()				# list of each line of condition.csv file
		# for each line in lines list
		for line in lines:
			line = line.replace('\n','')	# replace/remove empty line space
			line = line.split(',')			# split comma-separated items in each line
			sample = line[0]				# store item in position 0 (each sampleID)
			# if sampleID contains 'N'
			if 'N' in sample:
				line[1]=line[1].replace('NA','control')		# replace NA for control in condition column (line[1])
			else:
				line[1]=line[1].replace('NA','treatment')	# replace NA for treatment in condition column (line[1])
				
			ref2.writelines(sample+','+line[1]+'\n')		# writes new lines adding comma-separated character (sampleID,condition)

		
		
