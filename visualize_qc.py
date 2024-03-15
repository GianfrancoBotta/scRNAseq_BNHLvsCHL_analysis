import os
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import pandas as pd

# script to visualize the quality control metrics of the fastq files for each sample.

# define the path to the fastqc folder
fastqc_folder = '/cluster/scratch/gbotta/fastqc/reads'

# initialize a nested dictionary to store the results
data = {}

# function to search for summary.txt files recursively only if they are from R2
def find_summary_files(folder):
    for root, dirs, files in sorted(os.walk(folder)):
        for file_name in files:
            if file_name == 'summary.txt':
                summary_file = os.path.join(root, file_name)
                file_data = {}  # nested dictionary for the file
                with open(summary_file, 'r') as file:
                    for line in file:
                        parts = line.strip().split('\t')
                        if len(parts) == 3:
                            status, attribute, file_name = parts  # we do not need the file name
                            if status == "PASS":
                                file_data[attribute] = 1
                            elif status == "WARN":
                                file_data[attribute] = 0
                            if status == "FAIL":
                                file_data[attribute] = -1
                data[file_name.replace('.fastq.gz','')] = file_data

# find and parse all summary.txt files
find_summary_files(fastqc_folder)

# create a DataFrame from the data
df = pd.DataFrame.from_dict(data, orient='index')
#df = df.iloc[::-1]
print(df)

# define custom colormap
cmap = sns.color_palette(["#FF6B6B", "#FFD93D", "#6BCB77"])  # Specify colors explicitly

# set up the heatmap
plt.figure(figsize=(12, 10))
sns.heatmap(df.T, linewidths=0.1, linecolor='white', fmt='s', cmap=cmap, cbar=False,
            xticklabels=list(df.T.columns), yticklabels=list(df.T.index))

# set labels and title
plt.xlabel('Accession Number')
plt.ylabel('Attribute')
plt.title('FastQC Summary')

# show the plot
plt.tight_layout()
#plt.show()
plt.savefig("QC.png")
plt.savefig("QC.pdf")