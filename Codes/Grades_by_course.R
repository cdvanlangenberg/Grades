# make sure to use 32 bit version of R for the ODBC connection to work propperly

if(!require(lattice)) install.packages("lattice")
if(!require(RODBC)) install.packages("RODBC")

library(RODBC)
library(lattice)

# GradesDB=file.path("GradesDistributions.accdb")
# GradeDB=odbcConnectAccess2007(GradesDB)

GradeDB=odbcConnectAccess2007(path.expand("GradesDistributions.accdb"))

#-----------------will select only the past 9 semesters------------
tt<-sqlTables(GradeDB, tableType = "TABLE")$TABLE_NAME
uu <- gsub(pattern = "Fall",replacement = "01aug", tt)
uu <- gsub(pattern = "Spring",replacement = "01jan", uu)
uu <- sort(strptime(uu, "%d%b%Y"), decreasing = T)[1:9]
uu <- format(uu, format = "%b%Y")
uu <- gsub(pattern = "Aug",replacement = "Fall", uu)
uu <- gsub(pattern = "Jan",replacement = "Spring", uu)
tt <- tt[tt%in%uu]
# start <- ifelse((length(tt)-8)<1,1,(length(tt)-8))
# tt<-tt[start:length(tt)]

#-----------------read data ---------------------------------------
F11=sqlFetch(GradeDB,sqtable = tt[1]) # or simply say "Fall2011" the table names
F12=sqlFetch(GradeDB, sqtable = tt[2])[,names(F11)]
F13=sqlFetch(GradeDB, sqtable = tt[3])[,names(F11)]
F14=sqlFetch(GradeDB, sqtable = tt[4])[,names(F11)]
S11=sqlFetch(GradeDB, sqtable = tt[5])[,names(F11)]
S12=sqlFetch(GradeDB, sqtable = tt[6])[,names(F11)]
S13=sqlFetch(GradeDB, sqtable = tt[7])[,names(F11)]
S14=sqlFetch(GradeDB, sqtable = tt[8])[,names(F11)]
S15=sqlFetch(GradeDB, sqtable = tt[9])[,names(F11)]

Grades=data.frame(rbind(F11, F12, F13,F14,S11, S12, S13, S14, S15))
Grades$semester <- paste0(substr(Grades$TermCode, 1,4),"-",substr(Grades$TermCode, 5,6))

attach(Grades)
AdjGrades=data.frame(cbind(subset(Grades), 
                           A=(Grades[,"Tot_A"]+Grades[,"Tot_Aplus"]+Grades[,"Tot_Aminus"]),
                           B=(Grades[,"Tot_B"]+Grades[,"Tot_Bplus"]+Grades[,"Tot_Bminus"]),
                           C=(Grades[,"Tot_C"]+Grades[,"Tot_Cplus"]+Grades[,"Tot_Cminus"]),
                           D=(Grades[,"Tot_D"]+Grades[,"Tot_Dplus"]+Grades[,"Tot_Dminus"]),
                           F_=(Grades[,"Tot_F"]),
                           W=(Grades[,"Tot_W"]),
                           WF=(Grades[,"Tot_WF"])),
                           DFW=rowSums(Grades[,c("Tot_D","Tot_Dplus","Tot_Dminus","Tot_F","Tot_W","Tot_WF")]))
detach(Grades)



title=paste("from",min(Grades$semester),"to",max(Grades$semester))
Type="DFW" 

write.csv(AdjGrades, "AdjGrades.csv")
saveRDS(AdjGrades, "AdjGrades.Rds")

T1=table(Grades[,"SCHEDULE"],Grades[,"SubjNumb"],Grades[,"TermCode"])
T2=table(Grades[,"SCHEDULE"],Grades[,"TermCode"])
T3=table(Grades[,"SubjNumb"],Grades[,"TermCode"])
S3=(rbind(T3, Total=colSums(T3)))
S2=rbind(T2, Total=colSums(T2))

