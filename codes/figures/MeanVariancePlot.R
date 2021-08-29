## ---------------------------
##
## Script name: MeanVariancePlot.R
##
## Purpose of script: It plots the variance of one-mismatch children in each
##      cluster versus their mean abundance.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------


#libraries
library(scattermore)
library(Hmisc)
library(dplyr)

datasets<-c("china","RYGB","autism","vaginal","soil","MMC")


#*********************Functions***********************
plotMeanVariance<-function(study){
  df<-read.table(file.path("data",study,"OneMismatchCluster.txt"),sep="\t",header = TRUE)
  df1 <-df %>% filter(!is.na(ChildAbundance), NumberOfChildren > 1)

  df2 <-df1 %>%
    group_by(Parent) %>%
    dplyr::summarize(mean=mean(ChildAbundance), sd=sd(ChildAbundance),
              variance=var(ChildAbundance),numOfChildren=n()) %>% filter(variance!=0)

  scattermoreplot(log10(df2$mean),log10(df2$variance),
                  xlab=expression('log'[10]~mean),
                  ylab = expression('log'[10] ~ variance),
                  cex=0.5,main=paste(capitalize(study),"dataset"))
  abline(a=0,b=1,col="red",lwd=2)
}

#*********************Figure***********************
pdf("./figures/MeanVariancePlot.pdf",width = 10,height = 7)
par(mfrow=c(2,3))
sapply(datasets,plotMeanVariance)
dev.off()



