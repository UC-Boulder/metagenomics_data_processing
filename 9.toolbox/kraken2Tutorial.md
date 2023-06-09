---
title: "kraken2"
author: "Maria  Coffman"
date: "2023-06-09"
output: pdf_document
---

# **Kraken2 tutorial**

The following code was run on microbe server.

[**GitHub for Kraken2**](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown)

## Background

Kraken is a taxonomic sequence classifier that assigns taxonomic labels to DNA sequences. Kraken examines the k-mers within a query sequence and uses the information within those k-mers to query a database. That database maps k-mers to the lowest common ancestor (LCA) of all genomes known to contain a given k-mer.

-   More in depth methods can be found on the GitHub link posted above if you're extra curious :-)

## Requirements

-   **Disk space**: Construction of a Kraken 2 standard database requires approximately 100 GB of disk space. A test on 01 Jan 2018 of the default installation showed 42 GB of disk space was used to store the genomic library files, 26 GB was used to store the taxonomy information from NCBI, and 29 GB was used to store the Kraken 2 compact hash table.

    Like in Kraken 1, we strongly suggest against using NFS storage to store the Kraken 2 database if at all possible.

-   **Memory**: To run efficiently, Kraken 2 requires enough free memory to hold the database (primarily the hash table) in RAM. While this can be accomplished with a ramdisk, Kraken 2 will by default load the database into process-local RAM; the `--memory-mapping` switch to `kraken2` will avoid doing so. The default database size is 29 GB (as of Jan. 2018), and you will need slightly more than that in RAM if you want to build the default database.

-   **Dependencies**: Kraken 2 currently makes extensive use of Linux utilities such as sed, find, and wget. Many scripts are written using the Bash shell, and the main scripts are written using Perl. Core programs needed to build the database and run the classifier are written in C++11, and need to be compiled using a somewhat recent version of g++ that will support C++11. Multithreading is handled using OpenMP. Downloads of NCBI data are performed by wget and rsync. Most Linux systems will have all of the above listed programs and development libraries available either by default or via package download.

    Unlike Kraken 1, Kraken 2 does not use an external k-mer counter. However, by default, Kraken 2 will attempt to use the `dustmasker` or `segmasker` programs provided as part of NCBI's BLAST suite to mask low-complexity regions (see [Masking of Low-complexity Sequences]).

    **MacOS NOTE:** MacOS and other non-Linux operating systems are *not* explicitly supported by the developers, and MacOS users should refer to the Kraken-users group for support in installing the appropriate utilities to allow for full operation of Kraken 2. We will attempt to use MacOS-compliant code when possible, but development and testing time is at a premium and we cannot guarantee that Kraken 2 will install and work to its full potential on a default installation of MacOS.

    In particular, we note that the default MacOS X installation of GCC does not have support for OpenMP. Without OpenMP, Kraken 2 is limited to single-threaded operation, resulting in slower build and classification runtimes.

-   **Network connectivity**: Kraken 2's standard database build and download commands expect unfettered FTP and rsync access to the NCBI FTP server. If you're working behind a proxy, you may need to set certain environment variables (such as `ftp_proxy` or `RSYNC_PROXY`) in order to get these commands to work properly.

    Kraken 2's scripts default to using rsync for most downloads; however, you may find that your network situation prevents use of rsync. In such cases, you can try the `--use-ftp` option to `kraken2-build` to force the downloads to occur via FTP.

-   **MiniKraken**: At present, users with low-memory computing environments can replicate the "MiniKraken" functionality of Kraken 1 in two ways: first, by increasing the value of *k* with respect to ℓ (using the `--kmer-len` and `--minimizer-len` options to `kraken2-build`); and secondly, through downsampling of minimizers (from both the database and query sequences) using a hash function. This second option is performed if the `--max-db-size` option to `kraken2-build` is used; however, the two options are not mutually exclusive. In a difference from Kraken 1, Kraken 2 does not require building a full database and then shrinking it to obtain a reduced database.

## Setting up a conda environment

```{bash eval=FALSE}
conda create -n metagen 
conda activate metagen
conda install -c bioconda kraken2
  # when you use conda to install kraken2, it will also install all of its dependencies! 
```

## Installing a database

The instructions on kraken2 GitHub for installation are a bit outdated. There appears to be a problem with their script which does not allow proper installation of the database. Instead you will use wget with the database of your choice!

