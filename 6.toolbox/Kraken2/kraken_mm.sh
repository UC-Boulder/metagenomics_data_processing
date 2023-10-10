#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=20:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=kraken_mm
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

# need to add the directory for your input files 
cd /pl/active/ADOR/projects/mothersmilk/hostile/all

module purge
module load anaconda
conda active /projects/emye7956/software/anaconda/envs/kraken2

for infile in *_1.fastq.gz; do
    base=$(basename ${infile}_1.fastq.gz)
    echo "Running sample ${base}"

    kraken2 --db /pl/active/ADOR/projects/mothersmilk/kraken/ \
    --threads 20 \
    --output /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.output.txt \
    --report /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.report.txt \
    --use-mpa-style \
    --report-zero-counts \
    --gzip-compressed \
    --use-names \
    --paired ${base}_1.fastq.gz ${base}_2.fastq.gz
done
-------------------------------------------------------------
# Changing script sample names:

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=20:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=kraken_mm
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

# need to add the directory for your input files 
cd /pl/active/ADOR/projects/mothersmilk/hostile/all

module purge
module load anaconda
conda active /projects/emye7956/software/anaconda/envs/kraken2

for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%.*}
    echo "Running sample ${base}"

    kraken2 --db /pl/active/ADOR/projects/mothersmilk/kraken/ \
    --threads 20 \
    --output /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.output.txt \
    --report /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.report.txt \
    --use-mpa-style \
    --report-zero-counts \
    --gzip-compressed \
    --use-names \
    --paired ${base}_1.fastq.gz ${base}_2.fastq.gz
done
-------------------------------------------------------------
# Test script on one sample:

#!/bin/bash

# Specify the sample files you want to process
sample_1="/pl/active/ADOR/projects/mothersmilk/hostile/all/W10_CKDL230013663-1A_H5MMKDSX7_L1.trimmed_1P.clean_1.fastq.gz"
sample_2="/pl/active/ADOR/projects/mothersmilk/hostile/all/W10_CKDL230013663-1A_H5MMKDSX7_L1.trimmed_2P.clean_2.fastq.gz"

# Process the specific sample
base=$(basename ${sample_1} _1.fastq.gz)
echo "Running sample ${base}"

    kraken2 --db /pl/active/ADOR/projects/mothersmilk/kraken/ \
    --threads 20 \
    --output /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.output.txt \
    --report /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.report.txt \
    --use-mpa-style \
    --report-zero-counts \
    --gzip-compressed \
    --use-names \
    --paired ${sample_1} ${sample_2}

-------------------------------------------------------------
# Make a Kraken txt file with names of processed files 
#!/bin/bash

directory="/pl/active/ADOR/projects/mothersmilk/kraken/kraken_output/"
output_file="kraken_processed2.txt"

# Find files ending in fastq.gz and process their names
find "$directory" -type f -name '*report.txt' | while read -r file; do
    # Extract the part of the file name before ".clean" and write to the output file
    file_basename=$(basename "$file")
    echo "$file_basename" >> "$output_file"
done
-------------------------------------------------------------
# Running Kraken on files that timed out

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=20:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=kraken_mm
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

cd /pl/active/ADOR/projects/mothersmilk/hostile/all

module purge
module load anaconda
conda active /projects/emye7956/software/anaconda/envs/kraken2

processed_files=($(cat /pl/active/ADOR/projects/mothersmilk/kraken/kraken_output/kraken_processed3.txt))

for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%.*}
    
    # Check if the base name is in the processed_files array
    if [[ ! " ${processed_files[@]} " =~ " ${base} " ]]; then
        echo "Running sample ${base}"

        kraken2 --db /pl/active/ADOR/projects/mothersmilk/kraken/ \
        --threads 20 \
        --output /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.output.txt \
        --report /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.report.txt \
        --use-mpa-style \
        --report-zero-counts \
        --gzip-compressed \
        --use-names \
        --paired ${base}_1.fastq.gz ${base}_2.fastq.gz
    else
        echo "Skipping sample ${base} (already processed)"
    fi
done

-----------------------------------------------------------------------------
# Oct 9 chatgot rec for round 3 

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --partition=amilan
#SBATCH --qos=long
#SBATCH --job-name=kraken_mm
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

cd /pl/active/ADOR/projects/mothersmilk/hostile/all

module purge
module load anaconda
conda activate /projects/emye7956/software/anaconda/envs/kraken2

processed_files=($(cat /pl/active/ADOR/projects/mothersmilk/kraken/kraken_output/kraken_processed3.txt))
    
for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%_*}
    suffix=$(echo $infile | cut -d'_' -f2-4 | sed 's/\.trimmed//')
    echo "${base}_${suffix}"

    # Check if the base name is in the processed_files array
    if [[ ! " ${processed_files[@]} " =~ " ${base} " ]]; then
        echo "Running sample ${base}"

        kraken2 --db /pl/active/ADOR/projects/mothersmilk/kraken/ \
        --threads 20 \
        --output /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}.output.txt \
        --report /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/${base}_${suffix}.report.txt \
        --use-mpa-style \
        --report-zero-counts \
        --gzip-compressed \
        --use-names \
        --paired ${base}_${suffix}.trimmed_1P.clean_1.fastq.gz ${base}._${suffix}.trimmed_2P.clean_2.fastq.gz
    else
        echo "Skipping sample ${base} (already processed)"
    fi
done
----------------------------------------------------------------------
# code above gave the follwing slurm error:

