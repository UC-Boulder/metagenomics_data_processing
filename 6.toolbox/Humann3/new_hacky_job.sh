#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=humann_after_hostile.sh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu
#SBATCH --mem=32gb
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8

module purge
module load anaconda
conda activate /projects/emye7956/software/anaconda/envs/humann_env
export data_dir=/pl/active/ADOR/projects/mothersmilk/hostile/all/

# Find all files ending with "_1.fastq.gz" within the data_dir and its subdirectories
find "$data_dir" -type f -name "*_1.fastq.gz" | while read -r fpath1; do
    fpath2=${fpath1/_1/_2};
    fpathc=${fpath1/_1.fastq.gz/combined.fastq.gz};
    foutput=${fpath1/_1.fastq.gz/report.txt};
    echo "$fpath1 + $fpath2 into $fpathc to produce $foutput";
    cat "$fpath1" "$fpath2" > "$fpathc";

    humann --protein-database /projects/emye7956/software/anaconda/envs/humann_env/uniref \
    --nucleotide-database /projects/emye7956/software/anaconda/envs/humann_env/chocophlan/ \
    --input "$fpathc" \
    --output /pl/active/ADOR/projects/mothersmilk/human_after_hostile/ \
    --threads 32
done
----------------------------------------------------------------------------------------
# rerunning on files not done 



#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=humann_after_hostile.sh
#SBATCH --mail-type=NONE
#SBATCH --mail-user=emye7956@colorado.edu
#SBATCH --mem=16gb
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8

module purge
module load anaconda
conda init bash
conda activate /projects/emye7956/software/anaconda/envs/humann_env
export data_dir=/pl/active/ADOR/projects/mothersmilk/hostile/all/
processed_file="/pl/active/ADOR/projects/mothersmilk/human_after_hostile/human_processed.txt"

fpath1=ARG0;
fpath2=ARG1;
fpathc=ARG2;
foutput=ARG3;
base=$(basename "$fpath1" _1.fastq.gz)

# Check if the base name is in the processed file
if ! grep -q "^$base$" "$processed_file"; then
    echo "$fpath1 + $fpath2 into $fpathc to produce $foutput";
    cat "$fpath1" "$fpath2" > "$fpathc";

    humann --protein-database /projects/emye7956/software/anaconda/envs/humann_env/uniref \
    --nucleotide-database /projects/emye7956/software/anaconda/envs/humann_env/chocophlan/ \
    --input "$fpathc" \
    --output /pl/active/ADOR/projects/mothersmilk/human_after_hostile/ \
    --threads 32

    # Append the base name to the processed file
    echo "$base" >> "$processed_file"
else
    echo "Skipping $base (already processed)"
fi
