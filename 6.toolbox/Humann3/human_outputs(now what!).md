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
but I have different studies that I want to seperate by so I am making subdirectories for all those studies and then moving them into it: 

```bash
cd /scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/all_bugs

mkdir hyphy_bugs
mkdir metaair_bugs
mkdir metachem_bugs
mkdir blank_bugs
mkdir gap_bugs

# move all the files into those directories 
mv *HYPHY* hyphy_bugs/
mv *MetaAir* metaair_bugs/
mv *MetaChem* metachem_bugs/
mv *BLANK* blank_bugs/
mv *GAP* gap_bugs/
```
shweeeet, now things are a little more ordered for the metaphlan taxonomic outputs. Now I want to move these directories to my computer to import into R. So in my terminal, I cd to where I want the files to be on my computer. I sftp onto the cluster and then ove the files I want: 

```bash
cd Volumes/IPHY/ADORLab/Lab\ Projects/MetaAIR/Metagenomics/metaphlan_output 

sftp emye7956@login.rc.colorado.edu
cd /scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4/

get -r all_bugs
```

Great, now I want to put all these tables into R so I can check things out. So open up a new script and do the following: 

```R



```
