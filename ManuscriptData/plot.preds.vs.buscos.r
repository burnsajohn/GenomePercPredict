
library(ggplot2)
library(drc)

###read in data table contianing busco info and prediction info
predbusc<-read.table("36phagocytes.buscos.vs.modelpreds.txt",header=T,sep=",")

###extract genome percent info for plotting
subs<-do.call(rbind,strsplit(predbusc[,1],"[.]"))
subs2<-apply(subs,1,function(x) as.numeric(paste(x[1:2],collapse=".")))
predbusc$genome.perc<-subs2


#Figure2A--individual subsample preds and buscos vs. genome completeness
EPnum<-"EP00456" ###enter species here
specnam<-predbusc[grep(EPnum,predbusc[,2]),2]
specnam<-as.character(levels(factor(specnam)))
bp.spec<-predbusc[grep(EPnum,predbusc[,2]),]
cols <- c("BUSCOs"="red","Phagocytosis Prediction"="black")
p <- ggplot(bp.spec, aes(x = genome.perc))
p <- p + geom_smooth(aes(y = BuscosFound,colour="BUSCOs"),se=F) + geom_point(aes(y = BuscosFound,colour="BUSCOs"))
p <- p + geom_smooth(aes(y = Phagocyte.generalist.prediction*255,colour="Phagocytosis Prediction"),se=F) + geom_point(aes(y = Phagocyte.generalist.prediction*255,colour="Phagocytosis Prediction"), shape = 2)
p <- p + scale_y_continuous(sec.axis = sec_axis(~./255, name = "Phagocytosis Prediction"))
p<-p + xlab("Proportion of genome") + ylab("#BUSCOs detected")
p<-p + scale_color_manual(name="",values = cols) + guides(colour = guide_legend(override.aes = list(shape = c(19,2))))
p + ggtitle(specnam)


#Figure2B--all subsample preds vs buscos
qplot(BuscosFound,Phagocyte.generalist.prediction, data = predbusc, color = factor(Species), geom=c("point"),show.legend = FALSE) + 
xlim(0,255) + ylim(-0.1,1.2) + xlab("#BUSCOS detected") + ylab("Phagocytosis prediction probability") + 
geom_vline(xintercept = 150, linetype="dashed", color = "red", size=1) +
geom_hline(yintercept = 0.5, linetype="dashed", color = "black", size=1)



#Figure2C
###determine empirical probability that phagocytosis prediction score is greater than 0.5 for a given number of BUSCOs detected for all subsets of all organisms.
prob<-matrix(nrow=251,ncol=2)
count=1
for(i in 5:255){
prob[count,1]<-i
prob[count,2]<-sum(predbusc[predbusc[,"BuscosFound"]==i,"Phagocyte.generalist.prediction"]>0.5)/length(predbusc[predbusc[,"BuscosFound"]==i,"Phagocyte.generalist.prediction"])
count<-count+1
}

###model using weibull distribution
model <- drm((prob[,2]) ~ prob[,1], fct = W2.3())

###predict probability that a true phagocyte would be predicted given a number of buscos counted
new.p <- data.frame(
  bk = c(12, 100, 150)
)
predict(model,new.p)

###plot probability estimate vs #BUSCOs
confdata<-as.data.frame(predict(model,interval="prediction",level=0.95))
prob2<-as.data.frame(prob)
confdata$busco<-prob2[,1]
ggplot(prob2, aes(x = prob2[,1], y = prob2[,2])) + ylim(c(-0.1,1.2)) +
geom_point() + xlab("#BUSCOs detected") + ylab("Probability of accurate phagocytosis prediction") +
geom_ribbon(data=confdata, aes(x=busco, y=Prediction, ymin=Lower, ymax=Upper), alpha=0.2) +
geom_line(data=confdata, aes(x=busco, y=Prediction)) +
geom_vline(xintercept = 150, linetype="dashed", color = "red", size=1)
