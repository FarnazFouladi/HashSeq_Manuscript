## ---------------------------
##
## Script name: Inference.R
##
## Purpose of script: It infers sequence variants using the DADA2 pipelin.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------

#library
library(dada2)

args = commandArgs(trailingOnly=TRUE)

path=args[1]
outputDir=args[2]
study=args[3]

setwd(outputDir)
cat("Inference of Sequence Variants")

filt_path <- file.path(path, "dada2Filtered")
filtFs <- sort(list.files(filt_path, pattern="_filt.fastq"))
sample.names <- gsub("_filt.fastq", "", filtFs, fixed=TRUE)
filtFs <- file.path(filt_path, paste0(sample.names, "_filt.fastq"))

dds <- vector("list", length(sample.names))
names(dds) <- sample.names
index <-1

errF <- learnErrors(filtFs, nbases = 1e8, multithread = FALSE,randomize=TRUE)

for (f in filtFs){

  derepFs <- derepFastq(f, verbose=TRUE)
  dadaFs <- dada(derepFs, err=errF, multithread=FALSE)
  dds[[index]]<-dadaFs
  index<-index+1
}

seqtab <- makeSequenceTable(dds)

#Removing chimeras
seqtab <- removeBimeraDenovo(seqtab, method="consensus", multithread=FALSE)

saveRDS(seqtab,paste0(study,"_Dada2Reads.rds"))
write.table(seqtab,file=paste0(study,"_Dada2Reads.txt"),sep="\t",quote=FALSE)

cat("End of the script!")
