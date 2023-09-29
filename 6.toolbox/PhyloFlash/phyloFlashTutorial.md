# PhyloFlash 
[**GitHub for PhyloFlash**](https://github.com/HRGV/phyloFlash)
phyloFlash is a pipeline to rapidly reconstruct the SSU rRNAs and explore phylogenetic composition of an Illumina (meta)genomic or transcriptomic dataset.

[**Manual**](https://hrgv.github.io/phyloFlash/)
[**phyloFlash: Rapid Small-Subunit rRNA Profiling and Targeted Assembly from Metagenomes**](https://journals.asm.org/doi/10.1128/mSystems.00920-20)

## Basic Use 
This tutorial assumes you have already run quality check, trimmed your data, it has human seqs and adapters removed. 

### setting up conda 
I created an environment called phyloflash and put all of its dependencies in it.
``` 
conda create -n phyloflash 
conda install -c bioconda vsearch bedtools mafft bbmap spades bowtie2 # these are phyloflash dependencies 
```

### Database 

Download latest release:

First, navigate to where you want to install PhyloFlash
```
wget https://github.com/HRGV/phyloFlash/archive/pf3.4.tar.gz
tar -xzf pf3.4.tar.gz # unzip the tar

# Build the DB 
phyloFlash_makedb.pl --remote
```

## Basic Use
DO THIS IN A SCREEN IT WILL TAKE A LONG TIME!!! 

The script: this loops through R1/R2 files like all other tutorials in this GitHub page. AKA will run PhyloFlash ONCE per sample
```
#!/bin/bash
for infile in *_R1_001.trimmed.fastq.gz; do
    base=$(basename ${infile} _R1_001.trimmed.fastq.gz)
    echo "Running sample ${base}"

    echo "PHYLOFLASH for ${base}"
    phyloFlash.pl -lib ${base}_pl -read1 trimmed_output/${base}.trimmed_1P -read2 trimmed_output/${base}.trimmed_2P -almosteverything -readlength 150 -CPUs 10
done
```

Organize PhyloFlash output: make basic new subdirectory for all phyloFlash output 
```
mkdir phyOutput # make the directory
mv *phyloFlash* phyOutput # move all the files into the new dir
```

Unzipping all the tar files and puts them in the abundance folder:
``` 
#!/bin/bash 
for infile in *_pl.phyloFlash.tar.gz; do
    base=$(basename ${infile} _pl.phyloFlash.tar.gz)
    echo "Running sample ${base}"
    tar -xf ${base}pl.phyloFlash.tar.gz -C /data/coffmanm/metaair_metagenomics/per_sample_FASTQ/172621/phyOutput
done    
```

## Formatting in R
Once you have moved the output files to your own computer with the method of your choice (see file transfer tutorial)

The following code will take all of the individual output files (there will be a csv per sample) and combines them into a single taxa table which will be nice for running stats.

```
pacman::p_load(tidyverse, dplyr, magrittr,stringr)
rm(list=ls())

# moving into the full data folder to make the read in command work
setwd("~/Documents/projects/MetaAir metagenomics/dataDeep/NtuFull")

# making a list of all the files names ----
myFiles <- list.files(path = ".", all.files = TRUE,
                      full.names = FALSE, recursive = FALSE)
myFiles <- myFiles[-c(1:2)] # first two items in the list were "." and "..", this deletes those

# an example of the first item in the list is "0V0S_STO_HYPHY_S644_L004_pl.phyloFlash.extractedSSUclassifications.csv"

myFiles <- sub("_L.*", "", myFiles) 
# this shortens the file names so it cuts off everything after the "_L". I chose that string as it was common to all file names and was after the study name (need to keep that so we can filter by study later). 

# reading in the files ----
dat <- list.files(pattern="*.csv") %>% 
  lapply(read.csv, header=FALSE) # this reads in everything ending in ".csv" within the current directory

# changing back to the parent directory
setwd("~/Documents/projects/mnps/hyphy/metagenomicProcessinng/metagenomics/") # going back to project directory

# renaming list elements to file names ----
names(dat) <- myFiles # rename each item in the list to be its corresponding sample name

# add sample name column to each df ----
for (i in 1:(length(dat))) {
  dat[[i]]$sample <- names(dat[i])
}
# the above step is very important once we merge all data together, otherwise you will not know what data is for a given sample

# convert to a single df by rows ----
full <- as.data.frame(do.call(rbind, dat)) # binds to makes a long format df with all samples

full$sample <- sub("_S.*", "", hyphy$sample) # now shortening the sample ids even more since we no longer need to include the study name. Now everything following and including "_S" will be removed so only the 4 character sample id will remain.
  pivot_wider(names_from = sample, values_from = V2) %>% 
  rename(taxa = V1) # makes data wide and renames taxa column

# Split taxa column with ";" as the separator, the c() is the list of new column names. This step does NOT delete the original colum with all combined information. Repeated for each study data frame.
full[c("kingdom", "phylum", "class", "order", "family", "genus", "species")] <- str_split_fixed(full$taxa, ';', 7)

# output 
write_csv(full, "output/taxaTabFull.csv")
```
