#!/bin/bash
#sbatch --time=7199 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G pipeline.sh (to submit the job to the server, 5 days is the maximum allowed time)

# pipeline to pre-process single cell RNA-seq data and obtain the count matrix for each sample.

# download the data from NCBI using SRA run selector
sbatch --time=7199 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G download.sh

# change the name of the fastq.gz file in order to be used as input in cellranger
sbatch --time=999 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G cr_name.sh /cluster/scratch/gbotta/rawdata_BNHL

# quality control of the reads (R2) using fastqc
sbatch --time=7199 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G qc.sh

# visualize the quality control in a compact way
python visualize_qc.py

# run cellranger
sbatch --time=7199 --ntasks=1 --cpus-per-task=16 --mem-per-cpu=7G cellranger.sh

# move the count matrices to download them using scp
sbatch --time=999 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G mv_count_matrix.sh

# to download the data: scp -r <user_name>@<server_name>:/path/to/dowload /local/folder/to/copy