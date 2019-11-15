# Organise data from GEO:

liston = []		# open liston empty list

### open file with meta data information about the samples
with open('Good_SraRunTable.txt') as ref:
	lines = ref.readlines()			# list of lines in meta-data raw file
	# each line in lines list
	for row in lines:
		data = row.replace('"','')		# replace/remove '"' characters
		data = data.replace("\n",'')		# replace/remove empty new line
		data2 = data.split(',')			# split each comma-separated line: creates data2 list
		liston.append(data2)			# append data2 in liston list
		## creates new meta-data file with the selected information:
		with open('good_SC3.tsv','w') as newfile:
			# selects item elements stored in liston list
			info = [[aa[0],aa[1],aa[7],aa[11],aa[27],aa[29]] for aa in liston] # Run,Age,collection_media,GEO_Accession,status,tissue
			# for each item stored in info
			for item in info:
				item = '\t'.join(item)		# convert from list to string of items tab-separated
				newfile.writelines(item+'\n')	# write item tab-separated item string to new meta-data file

control = []		# empty list: to store sample from normal tissue
sample = []		# empty list: to store sample from inflamed tissue

### open file with meta data information about the samples
with open('good_SC3.tsv') as ref:
	lines = ref.readlines()			# list of lines in meta-data file
	# for each line in lines list:
	for item in lines:
		inf = item.replace('\n','')	# replace/remove empty new line
		inf = inf.split('\t')		# split each line by tab-space: creates inf list
		# for each item in inf list:
		for item2 in inf:
			# if sample is cataloged as uninflamed
			if item2 == 'uninflamed':
				control.append(inf[0])		# append sample names for uninflamed in control list
			# if sample is cataloged as inflamed	
			if item2 == 'inflamed':
				sample.append(inf[0])		# append sample names for inflamed in sample list

## creates new file that stores sample name from normal tissue
with open('control.txt','w') as norm:
	# for each item in list that stores 'uninflamed' sample names
	for item in control:
		norm.writelines(item + '\n')	# write item to new meta-data file
		
## creates new file that stores sample name from inflamed tissue
with open('sample.txt','w') as inf:
	# for each item in list that stores 'inflamed' sample names
	for item in sample:
		inf.writelines(item + '\n')	# write item to new meta-data file






