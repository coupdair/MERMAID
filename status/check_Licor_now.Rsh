#!/usr/bin/Rscript

#check file size of an entire day

file_name='20140426.ftpR'
#argument
args=commandArgs(TRUE)
file_name=args[1]

#file disk usage limits
du.max=15000
du.min=11000

#status time limit, e.g. 5*60 for 5 min.
time_limit=8*60

#table
t=read.table(file_name)
date=strptime(t$V1, "%Y%m%d_%H%M%S.dat")
summary(date)
du=t$V2
summary(du)

time=Sys.time()
time_lim=time-time_limit #setup margin time for status
time.square=c(time_lim,time_lim,time,time,time_lim)
du.square=c(du.min,du.max,du.max,du.min,du.min)
date=c(date,time.square)
du=c(du,du.square)

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

#status
time.status=(time_lim<(date[length(date)-length(time.square)]))
dm.bool=du<du.min
dM.bool=du>du.max
dm.status=(length(dm.bool[dm.bool==TRUE])+length(dM.bool[dM.bool==TRUE]))==0

#plot
file_name=paste(file_name,".pdf", sep="")
pdf(file_name)
plot(date,du
 , main=title
 , xlab="time (min:s)"
 , ylab="file size (byte)"
 , ylim=ylim
 )
lines(date,dM)
lines(date,dm)
if(time.status
  && dm.status
  )
{
  lines(time.square,du.square, col="green", lwd=2)
  mtext("status ok", col="green", cex=2)
}else{
  lines(time.square,du.square, col="red", lwd=4)
  mtext("status error", col="red", cex=3)
}
mtext(paste("\n",format(time, "%d/%m/%Y %Hh%M"),"report"), col="blue", cex=1.23, side=1) #bottom
dev.off()


