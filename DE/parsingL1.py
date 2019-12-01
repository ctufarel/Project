''' Script to parse output files generated from analysisDE.R script from both SalmonTE and TEtranscripts analysis. Use it to extract specific TE clades (e.g LINE-1) '''
## parsing function
def parsing(file,newfile):
	discard=[]		# empty list, to avoid repetitive items
	with open(file) as ref: # input file, which is the ouput from Differential expression analysis performed in R
		with open('clades.csv') as ref2:# all TE clades, file from SalmonTE pipeline
			with open(newfile,'w') as new:	# output file with filtered TE clades
				lines = ref.readlines()			# creates list of each line in file
				clades = ref2.readlines()		# creates list of each line in file clades.cdv
				header = ''.join(lines[0])		# extracts header from input file
				new.write('name	baseMean\tlog2FoldChange\tlfcSE\tstat\tpvalue\tpadj\tsuperfamily\tfamily\n')
				#new.write(header+'\n')
				# for-loop to parse clades file
				for clade in clades:
					clade = clade.replace('\n','')	# replace new line space for no space
					clade = clade.split(',') 		# splits lines by comma-separated
					superfamily = clade[1]			# extracts superfamily name
					family = clade[2]				# extracts family name			
					name = clade[0]					# extracts TE name
					# for-loop to parse input file
					for line in lines:
						line = line.replace('\n','')	# replace new line space for no space
						line = line.split('\t')			# splits lines by tab-separated
						# if TE name in input files is equal to TE name in clades file and family is equal to L1, or TE name (TEtranscripts nomenclature) is an L1:
						if (line[0] == name and family=='L1' not in discard) or (line[0].endswith(':L1:LINE') and line[0] not in discard): 
							discard.append(line[0])				# append in discard list parsed items
							clade_name = ''.join(superfamily)	# clade name as string
							line = '\t'.join(line)				# line as string = information related to TE in input file
							# writes parsed TE information lines from input file to a new file with information of interest, related to only LINE-1
							new.writelines(line+'\t'+clade_name+'\t'+family+'\n')
	
	return			

#parsing('infl.txt_0.4','infl.txt_0.4_annot')
#parsing('pat.txt_0.5','pat.txt_0.5_annot')
parsing('infl_TE_0.5','infl_TE_0.4_annot_L1')
parsing('pat_TE_0.5','x')
