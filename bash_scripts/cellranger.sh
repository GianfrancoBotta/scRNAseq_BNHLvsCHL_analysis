#!/bin/sh
#sbatch --time=7199 --ntasks=1 --cpus-per-task=16 --mem-per-cpu=7G cellranger.sh (to submit the job to the server)
# cellranger needs 8CPUs (16 better) and a total RAM of at least 64GB

# run cellranger on the reads (R2) of the samples in rawdata_BNHL after renaming them using cr_name.sh.

transcriptome="/cluster/scratch/gbotta/refdata-gex-GRCh38-2020-A"
rawdata_folder="/cluster/scratch/gbotta/rawdata_BNHL"

# create the output directory for the cellranger results
cd /cluster/scratch/gbotta
if [ ! -e cellranger_results ]; then
    mkdir cellranger_results
fi
cd cellranger_results

# loop through each fastq file in the raw data folder
for fastq_file in "$rawdata_folder"/*R2_001.fastq.gz; do
    # extract the sample name from the fastq file name
    sample=$(basename "$fastq_file" .fastq.gz)
    trimmed_sample=$(echo "$sample" | awk -F_ '{print $1}')
    
    # run cellranger count for the current sample
    cellranger count --id="${trimmed_sample}" \
                     --transcriptome="$transcriptome" \
                     --fastqs="$rawdata_folder" \
                     --sample="$trimmed_sample" \
                     --localcores=16 \
                     --localmem=100
done