L=levels(factor(AdjGrades$TermCode))


###########
y=50 #graph height

class=levels(AdjGrades$SubjNumb)
for(kk in 1:length(class)){  
Course=subset(AdjGrades, AdjGrades$SubjNumb ==class[kk]) 
Course_T=aggregate(cbind(Tot_Enr, A, B, C, D, F_, W, WF)~TermCode,data=Course,FUN=sum)
Course_P=cbind(Course_T[,1],round(100*(Course_T[,3:9]/Course_T[,2]),digits=2)) 
name=c("A", "B", "C", "D","F", "W", "WF")
colnames(Course_T)=c("Semester","Enroll", name)
colnames(Course_P)=c("Semester", name)
#Course_T
#Course_P
""
################
pdf(file=paste0(Course[1,"SubjNumb"],"_",Type,".pdf"),width=12, height=7)

#DFW graphs
DFW_T=aggregate(cbind(Tot_Enr, DFW)~TermCode,data=Course,FUN=sum)
DFW_P=cbind(DFW_T[,1],round(100*(DFW_T[,3]/DFW_T[,2]),digits=2))
x2=as.numeric(DFW_P[,2])
par(mfrow=c(2,1))
barplot(x2,axisnames=T,names.arg=DFW_P[,1],
        cex.lab=1.2, ylim=c(0,y),xlab="Semester",ylab="Grade percentage")
lines(lowess(x2, f=2),type="l", lwd=2)
abline(h=seq(5,(y-5),by=5), lty=3)
axis(2, at=seq(0,y,by=5))

plot(x2, type="b", col="blue",bty="n",axes=F,
        cex.lab=1.2, ylim=c(0,y),xlab="Semester",ylab="Grade percentage")
abline(h=seq(5,(y-5),by=5), lty=3)
axis(2, at=seq(0,y,by=10))
axis(1, at=1:length(L),labels=L)
mtext(text=paste(Course[1,"SubjNumb"],Type,"trend", title), line=-2,cex=1.4, outer=T)

par(mfrow=c(3,3))
for(i in 1:length(Course_P[,1])){
x=as.numeric(Course_P[i,2:8])
barplot(x,lwd=2,axes=F, axisnames=T,names.arg=name,
        cex.lab=1.2, ylim=c(0,y),xlab=paste(Course_P[i,1]),ylab="Grade percentage")
abline(h=seq(5,(y-5),by=5), lty=3)
axis(2, at=seq(0,y,by=5))
}
mtext(text=paste(Course[1,"SubjNumb"],"Grade Distribution", title), line=-2,cex=1.4, outer=T)


##############

  DFW_M_T=aggregate(cbind(Tot_Enr, DFW)~TermCode+SCHEDULE,data=Course,FUN=sum)
  DFW_M_P=data.frame(cbind(DFW_M_T, DFW_=round(100*(DFW_M_T[,4]/DFW_M_T[,3]),digits=2)))
  Method=levels(AdjGrades$SCHEDULE)

#c("LEC", "WEB", "WLL", "WTX")
  par(mfrow=c(2,2))
  for(jj in 1:4){
    MData=subset(DFW_M_P, DFW_M_P$SCHEDULE==Method[jj])
    x3=as.numeric(MData[,5])
    if(length(x3)!=0){
    
    barplot(x3, axes=F, axisnames=T,names.arg=MData[,1],
            cex.lab=1.2, ylim=c(0,y+10),xlab="Semester",ylab="Grade percentage",
            main=paste(Method[jj]))
    lines(lowess(x3, f=2),type="l", lwd=2)
    abline(h=seq(5,(y),by=5), lty=3)
    axis(2, at=seq(0,y+5,by=5))
    }
 }
  mtext(text=paste(Course[1,"SubjNumb"],Type, "trend", title), line=-2,cex=1.4, outer=T)

dev.off()
}

#rm(list=ls())
#gc()
