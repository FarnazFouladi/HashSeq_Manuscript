## ---------------------------
##
## Script name:blast.R
##
## Purpose of script: It compares percentage identity of the sequence variants
##      inferred by DADA2 and HashSeq to the SILVA132 database. It generates
##      Figure 6 and provides the information for table 1 in the manuscript.
##
## Author: Farnaz Fouladi
##
## Date Created: 2021-01-28
##
## ---------------------------


rm(list=ls())

#Libraries
library("stringr")
library(Hmisc)

datasets<-c("china","RYGB","autism","vaginal","soil","MMC")
sequenceLength<-c(250,200,151,250,250,250)

#*********************Functions***********************
loadTable<-function(dataset,dada2=FALSE){
  if(dada2)
    df<-read.table(paste0("blast/DADA2/sequences_",dataset,".txt"),sep="\t")
  else
    df<-read.table(paste0("blast/HashSeq/sequences_",dataset,".txt"),sep="\t")
  colnames(df)<-c("query","subject","identity","alignment length","mismatches","gap opens","q. start","q. end","s. start","s. end","evalue","bit score")
  df
}

calculatedIdentity<-function(df,sequenceLength){

  df$num<-df$identity*df$`alignment length`
  df$denom<-sapply(1:nrow(df), function(x) {max(sequenceLength,df$`alignment length`[x])})
  df$Iden<-df$num/df$denom
  df1<-df %>% group_by(query) %>% arrange(desc(Iden),.by_group=TRUE) %>% distinct(query,.keep_all = TRUE)
  df1
}


getIdentities<-function(df,name,dada2=FALSE){
  if(!dada2){
    fileName=paste0("blast/HashSeq/blastIdentity_",name,".txt")
    children<-str_detect(df$query,"[_]")
    cat("Number of Children is",sum(children),file = fileName,fill=TRUE)
    cat("Number of Children with Iden 100% is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden==100 & children))
    cat("Number of Children with Iden < 100 and >=99 is",file = fileName,append = TRUE,fill=TRUE,
        sum((df$Iden>=99 & df$Iden<100) & children))
    cat("Number of Children with Iden < 99 and >=97 is",file = fileName,append = TRUE,fill=TRUE,
        sum((df$Iden>=97 & df$Iden<99) & children))
    cat("Number of Children with Iden < 97 is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden<97 & children))

    Parents<-!str_detect(df$query,"_")
    cat("Number of Parents is",sum(Parents),file = fileName,append = TRUE,fill=TRUE)
    cat("Number of Parents with Iden 100% is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden==100 & Parents))
    cat("Number of Parents with Iden < 100 and >=99 is",file = fileName,append = TRUE,fill=TRUE,
        sum((df$Iden>=99 & df$Iden<100) & Parents))
    cat("Number of Parents with Iden < 99 and >=97 is",file = fileName,append = TRUE,fill=TRUE,
        sum((df$Iden>=97 & df$Iden<99)& Parents))
    cat("Number of Parents with Iden < 97 is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden<97 & Parents))

  }else{
    fileName=paste0("blast/DADA2/blastIdentity_",name,".txt")
    cat("Number of sequence variants is",nrow(df),file = fileName,fill=TRUE)
    cat("Number of Children with Iden 100% is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden==100))
    cat("Number of Children with Iden < 100 and >=99 is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden>=99 & df$Iden<100))
    cat("Number of Children with Iden < 99 and >=97 is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden>=97 & df$Iden<99))
    cat("Number of Children with Iden < 97 is",file = fileName,append = TRUE,fill=TRUE,
        sum(df$Iden<97))
  }
}

getIdentityTables<-function(df,name){

  identities=c(100,99,98,97,95,90)
  mat<-matrix(NA,ncol=length(identities),nrow=1,dimnames =list(name,identities))
  mat[1,]<-sapply(identities,function(x) sum(df$Iden>=x)/nrow(df))
  return(mat)
}

#*********************Figure***********************
df<-lapply(datasets,loadTable,dada2=FALSE)
df_addedIden<-mapply(calculatedIdentity,df,sequenceLength,SIMPLIFY = FALSE)
mapply(getIdentities,df_addedIden,datasets,dada2=FALSE)
df.identities<-mapply(getIdentityTables,df_addedIden,datasets)
identities<-c(100,99,98,97,95,90)
colnames(df.identities)<-datasets
rownames(df.identities)<-identities

dada2.blast<-lapply(datasets,loadTable,dada2=TRUE)
dada2.blast_addedIden<-mapply(calculatedIdentity,dada2.blast,sequenceLength,SIMPLIFY = FALSE)
mapply(getIdentities,dada2.blast_addedIden,datasets,dada2=TRUE)
dada2.identities<-mapply(getIdentityTables,dada2.blast_addedIden,datasets)
rownames(dada2.identities)<-identities
colnames(dada2.identities)<-datasets

pdf("./figures/blastResult.pdf",width = 10,height = 7)
par(mfrow=c(2,3))
for (i in colnames(df.identities)){
  plot(identities,df.identities[,i],type = "b",
       ylim=c(0,1),
       xlab="Identity",
       ylab="Cumulative fraction of SVs",
       main = paste(capitalize(i),"dataset"),col="#E6AB02",lwd=2)
  legend("bottomleft",legend=c("HashSeq","DADA2"),col=c("#E6AB02","#7570B3"),pch=1)
  lines(identities,dada2.identities[,i],col="#7570B3",type = "b",lwd=2)
}
dev.off()

