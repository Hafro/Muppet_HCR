moddir <- "../Model"
source(paste(moddir,"Read.r",sep="/"))
basedir <- ".."
inputprogfile  <- paste(basedir,"Files/codprognosis.dat.biorule.assyear",sep="/")
savefile <- "HCRrun.rdata"
sumfile <- "HCRrunsum.rdata"
inputfile <- "icecod.dat.prog"

                                        # Runs set up to avoid rbinds.
parameters <- expand.grid(list(HarvestRate=c(0.06,0.08,0.1,0.12,0.14,seq(0.15,0.26,by=0.01),seq(0.28,0.4,by=0.02)),RecrCorr=0.3,Btrigger=c(40,220),Meanwtyears=20,AssessmentCV=0.13,AssessmentCorr=0.57,WeightCV=0.08,WeightCorr=0.62))
   
 cn <- names(parameters)
 i <- 1
tmpresult <- OneRun(HarvestRate=parameters$HarvestRate[i],Btrigger=parameters$Btrigger[i],
                    Meanwtyears=parameters$Meanwtyears[i],WeightCV=parameters$WeightCV[i],
                    WeightCorr=parameters$WeightCorr[i],AssessmentCV=parameters$AssessmentCV[i],
                    AssessmentCorr=parameters$AssessmentCorr[i],RecrCorr=parameters$RecrCorr[i],
                    inputprogfile=inputprogfile,inputfile=inputfile,progoutfile="codprognosis.dat")


  sumdata <- tmpresult$summary
  result <- tmpresult$data
  for(j in 1:length(cn))sumdata[,cn[j]] <- parameters[i,cn[j]]
  for(j in 1:length(cn))result[,cn[j]] <- parameters[i,cn[j]]
  n <- nrow(result) 
  
  alldata <- data.frame(matrix(0,nrow=nrow(result)*nrow(parameters),ncol=ncol(result)))
  names(alldata) <- names(result)
  alldata[1:n,] <- result
  index <- n+1
  for(i in 2:nrow(parameters)) {
    print(i)
    tmpresult <- OneRun(HarvestRate=parameters$HarvestRate[i],Btrigger=parameters$Btrigger[i],
                        Meanwtyears=parameters$Meanwtyears[i],WeightCV=parameters$WeightCV[i],
                    WeightCorr=parameters$WeightCorr[i],AssessmentCV=parameters$AssessmentCV[i],
                    AssessmentCorr=parameters$AssessmentCorr[i],RecrCorr=parameters$RecrCorr[i],
                    inputprogfile=inputprogfile,inputfile=inputfile,progoutfile="codprognosis.dat")
    tmpsumdata <- tmpresult$summary
    tmpresult <- tmpresult$data
    for(j in 1:length(cn))tmpsumdata[,cn[j]] <- parameters[i,cn[j]]
    for(j in 1:length(cn))tmpresult[,cn[j]] <- parameters[i,cn[j]]
    sumdata <- rbind(sumdata,tmpsumdata)
    alldata[index:(index+nrow(tmpresult)-1),] <- tmpresult
    index <- index+nrow(tmpresult)
#    alldata[(n*(i-1)+1):(n*i),] <- tmpresult
  }
  alldata <- alldata[1:(index-1),]  
  HCRsettings <- readLines(inputprogfile)
  
  save(list=c("HCRsettings","alldata","sumdata"),file=savefile)
  save(list=c("HCRsettings","sumdata"),file=sumfile)
  

