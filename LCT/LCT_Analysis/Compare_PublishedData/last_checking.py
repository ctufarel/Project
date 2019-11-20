# Script that compares pipeline-output with published data (https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-016-2800-5#Sec21): list of L1-ASP-5'end promoter-driven transcripts, which includes the annotated L1-ASP -> Compares geneName column of three files:

generef = ''	# empty string to store geneNames related to LCTs detected using RefSeq-hg19 annotation file
geneuc = ''		# empty string to store geneNames related to LCTs detected using UCSC-hg19 annotation file

with open('./Out_refseq/final_output.txt') as refseq:	# RefSeq-pipeline-output
	with open('./Out_ucsc/final_output.txt') as refucsc:	# UCSC-pipeline-output
		with open('./Annotation_hg19/article_L1-ASP_annot.csv') as refart:	# article's csv file output
			with open('very_final_output.csv','w') as csv:						# new csv file with L1-ASP related information from the article
				# read as list each row of all three output-files
				lines = refseq.readlines()	
				linesuc = refucsc.readlines()
				linesart = refart.readlines()
				# writes 'header' of the new csv file: information for each column
				csv.write('EST-chrom\tEST-start\tEST-end\tESTid\tEST-strand\tL1-ASP\tL1-strand\tgeneName\tgene-start\tgene-end\tgene-strand\n')
				## first for-loops to extract geneName of RefSeq output-file
				for line in lines[2:]:	# avoid first two rows from RefSeq-output file
					line = line.split('\t')		# generate list of items for each row
					generef += line[7]+'\n'		# all geneNames (one geneName per line)
					# inflammation L1-5'end annotation
					l1ref1 = line[4].split(';')	# full L1-5'end annotation item separated by ';'
					l1ref1 = l1ref1[3]			# extracts L1-5'end type
					# same procedure for tumour L1-5'end annotation
					l1ref2 = line[5].split(';') # full L1-5'end annotation item separated by ';'
					l1ref2 = l1ref2[3]			# extracts L1-5'end type
				## second for-loops to extract geneName of UCSC output-file (same steps)
				for lineuc in linesuc[2:]:
					lineuc = lineuc.split('\t')
					geneuc += lineuc[7] +'\n'
					l1uc1 = line[4].split(';')
					l1uc1 = l1uc1[3]
					l1uc2 = lineuc[5].split(';')
					l1uc2 = l1uc2[3]
				## last for-loop to extract geneName column from article's csv file
				for lineart in linesart[1:]:		# avoids first row from csv
					lineart = lineart.split(',')	# generates list of items comma separated in csv file
					geneart = lineart[7]			# extracts L1-ASP annotation
					#info = 'inflammation: '+l1ref1+' and '+l1ref2+'\ttumour: '+l1uc1+' and '+l1uc2+'\n'	# not used (optional)
					## check if geneName in article's csv is also found in both pipeline-outputs
					if geneart in geneuc or geneart in generef:
						#infoRefseq = '\t'.join(line[0:8])
						#infoUCSC = '\t'.join(lineuc[0:8])
						infoArt = '\t'.join(lineart[0:11]) 		  # column of interest from csv (article)
						csv.writelines(infoArt+'\n') #+info+'\n') # writes rows from genes found in all three files in new csv file 
		
