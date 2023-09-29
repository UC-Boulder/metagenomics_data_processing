#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=run_metaphlan_on_newdata
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu
#SBATCH --mem=60gb
#SBATCH --ntasks=20

module purge
module load anaconda
conda init bash
conda activate humann_env
export data_dir=/scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621

for fpath1 in $(ls $data_dir/*_R1_001.trimmed.fastq.gz); do
	fpath2=${fpath1/R1/R2};
	fpathc=${fpath1/R1/combined};
	foutput=${fpath1/R1_001.trimmed.fastq.gz/report.txt};
	echo "$fpath1 + $fpath2 into $fpathc to produce $foutput";
	cat "$fpath1" "$fpath2" > "$fpathc";
	humann --protein-database /projects/emye7956/software/anaconda/envs/humann_env/uniref --nucleotide-database /projects/emye7956/software/anaconda/envs/humann_env/chocophlan/ --input "$fpathc" --output /scratch/alpine/emye7956/MetaAir/newdata/per_sample_FASTQ/172621/human_output4 --threads 32
done
