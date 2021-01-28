## ---------------------------
##
## Script name: Histogram.R
##
## Purpose of script: It plots the histogram of abundances of one-mismatch children
##      on a log10 scale for the most abundant parent.
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
subData<-function(study){
  data<-read.table(paste0("data/",study,"/OneMismatchCluster.txt"),sep="\t",header=TRUE)
  df<-data %>% filter(ParentAbundance == max(data$ParentAbundance))
  df
}

plotHist<-function(data,study){
  nd<-sort(rnorm(length(log10(data$ChildAbundance)),
                 mean(log10(data$ChildAbundance)),
                 sd(log10(data$ChildAbundance))))

  min = min(nd,log10(data$ChildAbundance))
  max = max(nd,log10(data$ChildAbundance))
  b = pretty((min-1):(max+1),n=10)
  h<-hist(nd,breaks=b,plot = FALSE)
  h1<-hist(log10(data$ChildAbundance),breaks=b,plot = FALSE)
  xfit <- seq(min(nd), max(nd), length = 40)
  yfit <- dnorm(xfit, mean = mean(nd), sd = sd(nd))
  yfit <- yfit * diff(h$mids[1:2]) * length(nd)
  hist(log10(data$ChildAbundance),xlim = c(0,max),
       xlab=expression('log'[10]~ 'abundace of children'),
       main=paste(capitalize(study),"dataset",
                  "\nParent depth:",unique(data$ParentAbundance)),
       breaks = b,ylim=c(0,max(yfit,h1$counts)))
  lines(xfit, yfit, lwd = 2,col="red")
}


#*********************Figure***********************
pdf("figures/Histogram.pdf",width = 10,height = 7)
par(mfrow=c(2,3))
all.data<-lapply(datasets,subData)
mapply(plotHist,all.data,datasets)
dev.off()

