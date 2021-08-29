## ---------------------------
##
## Script name: Performance
##
## Purpose of script: It compares run-time and memory usage between DADA2 and HashSeq.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------

#Libraries
library(ggplot2)
library(cowplot)
library(grid)

performance<-read.table("data/performance/performance.txt",sep="\t",header = TRUE)
performance$Datasets<-factor(performance$Datasets,levels = c("MMC","China","Autism","Soil","RYGB","Vaginal"))


theme_set(theme_classic())
plot1<-ggplot(performance,aes(x=Datasets,y=CPU))+
geom_bar(stat="identity",aes(fill=Pipeline),position = "dodge")+
scale_fill_manual(values = c("#7570B3","#E6AB02"))+
  labs(y="CPU (s)")

pdf("figures/legendPerformance.pdf",width = 2.4,height = 2.4)
legendp <- cowplot::get_legend(plot1)
grid.newpage()
grid.draw(legendp)
dev.off()

plot1<-plot1+theme(legend.position = "none")

plot2<-ggplot(performance,aes(x=Datasets,y=Memory))+
  geom_bar(stat="identity",aes(fill=Pipeline),position = "dodge")+
  scale_fill_manual(values = c("#7570B3","#E6AB02"))+
  labs(y="Memory (GB)")+theme(legend.position = "none")

pdf("figures/Performance.pdf",width = 10,height = 5)
gridExtra::grid.arrange(plot1,plot2,ncol=2)
dev.off()








