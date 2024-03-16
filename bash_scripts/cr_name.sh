#!/bin/sh
#sbatch --time=999 --ntasks=1 --cpus-per-task=8 --mem-per-cpu=12G cr_name.sh /cluster/scratch/gbotta/rawdata_BNHL (to submit the job to the server)

# function to rename files to use cellranger (cellranger requires a specific format for the file names).
rename_files() {
    local folder="$1"
    cd "$folder" || exit 1
    for file in *; do
        if [[ $file =~ ^(.*)_([0-9]+)\.fastq\.gz$ ]]; then
            accession="${BASH_REMATCH[1]}"
            index="${BASH_REMATCH[2]}"
            case $index in
                1)
                    new_name="${accession}_S1_I1_001.fastq.gz"
                    ;;
                2)
                    new_name="${accession}_S1_I2_001.fastq.gz"
                    ;;
                3)
                    new_name="${accession}_S1_R1_001.fastq.gz"
                    ;;
                4)
                    new_name="${accession}_S1_R2_001.fastq.gz"
                    ;;
                *)
                    echo "Invalid index: $index"
                    continue
                    ;;
            esac
            mv "$file" "$new_name"
            echo "Renamed $file to $new_name"
        fi
    done
}

# check if folder name is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 folder_name"
    exit 1
fi

# call the function to rename files
rename_files "$1"