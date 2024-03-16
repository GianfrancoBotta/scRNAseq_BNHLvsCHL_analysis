#!/bin/bash
#sbatch --time=999 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G mv_count_matrix.sh (to submit the job to the server)
# moving the outs folders of each sample in cellranger_results into cellranger_outputs, renaming each outs file with its sample name

# source directory
source_dir="/cluster/scratch/gbotta/cellranger_results"

# destination directory
destination_dir="/cluster/scratch/gbotta/cellranger_counts"

# file containing names for renaming
names_file="/cluster/scratch/gbotta/SRR_Acc_List_BNHL.txt"

# ensure the destination directory exists
if [ ! -e "$destination_dir" ]; then
    mkdir -p "$destination_dir"
fi

# read names from the file
while IFS= read -r name; do
    # check if the "outs" folder exists
    if [[ -d "$source_dir/$name/outs/filtered_feature_bc_matrix" ]]; then
        # move the "outs" folder to the destination directory and rename it
        mv "$source_dir/$name/outs/filtered_feature_bc_matrix" "$destination_dir/$name"
    else
        echo "Folder 'filtered_feature_bc_matrix' not found in $name"
    fi
done < "$names_file"