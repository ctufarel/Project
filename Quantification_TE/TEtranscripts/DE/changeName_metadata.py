# Script that modifies the raw sample names in the count expression Table (TEtranscripts raw output), and generated metadata csv files for downstream analysis in R 
all = ''   # empty string variable
lista = [] # creates empty list to store modified sample names
with open('/home/rpg18/Desktop/TFM/Server_alice2/Pipelines_scripts/TEtranscript/Sample_infl/rev_infl.cntTable') as ref:	# old-original TEtranscripts counting matrix
	with open('rev_infl_changed.cntTable4', 'w') as ref2: # new counting matrix
		lines = ref.readlines()				 # generates lines list from original counting matrix file
		samples = lines[0].replace('\n','')	 # extract first item (line) of lines list and replace new line (samples = header)
		names = samples.split('\t')		# generates list comma-separating items if they are tab space-separated (each sample name is a new item member of names list)
		# for each item in names list:
		for line in names:
			# if the item starts with '/home/' (all sample names share the same prefix)
			if line.startswith('/home/'):
				prefix = line.replace('/home/raquel/Desktop/RFS_ALICE2/Inflammation/Bam_inflam/', '') # prefix of the original sample name
				# if ends with 'C' for control, or 'T' for mutant (tumour)
				if prefix.endswith('.C') or prefix.endswith('.T'):
					suffix = prefix.replace('Aligned.sortedByCoord.out.bam', '') # eliminate suffix of the original sample
					all += suffix + '\t'	# store each new sample names in tab separated line (same original counting matrix format)
					lista.append(suffix)	# append 'all' (modified sample names) to lista list
		ref2.write('gene/TE' + '\t')	# write header (first left row) the new counting matrix file
		ref2.writelines(all)		# write all modified sample names the new counting matrix file
		ref2.write('\n')		# add empty line (start writing in next line) in the new counting matrix file
		counts = lines[1:]		# counting matrix with RefSeq accession numbers and counts
		# for each row in counting matrix:
		for count in counts:
			ref2.writelines(count)		# write these new rows in the new counting matrix file

# function that generates new metadata files with the subset of inflammation dataset used in the DE analysis (67 samples in total)
def metadata(file):
	new = ''	# empty variable where to store items in comma-separated strings
	with open(file) as ref:
		file = file.replace('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/','')
		with open('new_'+file, 'w') as ref2:
			lines = ref.readlines()		# generates list of each input file row
			sam = lines[1:]				# all rows but first row
			# for each item in sam list
			for line in sam:
				line = line.split(',')			# creates list of items comma-separated
				# for each item in lista list (sample names)
				for name in lista:
					# if sample name starts with first item in sam list (sample name)
					if name.startswith(line[0]):		
						new += name+","+line[1]			# stores sample-name and condition in comma-separated line
			ref2.write('SampleID,tissue')		# writes first row in new metadata file
			ref2.write('\n')			# writes a new empty line in new metadata file
			ref2.writelines(new)			# writes sample and condition information stored in 'new' variable in new metadata file

# run metadata function to parse metadata files generated from complete inflammation dataset (a total of 71 samples)
metadata('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/tissue_type.csv') # tissue raw metadata file 
metadata('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/dmso_RNAlater.csv') # method raw metadata file
metadata('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/age.csv') # age raw metadata file
