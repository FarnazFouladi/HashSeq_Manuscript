## ---------------------------
##
## Script name: LOESSPlot.R
##
## Purpose of script: It plots the mean and standard deviation of one-mismatch
##      children versus parent abundances on a log10 scale. It further adds the
##      the fitted line by the LOESS regression.
##
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------


#libraries
library(scattermore)
library(Hmisc)

datasets<-c("china","RYGB","autism","vaginal","soil","MMC")


#*********************Functions***********************
plotMeanVariance<-function(study){
  df<-read.table(file.path("data",study,"childrenProperties.txt"),sep="\t",header = TRUE)
  preictedMeanSV<-getPredictions(df)
  getScatterPlot(df,"mean",preictedMeanSV[[1]],study,
                 ylab=expression('mean log'[10]~'abundance of children'))
  getScatterPlot(df,"sd",preictedMeanSV[[2]],study,
                 ylab=expression('sd log'[10]~'abundance of children'))
}

getScatterPlot<-function(df,y,predicted_y,name,...){

  scattermoreplot(log10(df$parentAbundance),df[,y],
                  ylim=c(0,max(df[,y])),cex=0.3,
                  xlab = expression('log'[10]~'abundance of parents'),
                  main=paste(capitalize(name),"dataset"),...)
  lines(log10(df$parentAbundance),predicted_y,col="red",type = "l",lwd=2)

}

getPredictions<-function(df){
  myList<-list()
  mean.model<-loess( df$mean ~ log10(df$parentAbundance),span = 0.15)
  sd.model<-loess( df$sd ~ log10(df$parentAbundance),span = 0.15)
  myList[[1]]<-predict(mean.model)
  myList[[2]]<-predict(sd.model)
  names(myList)<-c("PredictedMean","PredictedSV")
  myList
}

#*********************Figure***********************
pdf("figures/LOESSPlot.pdf",width = 11,height = 8)
par(mfrow=c(3,4))
sapply(datasets,plotMeanVariance)
dev.off()

