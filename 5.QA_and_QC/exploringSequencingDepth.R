# EXPLORING KRAKEN2 CONFIDENCE SCORING -----------------------------------------

# Testing a single sample with different confidence intervals. The default is 0
# Used standard kraken2 DB, minikraken, & greengenes 
# Then check how this impacts taxa


# set up -----------------------------------------------------------------------
pacman::p_load(tidyverse, dplyr, magrittr, stringr, paRkpal, vegan, phyloseq, microbiome, kableExtra, ggplot2)
rm(list = ls())

# number of classified seqs ----------------------------------------------------
# Note: all of these are for the standard 67GB database.
seqsTab <- data.frame(confScore = c(0, 0.05, 0.1, 0.2, 0.25, 0.3, 0.4, 0.5, 1), 
                      classidiedSeqsNumStd = c(1700142, 1534210, 1405232, 860097, 458366, 170580, 9124, 204, 0), 
                      classifiedSeqsNumMiniK = c(963543, 418714, 67709, 192, 2, 0, 0, 0, 0), 
                      classifiedSeqsNumGG = c(6092,5019, 4727, 4023, 3457, 2452, 556, 63, 0))
ggplot(seqsTab, aes(confScore)) +
  geom_line(aes(y = classidiedSeqsNumStd), color = "red") +
  geom_line(aes(y = classifiedSeqsNumMiniK), color = "navy") +
  geom_line(aes(y = classifiedSeqsNumGG), color = "forestgreen") +
  labs(x = "confidence score", y = "mapped sequences") +
  theme_minimal()

# plot for confidence between 0 and 0.5 ----------------------------------------
seqsTab0.5 <- data.frame(confScore = c(0, 0.05, 0.1, 0.2, 0.25, 0.3, 0.4, 0.5), 
                      classidiedSeqsNumStd = c(1700142, 1534210, 1405232, 860097, 458366, 170580, 9124, 204), 
                      classifiedSeqsNumMiniK = c(963543, 418714, 67709, 192, 2, 0, 0, 0), 
                      classifiedSeqsNumGG = c(6092,5019, 4727, 4023, 3457, 2452, 556, 63))
ggplot(seqsTab0.5, aes(confScore)) +
  geom_line(aes(y = classidiedSeqsNumStd), color = "red") +
  geom_line(aes(y = classifiedSeqsNumMiniK), color = "navy") +
  geom_line(aes(y = classifiedSeqsNumGG), color = "forestgreen") +
  labs(x = "confidence score", y = "mapped sequences") +
  theme_minimal()


# comparing the taxa counts between different confidence settings for ZZQ5 -----

confSet <- read.delim("~/Desktop/ZZQ5lowConf.report.txt", header = F, col.names = c("taxa", "with0.05"))
confDef <- read.delim("~/Documents/projects/metagenomicProcessinng/metaAirChemGapHyphy/krakenOut/reports/ZZQ5_STO_HYPHY_S624_L004.report.txt", header = F, col.names = c("taxa", "with0"))

# variables defined ------------------------------------------------------------
# confSet = the Kraken2 confidence was set to 0.05 w/ the standard db
# confDef = the Kraken2 confidence was the default w/ the standard db

### how many rows have 0 counts for taxa? --------------------------------------
sum(confSet$with0.05 == 0) # 24,249
sum(confDef$with0 == 0) # 17,195
# this shows that the default settings give a lot less 0 count rows

###  how many rows have < 10 counts for taxa but ARE NOT equal to zero? --------
sum(confSet$with0.05 < 10 & confSet$with0.05 != 0) # 1977
sum(confDef$with0 < 10 & confDef$with0 != 0) # 6806
# this shows that the default settings have MANY more taxa that have fewer than 
# 10 counts but aren't included in the 0's counted above

### how many rows have > 10,000 counts for taxa? -------------------------------
sum(confSet$with0.05 > 10000) # 69
sum(confDef$with0  > 10000) # 73
# this shows that the number of taxa with counts above 10,000 are relatively 
# similar despite the confidence setting

# what do they have in common? -------------------------------------------------
topTaxSet <- as.data.frame(confSet$taxa[confSet$with0.05 > 10000]) %>%
  rename(taxa = `confSet$taxa[confSet$with0.05 > 10000]`)
topTaxDef <- as.data.frame(confDef$taxa[confDef$with0 > 10000]) %>%
  rename(taxa = `confDef$taxa[confDef$with0 > 10000]`)

commonTax <- inner_join(topTaxSet, topTaxDef) # these = top taxa present in both

### do they match? -------------------------------------------------------------
commonTax$taxa == topTaxSet # YUP

# setdiff(x, y) finds all rows in x that aren't in y.
setdiff(topTaxSet, topTaxDef)
setdiff(topTaxDef, topTaxSet) # there are 4 taxa with counts above 10,000 which 
# get dropped when setting the confidence setting to 0.05 - these taxa are all 
# still there in fairly high counts, just dropped slightly below the 10,000. 

# CONCLUSION: using 0.05 retains all the top taxa, the main difference is that
# it will not consider the taxa with very little counts. 





