#!/bin/bash
''' Script 1: Filtering and bed conversion of TECDetec GTF output files '''

# arguments for filtering script
var1='./patients_gtf/'
var2='./inflam_gtf/'
var3='./cell_lines_gtf/'
# arguments for bed conversion script
bed_var1='patients_gtf'
bed_var2='inflam_gtf'
bed_var3='cell_lines_gtf'

# Filtering:
python3 filter_bed.py $var1 $var2 $var3
# Bed conversion:
sh bed_file.sh $bed_var1
sh bed_file.sh $bed_var2
sh bed_file.sh $bed_var3
