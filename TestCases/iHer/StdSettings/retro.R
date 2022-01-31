source("../../../Rscripts/readSepar.r")

rby <- rbya <- rba <- aicinfo <- surveytotalpow <-  list()
PIN <- FALSE  # If true the assessment with one more year is put as start.  
inputfile <- "iceher.dat.opt.final"
for(year in c(2020:2001)){        
  print(year) 
  assyear <- year+1
  txt <- readLines(inputfile)
  txt <- Replace(txt,year,'# Last opt year')
  txt <- Replace(txt,min(c(year+2,2020)),'# Last data year')
 
  if(PIN && (year != 2020))Changepinfile("muppet.par",txt = c("# lnRecr:","# lnEffort:"),outputfile="muppet.pin")
  write.table(txt,file="iceher.dat.opt",sep="\n",row.names=F,quote=F,col.names=F)
  system("muppet -nox -ind iceher.dat.opt > /dev/null")
  res <- read_separ1(".",".",fleetnames=c("1"),assYear=year+1)
  rby[[as.character(assyear)]] <- res$rby
  rbya[[as.character(assyear)]] <- res$rbya
  rba[[as.character(assyear)]] <- res$rba
  aicinfo[[as.character(assyear)]] <- res$aicinfo
  surveytotalpow[[as.character(assyear)]] <- res$surveytotalpow
  

                                        # Those mv are really not needed but we do at least to remove the files.
  if(any(!is.na(match("tmpresults",dir())))){
      system(paste("mv resultsbyyear tmpresults/resultsbyyear",year,sep=""))
      system(paste("mv resultsbyyearandage tmpresults/resultsbyyearandage",year,sep=""))
      system(paste("mv resultsbyage tmpresults/resultsbyage",year,sep=""))
  }
}

rby <- bind_rows(rby)
rbya <- bind_rows(rbya)
rba <- bind_rows(rba)
aicinfo <- bind_rows(aicinfo)
aicinfo$assYear <- unique(rby$assYear)
surveytotalpow <- bind_rows(surveytotalpow)
surveytotalpow$assYear <- unique(rby$assYear)
  
save(list=c("rby","rbya","rba","aicinfo","surveytotalpow"),file="retro.rdata")
