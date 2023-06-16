#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=trimmomatic_mm_june16
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

cd /scratch/alpine/emye7956/mothersmilk/mg_data_labmac/fastq

export outer_dir=/scratch/alpine/emye7956/mothersmilk/mg_data_labmac/fastq/
export trimmomatic_loc=/scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/trimmomatic-0.39.jar

for outer_folder in "$outer_dir"*; do
    if [ "$(basename "$outer_folder")" != "broken" ]; then
        for infile in $(ls "$outer_folder/"*_1.fq.gz); do
            inner_dirname=$(basename $outer_folder);
            new_dirname=/scratch/alpine/emye7956/mothersmilk/quality_all/$inner_dirname

            mkdir -pv $new_dirname
            mkdir -pv $new_dirname/trimmed_output

            base=$(basename ${infile} _1.fq.gz)
            outer_path=$(dirname ${infile})
            common_prefix="$outer_path/$base"
            echo "common_prefix=$common_prefix"

            mkdir -pv $new_dirname/fastqc2_output

            echo "TRIMMOMATIC for ${common_prefix}"
            java -jar $trimmomatic_loc PE -threads 10 -trimlog $new_dirname/trimmed_output/${base}.trimlog -summary $new_dirname/trimmed_output/${base}.trim.log -validatePairs ${common_prefix}_1.fq.gz ${common_prefix}_2.fq.gz -baseout $new_dirname/trimmed_output/${base}.trimmed SLIDINGWINDOW:4:20 LEADING:20 TRAILING:20 MINLEN:50 

            echo "FASTQC 2 for ${common_prefix}"
            fastqc $new_dirname/trimmed_output/${base}.trimmed_1P $new_dirname/trimmed_output/${base}.trimmed_2P -o $new_dirname/fastqc2_output
        done
    fi
done