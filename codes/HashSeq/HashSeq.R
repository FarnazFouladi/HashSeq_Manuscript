## ---------------------------
##
## Script name: HashSeq.R
##
## Purpose of script: It infers sequence variants using the HashSeq pipeline.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------


#For vaginal dataset increase the heap size to:
#options("java.parameters"="-Xmx5024m")

#Library
library(HashSeq)

inputDir="PATH/TO/INPUTDIRECTORY"
outputDir="PATH/TO/OUTPUTDIRECTORY"
threshold=1000
inferTrueSequences(inputDir,outputDir,threshold)
cat("End of the script")
