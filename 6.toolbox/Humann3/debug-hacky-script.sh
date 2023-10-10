# W3_CKDL230013656-1A_H5T3JDSX7_L3.trimmed_1P.clean_1.fastq.gz
# W3_CKDL230013656-1A_H5T3JDSX7_L3.trimmed_2P.clean_2.fastq.gz

#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=humann_after_hostile.sh
#SBATCH --mail-type=NONE
#SBATCH --mail-user=emye7956@colorado.edu
#SBATCH --mem=32gb
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8

module purge
module load anaconda
conda activate /projects/emye7956/software/anaconda/envs/humann_env
export data_dir=/pl/active/ADOR/projects/mothersmilk/hostile/all/
processed_file="/pl/active/ADOR/projects/mothersmilk/human_after_hostile/human_processed.txt"

fpath2=/pl/active/ADOR/projects/mothersmilk/hostile/all/W9_CKDL230013662-1A_H5T3JDSX7_L4.trimmed_2P.clean_1.fastq.gz;
fpathc=/pl/active/ADOR/projects/mothersmilk/hostile/all/W9_CKDL230013662-1A_H5T3JDSX7_L4.trimmed_1P.cleancombined.fastq.gz;
foutput=/pl/active/ADOR/projects/mothersmilk/hostile/all/W9_CKDL230013662-1A_H5T3JDSX7_L4.trimmed_1P.cleanreport.txt;
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