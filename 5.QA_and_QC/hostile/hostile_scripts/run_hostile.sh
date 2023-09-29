#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=run_hostile
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

module purge
module load anaconda

# path to your environment:
conda activate /projects/emye7956/software/anaconda/envs/hostile

# path to where your files are:
directory="/pl/active/ADOR/projects/mothersmilk/trimming/noadapters_trim_output_new/"

# chnage trimmed_1P to whatever your files end in
find "$directory" -type f -name '*trimmed_1P' | while read -r file_r1; do
    file_r2="${file_r1%trimmed_1P}trimmed_2P"
    if [[ -f "$file_r2" ]]; then
        hostile clean --fastq1 "$file_r1" --fastq2 "$file_r2"
    fi
done

