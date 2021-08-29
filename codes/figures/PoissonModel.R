## ---------------------------
##
## Script name: PoissonModel.R
##
## Purpose of script: It fits the data to a one-parameter Poisson model.
##      It generates Figure 1 in the manuscript.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------


#Libraries
library(scattermore)
library(Hmisc)
library(dplyr)

datasets<-c("china","RYGB","autism","vaginal","soil","MMC")
sequenceLength<-c(250,200,151,250,250,250)
bestP<-c(0.00015,0.0001,0.0001,0.00005,0.00015,0.0001)
files<-sprintf(paste0("./data","/%s/OneMismatchCluster.txt"),datasets)

#*********************Functions***********************
load.parents<-function(file,Length){
  data<-read.table(file,sep="\t",header = TRUE)
  data_parents<-data %>% distinct(Parent,.keep_all = TRUE) %>%
    mutate(fractionOfChildren=NumberOfChildren/(Length*3))
  data_parents
}

makePlots<-function(data,...){
  scattermoreplot(log10(data$ParentAbundance),data$fractionOfChildren,
                  xlab=expression('log'[10]~'abundance of parents'),
                  ylab="Fraction of all possible one-mismatch variants",cex=0.8,ylim=c(0,1),...)
}

getNumberOfSVFromPoisson<-function(N,prob){
  fraction<-sapply(N,function(x) 1-dpois( 0, lambda = x*prob/3))
  fraction
}

getsequenceDepth<-function(data){
  N <- seq(min(data$ParentAbundance),max(data$ParentAbundance),100)
  N
}


#*********************Figure***********************
files.parents<-mapply(load.parents,files,sequenceLength,SIMPLIFY = FALSE)
names(files.parents)<-datasets
sequenceDepth<-lapply(files.parents,getsequenceDepth)

getNumberOfSV_0.00015<-lapply(sequenceDepth,getNumberOfSVFromPoisson,0.00015)
getNumberOfSV_0.0001<-lapply(sequenceDepth,getNumberOfSVFromPoisson,0.0001)
getNumberOfSV_0.00005<-lapply(sequenceDepth,getNumberOfSVFromPoisson,0.00005)

pdf("./figures/PoissonModel.pdf",width = 10,height = 7)
par(mfrow=c(2,3))
for (i in 1:6){
  makePlots(files.parents[[i]])
  lines(log10(sequenceDepth[[i]]),getNumberOfSV_0.0001[[i]],col="red",lwd=2)
  title( main=paste(capitalize(names(files.parents)[i]),"dataset",
                    "\nError probabilty for best fit = ",bestP[i]))
  if(i==1 | i==5){
    lines(log10(sequenceDepth[[i]]),getNumberOfSV_0.00015[[i]],col="green",lwd=2)
  }
  else if (i==4){
    lines(log10(sequenceDepth[[i]]),getNumberOfSV_0.00005[[i]],col="green",lwd=2)
  }
}
dev.off()



