basedir <- "//home/hoski/Tac2018/HCR/Plaice"
basedir1 <- "/home/hoski/Tac2018/HCR/"
source(paste(basedir1,"Model/Read.r",sep="/"))
inputprogfile  <- paste(basedir,"Files/plaiceprognosis.dat.biorule",sep="/")
progoutfile <- "plaiceprognosis.dat"
savefile <- "HCRrun.rdata"
sumfile <- "HCRrunsum.rdata"
inputfile <- "iceplaice.dat.prog"
model <- "muppet"
                                        # Runs set up to avoid rbinds.
parameters <- expand.grid(list(HarvestRate=c(0.1,0.15,0.2),Btrigger=c(1,20,30),RecrCorr=c(0.35),Meanwtyears=c(10),WeightCV=0.08,AssessmentCV=0.2,AssessmentCorr=0.7)) 
  cn <- names(parameters)
  i <- 1
  tmpresult <- OneRun(HarvestRate=parameters$HarvestRate[i],AssessmentCorr=parameters$AssessmentCorr[i],AssessmentCV=parameters$AssessmentCV[i],Btrigger=parameters$Btrigger[i],RecrCorr=parameters$RecrCorr[i],Meanwtyears=parameters$Meanwtyears[i],WeightCV=parameters$WeightCV[i],inputprogfile=inputprogfile,inputfile=inputfile,progoutfile=progoutfile,path="",model=model)
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
    tmpresult <- OneRun(HarvestRate=parameters$HarvestRate[i],AssessmentCorr=parameters$AssessmentCorr[i],AssessmentCV=parameters$AssessmentCV[i],Btrigger=parameters$Btrigger[i],RecrCorr=parameters$RecrCorr[i],Meanwtyears=parameters$Meanwtyears[i],WeightCV=parameters$WeightCV[i],inputprogfile=inputprogfile,inputfile=inputfile,progoutfile=progoutfile,path="",model=model)
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
  HCRsettings <- readLines(progoutfile)
  
  save(list=c("HCRsettings","alldata","sumdata"),file=savefile)
  save(list=c("HCRsettings","sumdata"),file=sumfile)
  

