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
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu
#SBATCH --mem=32gb
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8

module purge
module load anaconda
conda activate /projects/emye7956/software/anaconda/envs/humann_env
export data_dir=/pl/active/ADOR/projects/mothersmilk/hostile/all/
processed_file="/pl/active/ADOR/projects/mothersmilk/human_after_hostile/human_processed.txt"  # Replace with the actual path

# Find all files ending with "_1.fastq.gz" within the data_dir and its subdirectories
find "$data_dir" -type f -name "*_1.fastq.gz" | while read -r fpath1; do
    fpath2=${fpath1/_1/_2};
    fpathc=${fpath1/_1.fastq.gz/combined.fastq.gz};
    foutput=${fpath1/_1.fastq.gz/report.txt};
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
done

# --------------------------------------

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
processed_file="/pl/active/ADOR/projects/mothersmilk/human_after_hostile/human_processed.txt"  # Replace with the actual path

# Find all files ending with "_1.fastq.gz" within the data_dir and its subdirectories
find "$data_dir" -type f -name "*_1.fastq.gz" | while read -r fpath1; do
    fpath2="$(echo $fpath1 | sed 's/_1/_2/g')"
    fpathc=${fpath1/_1.fastq.gz/combined.fastq.gz};
    foutput=${fpath1/_1.fastq.gz/report.txt};
    base=$(basename "$fpath1" _1.fastq.gz)

    cp new_hacky_job.sh hacky-job-$base.sh
    # Modify hacky-job-$blarg.sh
    sed -i "s/ARG0/$(echo $fpath1 | sed 's/\//\\\//g')/g" hacky-job-$base.sh
    sed -i "s/ARG1/$(echo $fpath2 | sed 's/\//\\\//g')/g" hacky-job-$base.sh
    sed -i "s/ARG2/$(echo $fpathc | sed 's/\//\\\//g')/g" hacky-job-$base.sh
    sed -i "s/ARG3/$(echo $foutput | sed 's/\//\\\//g')/g" hacky-job-$base.sh

    # sbatch hacky-job-$base.sh
done

# --------------------------------------
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

# ----------------------------------------------------------------------------

#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --partition=amilan
#SBATCH --qos=mem
#SBATCH --job-name=humann_after_hostile.sh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=4

module purge
module load anaconda
conda activate /projects/emye7956/software/anaconda/envs/humann_env
export data_dir=/pl/active/ADOR/projects/mothersmilk/hostile/all/
export edited_bugs_list=/pl/active/ADOR/projects/mothersmilk/human_after_hostile/edited_bugs_list.txt

# Read the edited_bugs_list.txt file and store the file names in an array
readarray -t edited_files < "$edited_bugs_list"

# Find all files ending with "_1.fastq.gz" within the data_dir and its subdirectories
find "$data_dir" -type f -name "*_1.fastq.gz" | while read -r fpath1; do
    fpath2=${fpath1/_1/_2};
    fpathc=${fpath1/_1.fastq.gz/combined.fastq.gz};
    foutput=${fpath1/_1.fastq.gz/report.txt};

    # Check if the current file has been previously processed
    skip_file=false
    for edited_file in "${edited_files[@]}"; do
        if [[ "$edited_file" == "${fpath1##*/}" ]]; then
            skip_file=true
            break
        fi
    done

    if [[ "$skip_file" == "true" ]]; then
        echo "Skipping $fpath1 as it has been previously processed."
    else
        echo "$fpath1 + $fpath2 into $fpathc to produce $foutput";
        cat "$fpath1" "$fpath2" > "$fpathc";

        humann --protein-database /projects/emye7956/software/anaconda/envs/humann_env/uniref \
        --nucleotide-database /projects/emye7956/software/anaconda/envs/humann_env/chocophlan/ \
        --input "$fpathc" \
        --output /pl/active/ADOR/projects/mothersmilk/human_after_hostile/ \
        --threads 32
    fi
done




