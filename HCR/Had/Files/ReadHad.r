# File to run HCR for haddock based on TAC compiled from estimated biomass
# in the beginning of the assessment year.  

basedir <- "//home/hoski/Tac2018/HCR/Had"
basedir1 <- "/home/hoski/Tac2018/HCR/"
source(paste(basedir1,"Model/Read.r",sep="/"))
inputprogfile  <- paste(basedir,"Files/hadprognosis.dat.biorule.assyear",sep="/")
progoutfile <- "hadprognosis.dat"
savefile <- "HCRrunass.rdata"
sumfile <- "HCRrunsumass.rdata"
inputfile <- "icehad.dat.prog"
model <- "muppet"
                                        # Runs set up to avoid rbinds.
parameters <- expand.grid(list(HarvestRate=seq(0.12,0.54,by=0.02),Btrigger=c(5,45,60),RecrCorr=c(0.35),Meanwtyears=c(10),WeightCV=0.08,AssessmentCV=0.2,AssessmentCorr=0.7,HCRreflength=c(37.5))) 
  cn <- names(parameters)
  i <- 1
  tmpresult <- OneRun(HarvestRate=parameters$HarvestRate[i],AssessmentCorr=parameters$AssessmentCorr[i],AssessmentCV=parameters$AssessmentCV[i],Btrigger=parameters$Btrigger[i],RecrCorr=parameters$RecrCorr[i],Meanwtyears=parameters$Meanwtyears[i],WeightCV=parameters$WeightCV[i],inputprogfile=inputprogfile,inputfile=inputfile,HCRreflength=parameters$HCRreflength[i],progoutfile=progoutfile,path="",model=model)
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
    tmpresult <- OneRun(HarvestRate=parameters$HarvestRate[i],AssessmentCorr=parameters$AssessmentCorr[i],AssessmentCV=parameters$AssessmentCV[i],Btrigger=parameters$Btrigger[i],RecrCorr=parameters$RecrCorr[i],Meanwtyears=parameters$Meanwtyears[i],WeightCV=parameters$WeightCV[i],HCRreflength=parameters$HCRreflength[i],inputprogfile=inputprogfile,inputfile=inputfile,progoutfile=progoutfile,path="",model=model)
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
  

