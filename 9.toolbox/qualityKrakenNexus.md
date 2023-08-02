# GOAL: MARKDOWN FILE WITH ALL SCRIPTS USED FOR METAGENOMIC TAXONOMIC ANALYSIS USING KRAKEN2.


# Run a test which just loops with echo: 
doing this to make sure the loop works before adding in any commands 
### when you make this zsh file in Nexus, you need to run chmod +x on it before you can run it

```
#!/bin/zsh
for infile in *_R1_001.trimmed.fastq.gz; do
    base=${infile%_R1_001.trimmed.fastq.gz}
    echo "Running sample ${base}"
done    
```


# 1. FASTQC
```
#!/bin/zsh

# make the output directory 
mkdir fastqcOut

# run the samples through fastqc
for infile in *_R1_001.trimmed.fastq.gz; do
    base=${infile%_R1_001.trimmed.fastq.gz}
    fastqc ${base}_R1_001.trimmed.fastq.gz ${base}_R2_001.trimmed.fastq.gz -o fastqcOut
done 
```
## FYI - took 17 min for gap samples on 24 threads 



# 2. MULTIQC 

```
multiqc .
```


# 3. TRIMMOMATIC 
```
#!/bin/zsh

# make the output directory 
mkdir trimmedOut


for infile in *_R1_001.trimmed.fastq.gz; do
    base=${infile%_R1_001.trimmed.fastq.gz}
    trimmomatic PE -threads 24 -trimlog trimmedOut/${base}.trimlog -summary trimmedOut/${base}.trim.log -validatePairs ${base}_R1_001.trimmed.fastq.gz ${base}_R2_001.trimmed.fastq.gz -baseout ${base}.trimmed SLIDINGWINDOW:4:20 LEADING:20 TRAILING:20 MINLEN:50
done 

# put all files where they should be going
mv *_1P* trimmedOut
mv *_2P* trimmedOut
mv *_1U* trimmedOut
mv *_2U* trimmedOut
```

## FYI - took 1 hour and 5 min on gap samples on 24 threads



# 4. FASTQC 2

```
#!/bin/zsh

# make the output directory
mkdir fastqc2Out

for infile in *_R1_001.trimmed.fastq.gz; do
    base=${infile%_R1_001.trimmed.fastq.gz}
    fastqc trimmedOut/${base}.trimmed_1P trimmedOut/${base}.trimmed_2P -o fastqc2Out
done 
```

# 5. MULTIQC 2

```
multiqc .
```



# 6. KRAKEN2 
```
#!/bin/zsh
for infile in *_L004_R1_001.trimmed.fastq.gz; do
    base=${infile%_L004_R1_001.trimmed.fastq.gz}
    echo "Running sample ${base}"

    # run once with standard kraken DB 
    kraken2 --db /opt/shared_resources/kraken/standardKrakenDB --threads 24 --confidence 0.05 --use-mpa-style --use-names --report-zero-counts --report krakenStandardOut/${base}_report.txt --output krakenStandardOut/${base}_output.txt --paired trimmedOut/${base}_L004.trimmed_1P trimmedOut/${base}_L004.trimmed_2P



    # run once with mini kraken DB 
    kraken2 --db /opt/shared_resources/kraken/minikraken2_v1_8GB --threads 24 --confidence 0.05 --use-mpa-style --use-names --report-zero-counts --report krakenMiniOut/${base}_report.txt --output krakenMiniOut/${base}_output.txt --paired trimmedOut/${base}_L004.trimmed_1P trimmedOut/${base}_L004.trimmed_2P



    # run once with parameters for Bracken 
    kraken2 --db /opt/shared_resources/kraken/minikraken2_v1_8GB --threads 24 --confidence 0.05 --use-names --report krak4brack/${base}_evol1 --paired trimmedOut/${base}_L004.trimmed_1P trimmedOut/${base}_L004.trimmed_2P > krak4brack/${base}_evol.kraken
done
```

mkdir reports && mv *report* reports
mkdir output && mv *output* output



# 7. KRAKEN TOOLS
## combine MPA output
### for standard:
#### go to: /Users/maria/tools/KrakenTools

```
python combine_mpa.py -i /Users/maria/projects/knightLab/metaAIR/krakenStandardOut/reports/* -o /Users/maria/projects/knightLab/metaAIR/krakenStandardOut/GAP.COMBINED.MPA
```

### for mini kraken
```
python combine_mpa.py -i /Users/maria/projects/knightLab/metaAIR/krakenMiniOut/reports/* -o /Users/maria/projects/knightLab/metaAIR/krakenMiniOut/GAP.miniK.COMBINED.MPA
```


# 8. BRACKEN

