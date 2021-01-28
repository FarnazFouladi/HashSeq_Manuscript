## ---------------------------
##
## Script name: Filter.R
##
## Purpose of script: It filter sequences using the DADA2 pipeline.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------

#Library
library(dada2)

args = commandArgs(trailingOnly=TRUE)

path=args[1]
pattern = args[2]
length=args[3]

seqFs <- sort(list.files(path, pattern=pattern))
sample.names <- gsub(pattern, "", seqFs, fixed=TRUE)
seqFs <- file.path(path, seqFs)
filt_path <- file.path(path, "dada2Filtered")
dir.create(filt_path)
filtFs <- file.path(filt_path, paste0(sample.names, "_filt.fastq"))
#Filter
out <- filterAndTrim(seqFs, filtFs,
                     maxN=0, maxEE=2,truncQ=2,truncLen=as.numeric(length), rm.phix=TRUE,
                     compress=TRUE, multithread=TRUE)

cat("End of the script!")

