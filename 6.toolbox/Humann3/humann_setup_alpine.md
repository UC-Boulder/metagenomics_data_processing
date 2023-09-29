---
title: "humann_alpine"
author: "Emily Yeo"
date: "`June 13 2023`"
output: html_document
---

# Humann3 on Alpine

[HUMAnN 3.0](https://huttenhower.sph.harvard.edu/humann/) is a pretty
sweet software tool for profiling the presence and abundance of
microbial pathways in a community from metagenomic or metatranscriptomic
sequencing data . It is part of the [bioBakery
suite](https://huttenhower.sph.harvard.edu/tools/) of tools, which also
includes [KneadData](https://github.com/biobakery/kneaddata) and
[MetaPhlAn](https://github.com/biobakery/MetaPhlAn).

The output files you will get from humann are below. I strongly suggest
checking out what each of them can be used for in more detail
[here](https://github.com/biobakery/humann#guides-to-humann-utility-scripts).

-   **Gene families:** This file contains the gene families predicted by
    HUMAnN and their corresponding abundances in the sample. The file is
    in the TSV format and includes the gene family name and its
    abundance.

-   **Pathways abundance:** This file contains the pathways predicted by
    HUMAnN and their corresponding abundances in the sample. The file is
    in the TSV format and includes the pathway name and its abundance.

-   **Pathway Coverage:** This file (usually named "pathcoverage.tsv")
    contains information about the coverage of each metabolic pathway in
    the metagenomic sample. Each row represents a pathway, and each
    column represents a sample. The values indicate the percentage of
    the pathway covered by reads in each sample.

[Intermediary files:]{.underline} Each sample will will also have an
output directory that contains the following intermediate files:

-   **Bowtie2_aligned:** This will be both a sam and a tsv file. These
    show the alignment output from bowtie2.

-   **Bowtie2_unaligned.fa**: This is a fasta file of unaligned reads
    after the Bowtie2 step, and are the reads that will be provided as
    input in the translated alignment step.

-   **custom_chocophlan_database.ffn** : his file is a custom ChocoPhlAn
    database of fasta sequences.

-   **metaphlan_bowtie2.txt:** This file is the Bowtie2 output from
    MetaPhlAn.

-   **metaphlan_bugs_list.tsv:** This file is the bugs list output from
    MetaPhlAn.

-   **diamond_aligned.tsv:** HUMAnN3 employs DIAMOND, a fast alignment
    tool, for aligning reads against protein databases. DIAMOND
    generates this intermediary output tsv file that store the
    alignments of reads to the protein sequences.

    ------------------------------------------------------------------------

Now that you're all excited for the possibilities with Humann, how the
heck do you use it? ...

## Creating a Humann3 environment on Alpine

There are 2 ways to do this. The manual way (installing everything one
at a time), or the sneaky speedy way that involves running the yaml file
named
"[emily_humann_env.yaml](https://github.com/UC-Boulder/metagenomics_data_processing/blob/main/9.toolbox/Humann3/emily_humann_env.yaml)"
that's in the git hub directory (you'll need to download it and save it
to your alpine directory). I'll go through both methods step by step
below.

####  - Option 1: Everything from scratch -

Log into the cluster, get onto a compute node and cd to your scratch
alpine. Then:

1\. Load conda

``` bash
module load anaconda
```

2.Create the humann environment

``` bash
conda create -n humann_env python=3.7
```

3\. Activate the environment

``` bash
 conda activate humann_env
```

4\. Move to your environment directory and download human:

Note that the git clone was done in addition to the pip install to be
able to run the demo examples. This is unnecessary if you don't want to
do that (although I recommend).

``` bash
cd /projects/emye7956/software/anaconda/envs/humann_env
```

``` bash
git clone https://github.com/biobakery/humann
```

``` bash
pip install humann
```

5\. Install bowtie2

``` bash
conda install bowtie2
```

6\. Install metaphlan and then all the dependencies:

``` bash
pip install metaphlan
```

``` bash
metaphlan --install --bowtie2db
```

``` bash
metaphlan --install
```

7\. Test out humann on a the example demo:

A batch script was written to do this because more RAM was required for
the run. I uploaded the bash script in this git hub folder as "demo.sh".
You would need to change the input and output paths before running it:

``` bash
humann --test
```

``` bash
sbatch demo.sh 
```

8\. Download the real databases. If the demo.sh run worked, your
environment is good to go. But now you need to download the full
nucleotide and protein databases before running it on your our samples.
This is how to do that:

\# downlaod the main database (not demo)

``` bash
humann_databases --download chocophlan full /projects/emye7956/software/anaconda/envs/humann_env
```

\# downlaod a translated search database

``` bash
humann_databases --download uniref uniref90_diamond /projects/emye7956/software/anaconda/envs/humann_env
```

9\. Run your own data:

this example sbatch
[script](https://github.com/UC-Boulder/metagenomics_data_processing/blob/main/9.toolbox/Humann3/humans_bash_script.sh)
is also in the github humann3 directory

``` bash
sbatch humann_bash_script.sh
```

####  - Option 2: Using the sneaky YAML shortcut instead -

Log into the cluster, get onto a compute node and cd to your scratch
alpine. Upload the
"[emily_humann_env.yaml](https://github.com/UC-Boulder/metagenomics_data_processing/blob/main/9.toolbox/Humann3/emily_humann_env.yaml)"
file to the directory you will be working in (sftp it or use
[ondemand](https://ondemand.rc.colorado.edu/)).

1\. Load conda and read the yaml file "emily_human_env.yaml" to set up
the environment:

``` bash
module load anaconda
```

``` bash
conda env create --file=emily_human_env.yaml
```

2\. Enter the environment and make sure all your dependencies are there.
You should see a list of dependencies that were downloaded.

``` bash
conda activate humann_env_yaml
```

``` bash
conda env export
```

3\. Once that is done, and you've entered the environment, manually
install the databases you will need:

``` bash
cd /projects/emye7956/software/anaconda/envs/humann_env_yaml
```

\# downlaod the main database (not demo)

``` bash
humann_databases --download chocophlan full /projects/emye7956/software/anaconda/envs/humann_env
```

\# downlaod a translated search databases

``` bash
humann_databases --download uniref uniref90_diamond /projects/emye7956/software/anaconda/envs/humann_env
```

``` bash
humann_test
```

4. run humann on your own samples (take a look at the bash script
example
"[humann_bash_script.sh](https://github.com/UC-Boulder/metagenomics_data_processing/blob/main/9.toolbox/Humann3/humans_bash_script.sh)"

Note that the bash script should include multiple threads (here used
32).

#### Use the tutorial "humann_outputs" next to help you work through all the outputfiles
