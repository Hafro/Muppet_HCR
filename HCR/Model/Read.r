



require(plyr)
readmcmcfile <- function(file,cn="ssb") {
  dat <- read.table(file,header=T)
  firstyear <- names(dat)[1]
  n <- nchar(firstyear)
  firstyear <- as.numeric(substring(firstyear,n-3,n))
  years <- firstyear:(firstyear+ncol(dat)-1)
  niter <- 1:nrow(dat)
  result <- expand.grid(list(niter=niter,year=years))
  result[,cn] <- c(unlist(dat))
  return(result)
}
Replace <- function(txt,parameter,pattern){
  if(!missing(parameter)){
    i <- grep(pattern,txt)
    if(!any(i)){
      print(paste("   ",pattern,"   ","does not exist"))
          break()
      }
      txt[i] <- paste(as.character(parameter),"\t",pattern)
   }
  return(txt)
  }
  
  
OnePlaiceRun <- function(FishingMortality,HarvestRate,WeightCorr,WeightCV,RecrCorr,AssessmentCV,AssessmentCorr,AssessmentBias,Btrigger,MaxChange,Meanwtyears,LastYearsTacRatio,file='plaiceprognosis.dat',inputfile="iceplaice.dat.prog",path=".",progoutfile="plaiceprognosis.dat"){
  txt <- readLines(file)
  txt <- Replace(txt,FishingMortality,'# FishingMortality')
  txt <- Replace(txt,HarvestRate,'# HarvestRate')
  txt <- Replace(txt,WeightCorr,'# WeightCorr')
  txt <- Replace(txt,WeightCV,'# WeightCV')
  txt <- Replace(txt,RecrCorr,'# RecrCorr')
  txt <- Replace(txt,AssessmentCV,"# AssessmentCV")
  txt <- Replace(txt,AssessmentCorr,"# AssessmentCorr")
  txt <- Replace(txt,AssessmentBias,"# AssessmentBias")
  txt <- Replace(txt,Btrigger,"# Btrigger")
  txt <- Replace(txt,MaxChange,"# MaxChange")
  txt <- Replace(txt,Meanwtyears,"# Meanwtyears")
  txt <- Replace(txt,LastYearsTacRatio,"# LastYearsTacRatio")

  write.table(txt,file=progoutfile,row.names=F,col.names=F,quote=F)
  system(paste("iceplaice"," -ind ",inputfile," -mceval",sep=""))
  catch <- readmcmcfile("catch.mcmc",cn="catch")
  catch <- join(catch,readmcmcfile("ssb.mcmc",cn="ssb"))
  catch <- join(catch,readmcmcfile("n1st.mcmc",cn="n1st"))
  catch <- join(catch,readmcmcfile("f.mcmc",cn="refF"))
  catch <- join(catch,readmcmcfile("refbio1.mcmc",cn="refbio1"))
#  catch <- join(catch,readmcmcfile("refbiowerr.mcmc",cn="refbiowerr"))
#  catch <- join(catch,readmcmcfile("ssbwerr.mcmc",cn="ssbwerr"))
  if(file.exists("m7.mcmc"))
    catch <- join(catch,readmcmcfile("m7.mcmc",cn="m7"))

  

  lastyear <- max(catch$year)
  n <- catch$year %in% ((lastyear-5):lastyear)
  summary <- data.frame(catchmean=mean(catch$catch[n]),catch10=quantile(catch$catch[n],0.1),catch05=quantile(catch$catch[n],0.05),catchmed=median(catch$catch[n]),ssbmean=mean(catch$ssb[n]),ssb10=quantile(catch$ssb[n],0.1),ssb05=quantile(catch$ssb[n],0.05),meanrec=mean(catch$n1[n]),rec05=quantile(catch$n1[n],0.05),meanF=mean(catch$refF[n]))
#Have to add more of those for more parameters.  
  result <- list(data=catch,summary=summary)
}

ReadOnesetOfFiles <- function(){
  catch <- readmcmcfile("catch.mcmc",cn="catch")
  catch <- join(catch,readmcmcfile("refbio.mcmc",cn="refbio"))
#  catch <- join(catch,readmcmcfile("refbiohcrwitherr.mcmc",cn="refbiowerr"))
  catch <- join(catch,readmcmcfile("ssb.mcmc",cn="ssb"))
  catch <- join(catch,readmcmcfile("n1.mcmc",cn="n1"))
  catch <- join(catch,readmcmcfile("f.mcmc",cn="refF"))
  catch <- join(catch,readmcmcfile("f.mcmc",cn="refF"))
#  catch <- join(catch,readmcmcfile("ssbwerr.mcmc",cn="ssbwerr"))

  if(file.exists("cbior.mcmc"))
    catch <- join(catch,readmcmcfile("cbior.mcmc",cn="cbior"))
  if(file.exists("cost1.mcmc"))
    catch <- join(catch,readmcmcfile("cost1.mcmc",cn="cost1"))
  if(file.exists("cost2.mcmc"))
    catch <- join(catch,readmcmcfile("cost2.mcmc",cn="cost2"))
  if(file.exists("value.mcmc"))
    catch <- join(catch,readmcmcfile("value.mcmc",cn="value"))
  if(file.exists("MeanWtInCatch.mcmc"))
    catch <- join(catch,readmcmcfile("MeanWtInCatch.mcmc",cn="mwc"))
  
  lastyear <- max(catch$year)
  n <- catch$year %in% ((lastyear-5):lastyear)
  summary <- data.frame(catchmean=mean(catch$catch[n]),catch10=quantile(catch$catch[n],0.1),catch05=quantile(catch$catch[n],0.05),catchmed=median(catch$catch[n]),ssbmean=mean(catch$ssb[n]),ssb10=quantile(catch$ssb[n],0.1),ssb05=quantile(catch$ssb[n],0.05),meanrec=mean(catch$n1[n]),rec05=quantile(catch$n1[n],0.05),meanF=mean(catch$refF[n]))
  return(list(summary=summary,alldata=catch))
}
