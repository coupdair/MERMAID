#!/usr/bin/Rscript

#check file size of an entire day

file_name='20140426.ftpR'
#argument
args=commandArgs(TRUE)
file_name=args[1]

#file disk usage limits
du.max=15000
du.min=11000

#table
t=read.table(file_name)
date=strptime(t$V1, "%Y%m%d_%H%M%S.dat")
summary(date)
du=t$V2
summary(du)

#plot limits
dM=du*0+du.max
dm=du*0+du.min
title=paste("Licor/",file_name,": OK value E [",du.min," .. ",du.max,"]")
dm.lim=c(du.min-1000,du.max+1000)
du.lim=c(min(du),max(du))
ylim=c(min(du.lim[1],dm.lim[1])
     , max(du.lim[2],dm.lim[2])
     )
ylim

#plot
file_name=paste(file_name,".pdf", sep="")
pdf(file_name)
plot(date,du
 , main=title
 , xlab="time (hour:min)"
 , ylab="file size (byte)"
 , ylim=ylim
 )
lines(date,dM)
lines(date,dm)
mtext(paste("\n",format(Sys.time(), "%d/%m/%Y %Hh%M"),"report"), col="blue", cex=1.23, side=1) #bottom
dev.off()

