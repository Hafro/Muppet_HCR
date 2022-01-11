dat <- read.table("survey1.dat",col.names=c("year","age","ind"))
tmp <- c(87.4,1399.8,1114.7,424.3,138.2,82.0,127.7,66.5,102.8,82.8,63.5,57.0,22.8,11.1,19.7,1.9)
i <- dat$year %in% 2020 
dat$ind[i] <- tmp[2:(length(tmp)-1)]
dat1 <- dat
dat1$year <- dat1$year +1
dat1$age <- dat1$age+1
dat1  <- dat1[dat1$age < 16,]
names(dat)[1] <- names(dat1)[1] <- "#year"
write.table(dat,file="survey1lokars.dat",row.names=F,col.names=T,sep="\t",quote=F)
write.table(dat1,file="survey1byrjunars.dat",row.names=F,col.names=T,sep="\t",quote=F)

