# **Code for using Trimmomatic to trim low quality sections of your fastq files**

## What does Trimmomatic do? 
Trimmomatic performs a variety of useful trimming tasks for illumina paired-end and single ended data.The selection of trimming steps and their associated parameters are supplied on the command line.

The current trimming steps are:

ILLUMINACLIP: Cut adapter and other illumina-specific sequences from the read.

SLIDINGWINDOW: Perform a sliding window trimming, cutting once the average quality within the window falls below a threshold.

LEADING: Cut bases off the start of a read, if below a threshold quality

TRAILING: Cut bases off the end of a read, if below a threshold quality

CROP: Cut the read to a specified length

HEADCROP: Cut the specified number of bases from the start of the read

MINLEN: Drop the read if it is below a specified length

TOPHRED33: Convert quality scores to Phred-33

TOPHRED64: Convert quality scores to Phred-64

It works with FASTQ (using phred + 33 or phred + 64 quality scores, depending on the Illumina pipeline used), either uncompressed or gzipp'ed FASTQ. Use of gzip format is determined based on the .gz extension.

For single-ended data, one input and one output file are specified, plus the processing steps. For paired-end data, two input files are specified, and 4 output files, 2 for the 'paired' output where both reads survived the processing, and 2 for corresponding 'unpaired' output where a read survived, but the partner read did not.

[**GitHub page for Trimmomatic**](https://github.com/usadellab/Trimmomatic)


## **Setting up an environment with conda**
conda create -n quality # this makes a new conda environment named "quality"
	# If you already went through the fastQC tutorial in this folder and ran the conda install with all of the quality tools I listed, you might already have this environment and trimmomatic. 
	# you can run "conda list" to see what tools are in an active environment if you want to check this. If it isn't there, continue with the next few steps
conda activate quality # activate the environment you just made before installing anything
conda install -c bioconda trimmomatic
	### this uses bioconda to install trimmomatic and required dependencies

## Code to use Trimmomatic
### What is this code doing? 
You would run this in a directory containing your raw fastq files which you would like to trim. 
The for loop assumes you have an R1 and R2 for a number of samples within this directory. 
It will only loop through a sample once but will be able to utilize both the R1 and R2.

I set the number of threads here to be 10. This isn't a particularly intensive job so don't need a lot. Trimlog, summary, and baseout specify the output types I want and where they will go. 
validatePairs lists the R1 and R2 to be used. 
Finally, the sliding window, trailing and milen at the end are all described in more detail above but are used to increase or decrease stringency with the trimming steps. 

```{bash eval=FALSE}
#!/bin/bash

for infile in *_R1_001.trimmed.fastq.gz; do
    base=$(basename ${infile} _R1_001.trimmed.fastq.gz)
    echo "Running sample ${base}"

    echo "Trimmomatic for ${base}"
    trimmomatic PE -threads 10 -trimlog trimmed_output/${base}.trimlog -summary trimmed_output/${base}.trim.log -validatePairs ${base}_R1_001.fastq.gz ${base}_R2_001.fastq.gz -baseout trimmed_output/${base}.trimmed SLIDINGWINDOW:4:20 LEADING:20 TRAILING:20 MINLEN:50
done
```