source("readSepar.r")
library(stringr)
library(tidyverse)

rby <- rbya <- rba <- aicinfo <- scorr <- tagloss <- tagmort <-  list()
PIN <- TRUE

inputfile <- "mackerel.dat.opt.final"
for(year in c(2020:2015)){        
  print(year) 
  assyear <- year+1
  txt <- readLines(inputfile)
  txt <- Replace(txt,year,'# Last opt year')
  txt <- Replace(txt,min(c(year+2,2020)),'# Last data year')
 
  if(PIN && (year != 2020))Changepinfile("muppet.par",txt = c("# lnRecr:","# lnEffort:"),outputfile="muppet.pin")
  write.table(txt,file="mackerel.dat.opt",sep="\n",row.names=F,quote=F,col.names=F)
  system("./muppet -nox -ind mackerel.dat.opt > /dev/null")
  res <- read_separ1(".",".",fleetnames=c("1","2","3"),assYear=year+1)
  rby[[as.character(assyear)]] <- res$rby
  rbya[[as.character(assyear)]] <- res$rbya
  rba[[as.character(assyear)]] <- res$rba
  aicinfo[[as.character(assyear)]] <- res$aicinfo
  scorr[[as.character(assyear)]] <- res$surveycorr[2]
  tagmort[[as.character(assyear)]] <- res$tagmort
  tagloss[[as.character(assyear)]] <- res$tagloss
  
 

                                        # Those mv are really not needed but we do at least to remove the files.
  if(file.exists("tmpresults")){
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
scorr <- bind_rows(scorr)
print(scorr)
scorr$assYear <- unique(rby$assYear)
assy <- unique(rby$assYear)

tagmort <- bind_rows(tagmort)
tagmort <- data.frame(assYear=assy,tagmort=c(unlist(tagmort)))


tagloss <- bind_rows(tagloss)
tagloss <- data.frame(assYear=assy,tagloss=c(unlist(tagloss)))

print(tagloss)
   
save(list=c("rby","rbya","rba","aicinfo","scorr","tagmort","tagloss"),file="retro.rdata")
