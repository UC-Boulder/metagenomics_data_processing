# Humann Output

So you've managed to run Humann. Great! ... now what to do you do with a million output files?! Well let's work  through each output one by one. 

## metaphlan_bugs_list.tsv

This file provides the metaphlan relative taxonomic abundance for each sample. This will be located in your output directory, in the temporary subdirectory for each sample. So lets move each samples bugs_list to one directory:

``` bash
cd /scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/

# Create the destination directory if it doesn't exist
mkdir -p "$hyphy_bugs"

# Define destination directories
hyphy_bugs="/scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/hyphy_bugs"

for file in $(find . -name *bugs_list.tsv); do
  cp $file $hyphy_bugs/.;
done
```