L10_CKDL230013663-1A_H5MMKDSX7_L1
Running sample L10
gzip: L10._CKDL230013663-1A_H5MMKDSX7_L1.trimmed_2P.clean_2.fastq.gz: No such file or directory
Loading database information... done.
0 sequences (0.00 Mbp) processed in 0.546s (0.0 Kseq/m, 0.00 Mbp/m).
  0 sequences classified (-nan%)
  0 sequences unclassified (-nan%)
L1_CKDL230012783-1A_H5MMKDSX7_L4
Running sample L1
gzip: L1._CKDL230012783-1A_H5MMKDSX7_L4.trimmed_2P.clean_2.fastq.gz: No such file or directory
Loading database information... done.
0 sequences (0.00 Mbp) processed in 0.506s (0.0 Kseq/m, 0.00 Mbp/m).
  0 sequences classified (-nan%)
  0 sequences unclassified (-nan%)
L3_CKDL230013656-1A_H5T3JDSX7_L3
Running sample L3
gzip: L3._CKDL230013656-1A_H5T3JDSX7_L3.trimmed_2P.clean_2.fastq.gz: No such file or directory

# there was an extra "." after the first 2 characters. Rerun. 
-----------------------------------------------------------------------------
# redo'ing the code above and adding the file for completing recall

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=48:00:00
#SBATCH --partition=amilan
#SBATCH --qos=long
#SBATCH --job-name=kraken_mm
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --mail-user=emye7956@colorado.edu

cd /pl/active/ADOR/projects/mothersmilk/hostile/all

module purge
module load anaconda
conda activate /projects/emye7956/software/anaconda/envs/kraken2

# make a dummy file to redo all
processed_files=($(cat /pl/active/ADOR/projects/mothersmilk/kraken/kraken_output/kraken_dummy.txt))

for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%_*}
    suffix=$(echo $infile | cut -d'_' -f2-4 | sed 's/\.trimmed//')
    echo "${base}_${suffix}"

    # Check if the base name is in the processed_files array
    if [[ ! " ${processed_files[@]} " =~ " ${base} " ]]; then
        echo "Running sample ${base}"

        kraken2 --db /pl/active/ADOR/projects/mothersmilk/kraken/ \
        --threads 20 \
        --output /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/redo/${base}.output.txt \
        --report /pl/active/ADOR/projects/mothersmilk/kraken/kraken_out/redo/${base}_${suffix}.report.txt \
        --use-mpa-style \
        --report-zero-counts \
        --gzip-compressed \
        --use-names \
        --paired ${base}_${suffix}.trimmed_1P.clean_1.fastq.gz ${base}_${suffix}.trimmed_2P.clean_2.fastq.gz

        echo "${base}" >> /pl/active/ADOR/projects/mothersmilk/kraken/kraken_output/redo/these_were_done.txt
    else
        echo "Skipping sample ${base} (already processed)"
    fi
done

-----------------------------------------------------------------------------

# testing out base name 
for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%_*}
    echo "${base}"
done
-----------------------------------
# and another 
for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%_*}  # Get the prefix before the first underscore
    
    # Check if the base name is in the processed_files array
    if [[ ! " ${processed_files[@]} " =~ " ${base} " ]]; then
        echo "Running sample ${base}"
    else
        echo "this sample ${base} is run "
    fi
done
-----------------------------------
# and another 
for infile in *_1.fastq.gz; do
    base=$(basename ${infile} _1.fastq.gz)
    base=${base%%_*}
    suffix=$(echo $infile | cut -d'_' -f2-4 | sed 's/\.trimmed//')
    echo "${base}_${suffix}"
done

------------------------------------------------------------------------
# kraken_processed3.txt looks like this
MG194_CKDL230013656-1A_H5T3JDSX7_L3
MG195_CKDL230013656-1A_H5T3JDSX7_L3
MG196_CKDL230013656-1A_H5T3JDSX7_L3
MG198_CKDL230013656-1A_H5T3JDSX7_L3
MG199_CKDL230013656-1A_H5T3JDSX7_L3
MG19_CKDL230012783-1A_H5MMKDSX7_L4
MG1_CKDL230012783-1A_H5MMKDSX7_L4
MG201_CKDL230013656-1A_H5T3JDSX7_L3
MG202_CKDL230013656-1A_H5T3JDSX7_L3
MG203_CKDL230013656-1A_H5T3JDSX7_L3
MG204_CKDL230013656-1A_H5T3JDSX7_L3
MG205_CKDL230013656-1A_H5T3JDSX7_L3
-----------------------------------------------------------------------------
# writting all output reports with no underscore and ending in txt to a txt file

#!/bin/bash

# Create an empty file called "short_done.txt"
> short_done.txt

# Loop through the files in the directory
for file in *; do
    # Check if the file ends with "txt" and does not contain underscores
    if [[ $file == *".txt" && $file != *_* ]]; then
        echo "$file" >> short_done.txt
    fi
done

echo "File names ending with 'txt' and without underscores written to short_done.txt"

-----------------------------------------------------------------------------


# Merging Kraken Reports 

#!/bin/bash

# Set the working directory
cd ~/pl/active/ADOR/projects/mothersmilk/kraken/kraken_out

# Create a list of file names (excluding . and ..)
myFiles=($(ls -I "." -I ".." | sed 's/_L.*//'))

# Initialize an array to store the file contents
declare -A dat

# Read in the files and store them in the array
for file in *.txt; do
    dat["${file%.txt}"]=$(cat "$file")
done

# Change back to the parent directory
cd ~/Documents/projects/metagenomicProcessinng/metaAirChemGapHyphy/

# Merge the contents of the array into a single CSV file
header="V1,${myFiles[@]}"
(IFS=','; echo "$header"; paste -d',' <(echo "${dat[${myFiles[0]}]}") \
    <(echo "${dat[${myFiles[1]}]}") ...) > taxTabALLJune5.csv