## must sudo -s before running this script #sketchy
#### NEED TO CHANGE THE PATHS FOR INANDOUT
#### ALSO - NEED TO CHMOD 777 THE DIRECTORIES YOU WILL BE USING FILES FROM FOR "INANDOUT"

```
#!/bin/zsh
for infile in *_evol1; do
    base=${infile%_evol1}

docker run -v /Users/maria/projects/knightLab/metaAIR/krak4brack:/inAndOut -v /opt/shared_resources/kraken/minikraken2_v1_8GB:/opt/shared_resources/kraken/minikraken2_v1_8GB nanozoo/bracken:2.8--dcb3e47 bracken -d /opt/shared_resources/kraken/minikraken2_v1_8GB -i /inAndOut/${base}_evol1 -l P -o /inAndOut/brackenOut/${base}_P_evol1.bracken -w /inAndOut/brackenOut/${base}_report.bracken.phylum

docker run -v /Users/maria/projects/knightLab/metaAIR/krak4brack:/inAndOut -v /opt/shared_resources/kraken/minikraken2_v1_8GB:/opt/shared_resources/kraken/minikraken2_v1_8GB nanozoo/bracken:2.8--dcb3e47 bracken -d /opt/shared_resources/kraken/minikraken2_v1_8GB -i /inAndOut/${base}_evol1 -l F -o /inAndOut/brackenOut/${base}_F_evol1.bracken -w /inAndOut/brackenOut/${base}_report.bracken.family

docker run -v /Users/maria/projects/knightLab/metaAIR/krak4brack:/inAndOut -v /opt/shared_resources/kraken/minikraken2_v1_8GB:/opt/shared_resources/kraken/minikraken2_v1_8GB nanozoo/bracken:2.8--dcb3e47 bracken -d /opt/shared_resources/kraken/minikraken2_v1_8GB -i /inAndOut/${base}_evol1 -l C -o /inAndOut/brackenOut/${base}_C_evol1.bracken -w /inAndOut/brackenOut/${base}_report.bracken.class

docker run -v /Users/maria/projects/knightLab/metaAIR/krak4brack:/inAndOut -v /opt/shared_resources/kraken/minikraken2_v1_8GB:/opt/shared_resources/kraken/minikraken2_v1_8GB nanozoo/bracken:2.8--dcb3e47 bracken -d /opt/shared_resources/kraken/minikraken2_v1_8GB -i /inAndOut/${base}_evol1 -l O -o /inAndOut/brackenOut/${base}_O_evol1.bracken -w /inAndOut/brackenOut/${base}_report.bracken.order

docker run -v /Users/maria/projects/knightLab/metaAIR/krak4brack:/inAndOut -v /opt/shared_resources/kraken/minikraken2_v1_8GB:/opt/shared_resources/kraken/minikraken2_v1_8GB nanozoo/bracken:2.8--dcb3e47 bracken -d /opt/shared_resources/kraken/minikraken2_v1_8GB -i /inAndOut/${base}_evol1 -l G -o /inAndOut/brackenOut/${base}_G_evol1.bracken -w /inAndOut/brackenOut/${base}_report.bracken.genus

docker run -v /Users/maria/projects/knightLab/metaAIR/krak4brack:/inAndOut -v /opt/shared_resources/kraken/minikraken2_v1_8GB:/opt/shared_resources/kraken/minikraken2_v1_8GB nanozoo/bracken:2.8--dcb3e47 bracken -d /opt/shared_resources/kraken/minikraken2_v1_8GB -i /inAndOut/${base}_evol1 -l S -o /inAndOut/brackenOut/${base}_S_evol1.bracken -w /inAndOut/brackenOut/${base}_report.bracken.species

done
```

### in brackenReports
set up the directories and organize the files 

```
mkdir brackenReports
mv *report.bracken.* brackenReports
mkdir phylum
mv *_P_* phylum
mkdir family
mv *_F_* family
mkdir class
mv *_C_* class
mkdir order
mv *_O_* order
mkdir genus
mv *_G_* genus
mkdir species
mv *_S_* species
```


 # 9. COMBINE BRACKEN OUTPUT

### run in /Users/maria/tools/Bracken/analysis_scripts
./combine_bracken_outputs.py --files /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/phylum/* --output /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/phylum/combinedBrack_phylum
./combine_bracken_outputs.py --files /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/family/* --output /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/family/combinedBrack_family
./combine_bracken_outputs.py --files /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/class/* --output /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/class/combinedBrack_class
./combine_bracken_outputs.py --files /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/order/* --output /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/order/combinedBrack_order
./combine_bracken_outputs.py --files /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/genus/* --output /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/genus/combinedBrack_genus
./combine_bracken_outputs.py --files /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/species/* --output /Users/maria/projects/knightLab/metaAIR/krak4brack/brackenOut/species/combinedBrack_species

