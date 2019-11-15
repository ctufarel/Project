### Script that filters all LINE-1 elements from unmasked hg19 genome annotation file provided by TEtranscripts: http://hammelllab.labsites.cshl.edu/software/ 

# open the hg19 annotation file with all TEs
with open("hg19_rmsk_TE.gtf") as file:
	lines = file.readlines() 			# each line of the file as a list
	# creates a new L1 annotation file
	with open("hg19_L1.gtf",'w') as ref:	
		# for each item in lines list
		for line in lines:
			line = line.replace('\n','')		# replace/remove empty new line spaces
			line = line.split('\t')				# generates a list of tab-separated items
			# if item in position 8 ends as:
			if line[8].endswith('family_id "L1"; class_id "LINE";'):
				line = '\t'.join(line)			# generate string of tab-separated items
				ref.writelines(line +'\n')		# write each line in a row of the new annotation file
