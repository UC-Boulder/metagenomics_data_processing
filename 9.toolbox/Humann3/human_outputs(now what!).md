# Humann Output

So you've managed to run Humann. Great! ... now what to do you do with a million output files?! Well let's work  through each output one by one. 

## metaphlan_bugs_list.tsv

This file provides the metaphlan relative taxonomic abundance for each sample. This will be located in your output directory, in the temporary subdirectory for each sample. So lets move each samples bugs_list to one directory:

``` bash
cd /scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/hyphy_output

# Create the destination directory if it doesn't exist
mkdir -p "$hyphy_bugs"

# Define the source and destination directories
source_dir="/scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/hyphy_output"
hyphy_bugs="/scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/hyphy_bugs"

# Loop through each subdirectory in the source directory
for dir in "$source_dir"/*; do
  # Check if the current item is a directory
  if [ -d "$dir" ]; then
    # Loop through each file in the current directory
    for file in "$dir"/*; do
      # Check if the file contains "bulglist" in its name
      if [[ "$file" == *bugs_list.tsv ]]; then
        # Copy the file to the destination directory
        cp "$file" "$hyphy_bugs"
      fi
    done
  fi
done
```