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
conda activate /projects/$USER/software/anaconda/envs/metaair_env
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

    echo "PHYLOFLASH for ${base}"
    /scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/phyloFlash.pl -lib ${base}_pl -read1 trimmed_output/${base}.trimmed_1P -read2 trimmed_output/${base}.trimmed_2P -almosteverything -readlength 150 -CPUs 10
done

--------------------------
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=qc_mothersmilk
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
cd /scratch/alpine/emye7956/mothersmilk/quality

export outer_dir=/scratch/alpine/emye7956/mothersmilk/mg_data/fastq/
export trimmomatic_loc=/scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/trimmomatic-0.39.jar
export phyloflash_loc=/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/phyloFlash.pl
for outer_folder in "$outer_dir"*; do
    if [ "$(basename "$outer_folder")" != "broken" ]; then
        for infile in $(ls "$outer_folder/"*_1.fq.gz); do
            inner_dirname=$(basename $outer_folder);
            new_dirname=/scratch/alpine/emye7956/mothersmilk/quality/$inner_dirname

            mkdir -pv $new_dirname
            mkdir -pv $new_dirname/trimmed_output

            base=$(basename ${infile} _1.fq.gz)
            outer_path=$(dirname ${infile})
            common_prefix="$outer_path/$base"
            echo "common_prefix=$common_prefix"

            mkdir -pv $new_dirname/fastqc_output

            # echo "FASTQC 1 for ${common_prefix}"
            # fastqc ${common_prefix}_1.fq.gz ${common_prefix}_2.fq.gz -o $new_dirname/fastqc_output

            echo "TRIMMOMATIC for ${common_prefix}"
            java -jar $trimmomatic_loc PE -threads 10 -trimlog $new_dirname/trimmed_output/${base}.trimlog -summary $new_dirname/trimmed_output/${base}.trim.log -validatePairs ${common_prefix}_1.fq.gz ${common_prefix}_2.fq.gz -baseout $new_dirname/trimmed_output/${base}.trimmed SLIDINGWINDOW:4:20 LEADING:20 TRAILING:20 MINLEN:50 

            echo "FASTQC 2 for ${common_prefix}"
            fastqc $new_dirname/trimmed_output/${base}.trimmed_1P $new_dirname/trimmed_output/${base}.trimmed_2P -o $new_dirname/fastqc2_output

            echo "PHYLOFLASH for ${common_prefix}"
            $phyloflash_loc -lib ${base}_pl -read1 $new_dirname/trimmed_output/${base}.trimmed_1P -read2 $new_dirname/trimmed_output/${base}.trimmed_2P -almosteverything -readlength 150 -CPUs 10
        done
    fi
done


---------------

# Moving html files 
quality_dir=/scratch/alpine/emye7956/mothersmilk/quality/
destination_dir="/scratch/alpine/emye7956/mothersmilk/quality/fastq1html"

# Loop through each directory
for dir in "$quality_dir*";
    cp $dir/fastqc_output/*.html $mkdir $destination_dir/.
done

-----
destination_dir="/scratch/alpine/emye7956/mothersmilk/quality/fastq1html"

# Loop through each directory
for dir in L1 L4 L7 MG1 MG12 MG15 MG18 MG188 MG190 MG193 MG196 MG199 MG200 MG203 MG23 MG26 MG29 MG32 MG36 MG39 MG6 MG9 L10 L5 L8 MG10 MG13 MG16 MG186 MG189 MG191 MG194 MG197 MG2 MG201 MG21 MG24 MG27 MG30 MG33 MG37 MG4 MG7 L3 L6 L9 MG11 MG14 MG17 MG187 MG19 MG192 MG195 MG198 MG20 MG202 MG22 MG25 MG28 MG31 MG35 MG38 MG5 MG8; do
  # Check if the directory exists
  echo "Inspecting $quality_dir$dir"
  if [ -d "$quality_dir$dir" ]; then
    # Move HTML files to the destination directory
    cp "$quality_dir$dir/fastqc_output/"*.zip "$destination_dir/"
  fi
done

# this gave me the following error:
cp: cannot stat '/scratch/alpine/emye7956/mothersmilk/quality//L4/fastqc_output/*.html': No such file or directory
cp: cannot stat '/scratch/alpine/emye7956/mothersmilk/quality//MG203/fastqc_output/*.html': No such file or directory
cp: cannot stat '/scratch/alpine/emye7956/mothersmilk/quality//MG23/fastqc_output/*.html': No such file or directory
cp: cannot stat '/scratch/alpine/emye7956/mothersmilk/quality//MG39/fastqc_output/*.html': No such file or directory
cp: cannot stat '/scratch/alpine/emye7956/mothersmilk/quality//MG37/fastqc_output/*.html': No such file or directory
cp: cannot stat '/scratch/alpine/emye7956/mothersmilk/quality//L6/fastqc_output/*.html': No such file or directory






--------------------------
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --job-name=qc_mothersmilk
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
cd /scratch/alpine/emye7956/mothersmilk/quality

export outer_dir=/scratch/alpine/emye7956/mothersmilk/mg_data/fastq/
export trimmomatic_loc=/scratch/alpine/emye7956/MetaAir/Trimmomatic-0.39/trimmomatic-0.39.jar
export phyloflash_loc=/scratch/alpine/emye7956/MetaAir/phyloFlash-pf3.4.2/phyloFlash.pl
for outer_folder in "$outer_dir"*; do
    if [ "$(basename "$outer_folder")" != "broken" ]; then
        for infile in $(ls "$outer_folder/"*_1.fq.gz); do
            inner_dirname=$(basename $outer_folder);
            new_dirname=/scratch/alpine/emye7956/mothersmilk/quality/$inner_dirname

            mkdir -pv $new_dirname
            mkdir -pv $new_dirname/trimmed_output

            base=$(basename ${infile} _1.fq.gz)
            outer_path=$(dirname ${infile})
            common_prefix="$outer_path/$base"
            echo "common_prefix=$common_prefix"

            mkdir -pv $new_dirname/fastqc_output

            # echo "FASTQC 1 for ${common_prefix}"
            # fastqc ${common_prefix}_1.fq.gz ${common_prefix}_2.fq.gz -o $new_dirname/fastqc_output

            # echo "TRIMMOMATIC for ${common_prefix}"
            # java -jar $trimmomatic_loc PE -threads 10 -trimlog $new_dirname/trimmed_output/${base}.trimlog -summary $new_dirname/trimmed_output/${base}.trim.log -validatePairs ${common_prefix}_1.fq.gz ${common_prefix}_2.fq.gz -baseout $new_dirname/trimmed_output/${base}.trimmed SLIDINGWINDOW:4:20 LEADING:20 TRAILING:20 MINLEN:50 

            mkdir -pv $new_dirname/fastqc2_output

            echo "FASTQC 2 for ${common_prefix}"
            fastqc $new_dirname/trimmed_output/${base}.trimmed_1P $new_dirname/trimmed_output/${base}.trimmed_2P -o $new_dirname/fastqc2_output

            echo "PHYLOFLASH for ${common_prefix}"
            $phyloflash_loc -lib ${base}_pl -read1 $new_dirname/trimmed_output/${base}.trimmed_1P -read2 $new_dirname/trimmed_output/${base}.trimmed_2P -almosteverything -readlength 150 -CPUs 10
        done
    fi
done



