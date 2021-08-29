## ---------------------------
##
## Script name: PoissonInference.R
##
## Purpose of script: It infers sequence variants using one-parameter Poisson model.
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
bestP<-c(0.00015,0.0001,0.0001,0.00005,0.00015,0.0001)
files<-sprintf(paste0("./data","/%s/OneMismatchCluster.txt"),datasets)

#*********************Functions***********************
load.children<-function(file){
  data<-read.table(file,sep="\t",header = TRUE)
  data_children<-data %>% filter(!is.na(Child))
  data_children
}

getpvalsFromPossoin<-function(data,p){
  pvals<-sapply(1:nrow(data),function(x){
    poisson.test(data$ChildAbundance[x],data$ParentAbundance[x],
                 p/3,alternative="greater")$p.value
  })
  pvals
}

makePlot<-function(data,adjustPval,dataName,...){
  scattermoreplot(log10(data$ParentAbundance),log10(data$ChildAbundance),
                  col=ifelse(adjustPval<0.05,adjustcolor("red",alpha.f = 0.4),"black"),
                  xlab=expression("log"[10] ~"abundance of parents"),
                  ylab=expression("log"[10]~ "abundance of children"),
                  cex=0.5,
                  main=capitalize(dataName),...)
}

#*********************Figure***********************
files.children<-lapply(files, load.children)
names(files.children)<-datasets
pvals<-mapply(getpvalsFromPossoin,files.children,bestP)
adjustedP<-mapply(p.adjust,pvals,method="BH")
names(adjustedP)<-datasets
sapply(adjustedP,function(x) sum(x<0.05)/length(x)*100)


pdf("./figures/PoissonInference.pdf",width = 10,height = 7)
par(mfrow=c(2,3))
mapply(makePlot,files.children,adjustedP,datasets)
dev.off()











