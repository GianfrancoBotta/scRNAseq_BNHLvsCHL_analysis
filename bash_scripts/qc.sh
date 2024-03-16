#!/bin/sh
#sbatch --time=7199 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G qc.sh (to submit the job to the server, 5 days is the maximum allowed time)

# control the quality of the fastq files we downloaded from NCBI using SRA run selector.

cd /cluster/scratch/gbotta
if [ ! -e fastqc ]; then
    mkdir fastqc
fi
cd rawdata_BNHL

fastqc -o ../fastqc *.fastq.gz

cd /cluster/scratch/gbotta/fastqc

for file in *.zip; do
    unzip -q "$file" -d "${file%.zip}"
    # rm "$file" (to remove the original .zip file)
done