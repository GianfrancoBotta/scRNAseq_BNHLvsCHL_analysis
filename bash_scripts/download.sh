#!/bin/sh
#sbatch --time=7199 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G download.sh (to submit the job to the server, 5 days is the maximum allowed time)
module load eth_proxy # to enable the nodes of the cluster to connect to internet and download data

cd /cluster/scratch/gbotta
if [ ! -e rawdata_BNHL ]; then
    mkdir rawdata_BNHL
fi
cd rawdata_BNHL

prefetch --option-file ../SRR_Acc_List_BNHL.txt --max-size 420000000000
cat ../SRR_Acc_List_BNHL.txt | xargs fasterq-dump --threads 8 --progress --include-technical
gzip *.fastq