#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=test_on_gut
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

module purge
module load anaconda
module load perl
conda activate /projects/$USER/software/anaconda/envs/qc_env
export PATH=$PATH:/curc/sw/install/bio/bedtools/2.29.1/bin/
export PATH=$PATH:/curc/sw/install/bio/bbtools/bbmap/
export PATH=$PATH:/scratch/alpine/emye7956/MetaAir/FastQC/
export PATH=$PATH:/scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/
export PHYLOFLASH_DBHOME=/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/138.1
cd /scratch/alpine/emye7956/MetaAir/data/gut

for infile in *_R1_001.fastq.gz; do
    base=$(basename ${infile} _R1_001.fastq.gz)
    echo "Running sample ${base}"

    echo "FASTQC 1 for ${base}"
    fastqc ${base}_R1_001.fastq.gz ${base}_R2_001.fastq.gz -o fastqc_output

    echo "TRIMMOMATIC for ${base}"
    java -jar /scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 10 -trimlog trimmed_output/${base}.trimlog -summary trimmed_output/${base}.trim.log -validatePairs ${base}_R1_001.fastq.gz ${base}_R2_001.fastq.gz -baseout trimmed_output/${base}.trimmed SLIDINGWINDOW:4:20 LEADING:20 TRAILING:20 MINLEN:50 

    echo "FASTQC 2 for ${base}"
    fastqc trimmed_output/${base}.trimmed_1P trimmed_output/${base}.trimmed_2P -o fastqc2_output

done
