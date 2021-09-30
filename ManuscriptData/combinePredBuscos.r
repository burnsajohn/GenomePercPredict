x<-read.table("36phagocytes_subs_buscosTable.txt",sep=",")
y<-read.table("36phagocytes_subs_predictionTable.txt",header=T,sep="\t")

#initialize columns to hold percent genome and iteration to match buscos with predictions for the same subsample
y$perc<-NA
y$iter<-NA
y$subsamp<-NA
y$species<-NA
x$perc<-NA
x$iter<-NA
x$subsamp<-NA
x$species<-NA

###extract percent genome and subsample iteration information from sample name
for(i in 1:length(y[,1])){
myln<-unlist(strsplit(y[,1][i],"\\."))
perc<-as.numeric(paste(myln[1],myln[2],sep="."))
iter<-as.numeric(myln[3])
subs<-paste(myln[1],myln[2],myln[3],sep=".")
spec<-myln[4]
y$perc[i]<-perc
y$iter[i]<-iter
y$subsamp[i]<-subs
y$species[i]<-spec
}

for(i in 1:length(x[,1])){
myln<-unlist(strsplit(x[,1][i],"\\."))
perc<-as.numeric(paste(myln[1],myln[2],sep="."))
iter<-as.numeric(myln[3])
subs<-paste(myln[1],myln[2],myln[3],sep=".")
spec<-myln[4]
x$perc[i]<-perc
x$iter[i]<-iter
x$subsamp[i]<-subs
x$species[i]<-spec
}

###combine busco and pred info into single data table *relies on data matching up exactly after ordering* not smart tabling, but sufficient.

y2<-y[order(y$species,y$perc,y$iter),]
x2<-x[order(x$species,x$perc,x$iter),]

z<-matrix(nrow=length(x2[,1]),ncol=9)
zhead<-c("Subsample","Species","BuscosMissing","BuscosFound","Phagocyte.generalist.prediction","Phagocyte.entamoebid.prediction","Phagocyte.rozellid.prediction","Prototrophy.prediction","Photosynthesis.prediction")

z[,1]<-x2$subsamp
z[,2]<-x2$species
z[,3]<-x2[,2]
z[,4]<-255-x2[,2]
z[,5]<-y2$Phagocyte.generalist.prediction
z[,6]<-y2$Phagocyte.entamoebid.prediction
z[,7]<-y2$Phagocyte.rozellid.prediction
z[,8]<-y2$Prototrophy.prediction
z[,9]<-y2$Photosynthesis.prediction

colnames(z)<-zhead

write.table(z,"36buscosvsmodelpreds.txt",quote=F,sep=",")