[**Databases**](https://benlangmead.github.io/aws-indexes/k2)

The link above will take you to a website with download links for many different databases. Depending on space available to you/what you are trying to do, you might select different databases. For MetaAir, HYPHY, GAP, MetaChem taxonomic classifications, the standard 67GB database was used.

To load the database, navigate to where you would like to install it and then run the following chunk!

```{bash eval =FALSE}
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20230314.tar.gz
```

Once the tar.gz file has been installed, you will need to unzip it before using. You can use:

```{bash eval =FALSE}
unzip xzf genome-idx.s3.amazonaws.com/kraken/k2_standard_20230314.tar.gz
```

## Basic usage

The following script is what was used for basic taxonomic classification. To run in command line "bash *name of the file*.sh".

-   Your conda environment will need to be activated when you run this.

-   You might want to run this in a screen since it will take several hours. A screen allows you to close terminal, turn your computer off, etc. without killing the process that is running.

    -   [screens](https://www.geeksforgeeks.org/screen-command-in-linux-with-examples/) (for more details)

    -   Basic usage

        -   **screen** to start a screen session

        -   **Ctrl-a + d** to detach from the screen and return to your primary terminal window.

        -   **screen -r** to resume the screen window

            -   If you have multiple screens going, it will list them then you can use **screen -r *name of screen*** to resume.

```{bash eval=FALSE}
#!/bin/bash
for infile in *_R1_001.trimmed.fastq.gz; do
    base=$(basename ${infile} _R1_001.trimmed.fastq.gz)
    echo "Running sample ${base}"

    kraken2 --db /data/coffmanm/tools/krakenBig --threads 10 --output /data/coffmanm/metaair_metagenomics/per_sample_FASTQ/172621/krakenOut/${base}.output.txt --report /data/coffmanm/metaair_metagenomics/per_sample_FASTQ/172621/krakenOut/${base}.report.txt --use-mpa-style --report-zero-counts --gzip-compressed --use-names --paired ${base}_R1_001.trimmed.fastq.gz ${base}_R2_001.trimmed.fastq.gz
done
```

-   The loop will run through each sample once

    -   This script loops over files that match the pattern **`*_R1_001.trimmed.fastq.gz`** and will assign "base" to be everything before **`_R1_001.trimmed.fastq.gz`**. This is important as each sample has two different fastq files.

-   using the kraken2 command

    -   \--db = specify the file path to your database directory

    -   \--threads = how many threads you want to use

    -   \--output = specify the file path/name of the output files

    -   \--report = specify the file path/name of the report files

    -   \--use-mpa-style = makes the report format nicely, similar to MetaPhlAn's output (k\_\_, p\_\_, etc.)

    -   \--report-zero-counts = includes a row for taxa even if it is 0 in that sample. This makes the code to concatenate all samples easier.

        -   By default, taxa with no reads assigned to (or under) them will not have any output produced. However, if you wish to have all taxa displayed, you can use the `--report-zero-counts` switch to do so. This can be useful if you are looking to do further downstream analysis of the reports, and want to compare samples

    -   \--gzip-compressed = the format of our input files

    -   \--use-names = Kraken 2 will replace the taxonomy ID column with the scientific name and the taxonomy ID in parenthesis (e.g., "Bacteria (taxid 2)" instead of "2")

    -   \--paired = need to include both R1 and R2 for paired end reads

        -   use "base" which was specified earlier (it is the part of the file name which is common for both R1 and R2) then you will need to type out the rest. **I strongly recommend using echo on all of your commands before trying to run to make sure everything looks like you want it!**

## Moving files to your computer for work in R

**scp** **-r** *PATH_FOR_WHAT_YOU_WANT_TO_MOVE PATH_FOR_WHERE_YOU_WANT_IT_TO_GO*

-   you need to run this in a terminal window which is not ssh'd into a server

-   you will need to put in your password for any server you're trying to access/get files from

## Formatting taxa table in R

The following code is what was used in R to make one single taxa table for all of the MetaAir, MetaChem, HYPHY, and GAP samples

```{r eval = FALSE}
# set up 
pacman::p_load(tidyverse, dplyr, magrittr,stringr)
rm(list = ls())

# moving into the full data folder to make the read in command work
setwd("~/Documents/projects/metagenomicProcessinng/metaAirChemGapHyphy/krakenOut/reports")

# making a list of all the files names ----
myFiles <- list.files(path = ".", all.files = TRUE,
                      full.names = FALSE, recursive = FALSE)
myFiles <- myFiles[-c(1:2)]
myFiles <- sub("_L.*", "", myFiles) 

# reading in the files ----
dat <- list.files(pattern="*.txt") %>% 
  lapply(read.delim, header=FALSE)

# changing back to the parent directory
setwd("~/Documents/projects/metagenomicProcessinng/metaAirChemGapHyphy/")
names(dat) <- myFiles

# merging the contents of the list into a single dataframe
merged_df <- Reduce(function(x, y) merge(x, y, by = "V1", all = TRUE), dat)
colnames(merged_df)[-1] <- myFiles

# write.csv(merged_df, "taxTabALLJune5.csv")
```
