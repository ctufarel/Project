# Run each line in the folder where are stored all .bam files (Bam_Pat_Server, Bam_Server, Bam_Cells)
find . -type f -name \*.bam -exec cp -t /rfs/Transposons/Shared/Raquel_Pro/Patients/Bam_patients/ {} +
find . -type f -name \*.bam -exec cp -t /rfs/Transposons/Shared/Raquel_Pro/Inflammation/Bam_inflam/ {} +
#find . -type f -name \*.bam -exec cp -t /rfs/Transposons/Shared/Raquel_Pro/Cell_lines/Bam_cells/ {} + (bam files generated but not further analysed)
