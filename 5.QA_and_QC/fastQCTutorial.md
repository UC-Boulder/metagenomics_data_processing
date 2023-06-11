# **Code for running quality checking with fastqc**

## Why should you do a quality check and what is fastqc? 
It is important to run some kind of quality checking step prior to any kind of processing step as it is always a good idea to familiarize yourself with your data. 

FastQC is a program designed to spot potential problems in high througput sequencing datasets. 
It runs a set of analyses on one or more raw sequence files in fastq or bam format and produces a report which summarises the results
FastQC will highlight any areas where this library looks unusual and where you should take a closer look. 
The program is not tied to any specific type of sequencing technique and can be used to look at libraries coming from a large number of different experiment types (Genomic Sequencing, ChIP-Seq, RNA-Seq, BS-Seq etc etc).

[**GitHub page for fastQC**](https://github.com/s-andrews/FastQC)


## **Setting up an environment with conda**
conda create -n quality # this makes a new conda environment named "quality"
conda activate quality # activate the environment you just made before installing anything
conda install -c bioconda fastqc trimmomatic multiqc 
	### this uses bioconda to install required tools and their dependencies
	### I added a few other tools which I frequently used in quality and trimming but you could just do fastqc 

## What is this code doing? 
You would run this in a directory containing your fastq files. 
The for loop assumes you have an R1 and R2 for a number of samples within this directory. 
It will only loop through a sample once but will be able to utilize both the R1 and R2.

Using default parameters, you just need to provide the two reads and the output directory ("-o")

```{bash eval=FALSE}
#!/bin/bash

for infile in *_R1_001.trimmed.fastq.gz; do
    base=$(basename ${infile} _R1_001.trimmed.fastq.gz)
    echo "Running sample ${base}"

    echo "FASTQC 1 for ${base}"
    fastqc ${base}_R1_001.trimmed.fastq.gz ${base}_R2_001.trimmed.fastq.gz -o fastqc_output
done
```


## Suppose you've run your first fastqc and it was terrible. You've since run a trimming tool such as trimmomatic or sickle, now you want to check the quality again:

The loop above works very similarly to the first, you're just pulling the input files from the trimmed data rather than the raw files.
The only difference here is that you specify that your input reads will come from within the "trimmed_output" folder and defines that these new files will go within a different output directory. 

```{bash eval=FALSE}
#!/bin/bash
for infile in *_R1_001.trimmed.fastq.gz; do
    base=$(basename ${infile} _R1_001.trimmed.fastq.gz)
    echo "Running sample ${base}"

    echo "FASTQC 2 for ${base}"
    fastqc trimmed_output/${base}.trimmed_1P trimmed_output/${base}.trimmed_2P -o fastqc2_output
done
```

## MultiQC 
If you want to get a multiQC report which is essentially just a compiled version of the fastqc for all of your samples. 
You need to navigate to the directory with all of the fastqc output files (for this example you could use either fastqc_output or fastqc2_output). 
Once in that folder, making sure you have the conda environment activated which has multiqc in it and then run the following (doesn't need to be in a script)

```
multiqc .
```
Alternatively, you could specify a directory to the folder you wanted to analyze instead of the period (which just means do the command on the dir you're in.)
 