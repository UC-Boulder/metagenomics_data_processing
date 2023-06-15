#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=20:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=qc_mothersmilk_fulldata_june15
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

module purge
module load anaconda
module load perl

conda activate /projects/$USER/software/anaconda/envs/metaair_env
export PATH=$PATH:/curc/sw/install/bio/bedtools/2.29.1/bin/
export PATH=$PATH:/curc/sw/install/bio/bbtools/bbmap/
export PATH=$PATH:/scratch/alpine/emye7956/MetaAir/FastQC/
export PATH=$PATH:/scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/
export PHYLOFLASH_DBHOME=/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/138.1
cd /scratch/alpine/emye7956/mothersmilk/mg_data_labmac/fastq

export outer_dir=/scratch/alpine/emye7956/mothersmilk/mg_data_labmac/fastq/
export trimmomatic_loc=/scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/trimmomatic-0.39.jar
export phyloflash_loc=/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/phyloFlash.pl
for outer_folder in "$outer_dir"*; do
    for infile in $(ls "$outer_folder/"*_1.fq.gz); do
        inner_dirname=$(basename $outer_folder);
        new_dirname=/scratch/alpine/emye7956/mothersmilk/mg_data_labmac/fastq/$inner_dirname

        mkdir -pv $new_dirname
        mkdir -pv $new_dirname/trimmed_output

        base=$(basename ${infile} _1.fq.gz)
        outer_path=$(dirname ${infile})
        common_prefix="$outer_path/$base"
        echo "common_prefix=$common_prefix"

        mkdir -pv $new_dirname/fastqc1_output

        echo "FASTQC 1 for ${common_prefix}"
        fastqc ${common_prefix}_1.fq.gz ${common_prefix}_2.fq.gz -o $new_dirname/fastqc1_output

    done
done
