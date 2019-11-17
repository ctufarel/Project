
all = ''
lista = []
with open('rev_infl.cntTable') as ref:
	with open('rev_infl_changed.cntTable', 'w') as ref2:
		lines = ref.readlines()
	#print(lines[0])
		samples = lines[0].replace('\n','')
		names = samples.split('\t')
		for line in names:
			if line.startswith('/home/'):
				prefix = line.replace('/home/raquel/Desktop/RFS_ALICE2/Inflammation/Bam_inflam/', '')
				if prefix.endswith('.C') or prefix.endswith('.T'):
			 
					suffix = prefix.replace('Aligned.sortedByCoord.out.bam', '') 
					all += suffix + '\t'
					lista.append(suffix)
		ref2.write('gene/TE' + '\t')
		ref2.writelines(all)
		ref2.write('\n')
		counts = lines[1:]
		for count in counts:
			ref2.writelines(count)

new = ''
with open('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/tissue_type.csv') as tis:
	with open('tissue_type_new.csv','w') as tis2:
		lines = tis.readlines()
		sam = lines[1:]
		for line in sam:
			line = line.split(',')
			for name in lista:
				if name.startswith(line[0]):
					new += name+","+line[1]
		tis2.write('SampleID,tissue')
		tis2.write('\n')
		tis2.writelines(new)

new2 = ''
with open('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/dmso_RNAlater.csv') as met:
	with open('dmso_RNAlater_new.csv','w') as met2:
		lines = met.readlines()
		sam = lines[1:]
		for line in sam:
			line = line.split(',')
			for name in lista:
				if name.startswith(line[0]):
					new2 += name+","+line[1]
		met2.write('SampleID,method')
		met2.write('\n')
		met2.writelines(new2)

new3 = ''
with open('/home/rpg18/Desktop/TFM/Pipelines/SCRIPTS/Meta_data/age.csv') as age:
	with open('age_new.csv','w') as age2:
		lines = age.readlines()
		sam = lines[1:]
		for line in sam:
			line = line.split(',')
			for name in lista:
				if name.startswith(line[0]):
					new3 += name+","+line[1]
		age2.write('SampleID,age')
		age2.write('\n')
		age2.writelines(new3)

