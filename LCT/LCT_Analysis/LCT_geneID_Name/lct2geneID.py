''' Script-3 generates ./Annotation_hg19/geneID_UCSC.txt (var2), a file with RefSeq accession numbers extracted from annot_sorted.bed file. Then, it converts the accessions into gene names (./Annotation_hg19/annotated_genes.txt), using as a reference the hg19 ./Annotation_hg19/tablesUCSC.txt file (RefSeq-accession, chr strand, and gene name). Also, this script generates ./outpath/full_info.txt file, which is a new version of ./outpath/annot_sorted.bed that includes an extra gene name column '''

import sys
outpath=sys.argv[1]
var2 = sys.argv[2]	# ./Annotation_hg19/geneID_UCSC.txt

with open(str('./'+outpath+'/annot_sorted.bed')) as ref:
	with open(var2,'w') as new:
		lines = ref.readlines()
		for line in lines:
			gene = line.split('\t')
			new.writelines(gene[11]+'\n')

shared_genes = []
with open('./Annotation_hg19/tablesUCSC.txt') as ref:	# table generated using UCSC Table from hg19: RefSeq accession, strand, and gene name)
	with open(var2) as new:	# DE genes detected by TEtranscript
		lines = ref.readlines()
		de_genes = new.readlines()	# DE genes
		for line in lines:
			line = line.replace('\n','')
			line = line.split('\t')
			geneacc = line[0]
			genename = line[2]
			for de_gene in de_genes:
				de_gene = de_gene.replace('\n','')
				if de_gene == geneacc:	# DE gene is in
					shared_genes.append(genename)

	with open('./Annotation_hg19/annotated_genes.txt','w') as new2:
		for line in shared_genes:
			new2.writelines(line+'\n')

with open(str('./'+outpath+'/annot_sorted.bed')) as ref:
	with open('./Annotation_hg19/tablesUCSC.txt') as annot:
		with open(str('./'+outpath+'/full_info.txt'),'w') as new:
			lines = ref.readlines()
			inf = annot.readlines()
			for line in lines:
				gene = line.split('\t')
				acc_dec = gene[11]
				#info += gene[0]+'\t'+gene[1]+'\t'+gene[2]+'\t'+gene[5]+'\t'+gene[7]+'\t'+'|'+'\t'+gene[11]
				for col in inf:
					col = col.replace('\n','')
					col = col.split('\t')
					acc = col[0]
					name = col[2]
					if acc == acc_dec:
						new.writelines(gene[0]+'\t'+gene[1]+'\t'+gene[2]+'\t'+gene[5]+'\t'+gene[7]+'\t'+gene[11]+'\t'+'|'+'\t'+name+'\n')
