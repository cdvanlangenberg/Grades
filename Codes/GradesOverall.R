#AdjGrades=read.csv("AdjGrades.csv", header=T)

AdjGrades=readRDS("AdjGrades.Rds")

title=paste("from",min(AdjGrades$semester),"to",max(AdjGrades$semester))
Type="DFW" 

Course_T=aggregate(cbind(Tot_Enr, A, B, C, D, F_, W, WF)~TermCode,data=AdjGrades,FUN=sum)
Course_P=cbind(Course_T[,1],round(100*(Course_T[,3:9]/Course_T[,2]),digits=2)) 
name=c("A", "B", "C", "D","F", "W", "WF")
colnames(Course_T)=c("Semester","Enroll", name)
colnames(Course_P)=c("Semester", name)
#Course_T
#Course_P

################

pdf(file=paste("Overall.pdf"),width=10, height=7)
par(mfrow=c(3,3))
for(i in 1:length(Course_P[,1])){
  x=as.numeric(Course_P[i,2:8])
  barplot(x,lwd=2,axes=F, axisnames=T,names.arg=name,
          cex.lab=1.2, ylim=c(0,30),xlab=paste(Course_P[i,1]),ylab="Grade percentage")
  abline(h=seq(5,25,by=5), lty=3)
  axis(2, las=2,at=seq(0,30,by=5))
}
mtext(text=paste("Overall Grade Distriubition", title), line=-3,cex=1.4, outer=T)

#DFW graphs
DFW_T=aggregate(cbind(Tot_Enr, DFW)~TermCode,data=AdjGrades,FUN=sum)
DFW_P=cbind(DFW_T[,1],round(100*(DFW_T[,3]/DFW_T[,2]),digits=2))
#DFW_P
x2a=as.numeric(DFW_P[,2])
par(mfrow=c(1,1))
barplot(x2a,axisnames=T,names.arg=DFW_P[,1],axes=F,
        cex.lab=1.2, ylim=c(0,60),xlab="Semester",ylab="Grade percentage") 
lines(lowess(x2a, f=5),type="l", lwd=2)
abline(h=seq(5,55,by=5), lty=3)
axis(2,las=2, at=seq(0,60,by=5))
mtext(text=paste("Overall DFW Trend"), line=-2,cex=1.4, outer=T)
mtext(text=paste(title), line=-3,cex=1.3, outer=T)


DFW_T1=aggregate(cbind(Tot_Enr, DFW)~SubjNumb,data=AdjGrades,FUN=sum)
DFW_P1=cbind(DFW_T1,DFW_=round(100*(DFW_T1[,3]/DFW_T1[,2]),digits=2))
x3a=as.numeric(DFW_P1[,4])
par(mfrow=c(1,1))
barplot(x3a,axisnames=T,names.arg=DFW_P1[,1],axes=F,
        cex.lab=1.2, ylim=c(0,60),xlab="Semester",ylab="Grade percentage") 
abline(h=seq(5,55,by=5), lty=3)
axis(2, las=2, at=seq(0,60,by=5))
mtext(text=paste("Overall DFW each course"), line=-2,cex=1.4, outer=T)
mtext(text=paste(title), line=-3,cex=1.3, outer=T)

##############

DFW_M_T=aggregate(cbind(Tot_Enr, DFW)~TermCode+SCHEDULE,data=AdjGrades,FUN=sum)
DFW_M_P=data.frame(cbind(DFW_M_T, DFW_=round(100*(DFW_M_T[,4]/DFW_M_T[,3]),digits=2)))
#DFW_M_P
Method=c("LEC", "WEB", "WLL", "WTX")
par(mfrow=c(2,2))
for(jj in 1:4){
  MData=subset(DFW_M_P, DFW_M_P$SCHEDULE==Method[jj])
  x4a=as.numeric(MData[,5])
  barplot(x4a, axes=F, axisnames=T,names.arg=MData[,1],las=2,
          cex.lab=1.2, ylim=c(0,60),xlab="",ylab="Grade percentage",
          main=)
  title(paste(Method[jj]),line=-0.5)
  lines(lowess(x4a, f=5),type="l", lwd=2)
  abline(h=seq(5,50,by=5), lty=3)
  axis(2, las=2, at=seq(0,50,by=5))
}
mtext(text=paste("Overall DFW trend",title), line=-2,cex=1.4, outer=T)
dev.off()





