library(stringr)
library(tidyverse)

read_separ1 <- function (path, run, rName = NA, mName = NA, calcSurBio = F, 
                         ggFactor = F, Scale = 1000, assYear = NA, retroY = NA,fleetnames,calchr=1)
{
    if(file.exists("muppet.par")){ # get AIC could look for as.numeric=T
        dat <- scan("muppet.par",what=character(),sep=" ",quiet=T)[1:12]
        aicinfo <- as.numeric(c("0",dat[6],dat[11]))
        names(aicinfo) <- c("npar1","npar","objective")

        dat <- scan("muppet.par",what=character(),sep="\n",quiet=T)
        i <- grep("# surveytotalpow",dat)
        surveytotalpow <- as.numeric(dat[i+1])
        
        dat <- scan("muppet.par",what=character(),sep="\n",quiet=T)
        i <- grep("# Surveycorr",dat)
        surveycorr <- as.numeric(dat[i+1])
        
        dat <- scan("muppet.par",what=character(),sep="\n",quiet=T)
        i <- grep("# logTagmort",dat)
        tagmort <- as.numeric(dat[i+1])

        dat <- scan("muppet.par",what=character(),sep="\n",quiet=T)
        i <- grep("# logTagloss",dat)
        tagloss <- as.numeric(dat[i+1])


        
    }
    if(file.exists("muppet.std")) {# Better info about number of par 
        dat <- read.table("muppet.std",header=T)
        i <- c(grep("RefF",dat$name),grep("Spawningstock",dat$name))
        dat <- dat[-i,]
        j <- dat$std.dev < 50
        aicinfo["npar1"] <- nrow(dat[j,])
    }
     
    if(missing(fleetnames)){ # to have some default
                                        # Test number of columns
        if (is.na(retroY)) 
            rby <- read.table(paste(path, run, "resultsbyyear", sep = "/"), 
                              header = T, na.strings = c("-1", "0"))
        if (!is.na(retroY)) 
            rby <- read.table(paste(paste(path, run, "resultsbyyear", 
                                          sep = "/"), retroY, sep = ""),
                              header = T, na.strings = c("-1", "0"))
        nfleets <- (ncol(rby)-14)/2
        fleetnames <- as.character(1:nfleets)
    }
    txty <- paste(c("pU","oU"),c(matrix(fleetnames,2,length(fleetnames),byrow=T)),sep="")
    cnRby <- c("year", "r", "n3", "n6", "bioF", "bio", "bio1", 
               "ssb", "ssb2", "fbar", "hr", "oY", "pY",txty,"run", "model")
    txtya <- paste(c("pU","oU","rU"),c(matrix(fleetnames,3,length(fleetnames),byrow=T)),sep="")
    cnRbya <- c("year", "age", "oC", "cW", "sW", "ssbW", "mat", 
                "n", "z", "f", "m", "pC", "rC",txtya)
    txta<- paste(c("cvU","qU","pU"),c(matrix(fleetnames,3,length(fleetnames),byrow=T)),sep="")

    cnRba <- c("age", "sel", "pSel", "sigma", txta, "run", "model")
    if (is.na(retroY)) 
        rby <- read.table(paste(path, run, "resultsbyyear", sep = "/"), 
            header = T, na.strings = c("-1", "0"))
    if (!is.na(retroY)) {
        rby <- read.table(paste(paste(path, run, "resultsbyyear", 
            sep = "/"), retroY, sep = ""), header = T, na.strings = c("-1", 
            "0"))
    }
    n <- nrow(rby)
#    if (ncol(rby) != 18) {
#        rby$pU2 <- rep(NA, n)
#        rby$oU2 <- rep(NA, n)
#    }
    names(rby) <- c("year", "fbar", "pY", "oY", "ssb", "ssb2", 
        "bioF", "bio1", "bio", "preR", "r", "n1", "n3", "n6", 
        txty)
    if (ggFactor) 
        rby$r <- rby$r * exp(-0.4)
    if(calchr == 1) # Cod direct
        rby$hr <- ifelse(!is.na(rby$oY), rby$oY, rby$pY)/rby$bio
    if(calchr == 2){ #Sai skewed
        catch <-  ifelse(!is.na(rby$oY), rby$oY, rby$pY)
        c1 <- dplyr::lead(catch)
        rby$hr <- (catch*1/3+c1*2/3)/rby$bio
    }
    rby$run <- rName
    rby$model <- mName
    rby <- rby[, cnRby]
    rby$r <- rby$r/Scale
    rby$n3 <- rby$n3/Scale
    rby$n6 <- rby$n6/Scale
    if (is.na(retroY)) 
        rbya <- read.table(paste(path, run, "resultsbyyearandage", 
            sep = "/"), header = T, na.strings = c("-1", "0"))
    if (!is.na(retroY)) {
        rbya <- read.table(paste(paste(path, run, "resultsbyyearandage", 
            sep = "/"), retroY, sep = ""), header = T, na.strings = c("-1", 
            "0"))
    }
    n <- nrow(rby)
    names(rbya) <- c("year", "age", "n", "z", "sW", "m", "f", 
        "pC", "cW", "ssbW", "mat", "oC", "rC",txtya)
    if (ggFactor) 
        rbya$n <- ifelse(rbya$age %in% 1, rbya$n * exp(-0.4), 
            rbya$n)
    if (ggFactor) 
        rbya$n <- ifelse(rbya$age %in% 2, rbya$n * exp(-0.2), 
            rbya$n)
    rbya <- rbya[, cnRbya]
    rbya$run <- rName
    rbya$model <- mName
    rbya$oC <- rbya$oC/Scale
    rbya$cW <- rbya$cW/Scale
    rbya$sW <- rbya$sW/Scale
    rbya$n <- rbya$n/Scale
    rbya$pC <- rbya$pC/Scale
    if (is.na(retroY)) 
        rba <- read.table(paste(path, run, "resultsbyage", sep = "/"), 
            header = T, na.strings = c("-1", "0"))
    if (!is.na(retroY)) {
        rba <- read.table(paste(paste(path, run, "resultsbyage", 
            sep = "/"), retroY, sep = ""), header = T, na.strings = c("-1", 
            "0"))
    }
    n <- nrow(rba)
    names(rba) <- c("age", "sel", "pSel", "sigma", txta)
    rba$run <- rName
    rba$model <- mName
    rba <- rba[, cnRba]
    if (!is.na(retroY)) {
        print(retroY)
        rby$assYear <- as.numeric(retroY) + 1
        rbya$assYear <- as.numeric(retroY) + 1
        rba$assYear <- as.numeric(retroY) + 1
    }
    else {
        rby$assYear <- assYear
        rbya$assYear <- assYear
        rba$assYear <- assYear
    }
    res <- list(rby = rby, rbya = rbya, rba = rba)
    if(exists("aicinfo")) res$aicinfo <- aicinfo
    if(exists("surveytotalpow")){
        names(surveytotalpow) <- fleetnames
        res$surveytotalpow <- surveytotalpow
     }
     if(exists("surveycorr")){
         names(surveycorr) <- fleetnames
         res$surveycorr <- surveycorr
     }
    if(exists("tagloss")){
        res$tagloss <- tagloss
    }
    if(exists("tagmort")){
          res$tagmort <- tagmort
     }
        
    return(res)
}

assbias <- function(retro,n=5) {
  f <- function(x)return(acf(x,plot=F)$acf[2])
  dat1 <- retro %>% filter(assYear==2020) %>% select(year,bio)
  dat <- retro %>% filter(year==assYear) %>% select(year,bio) %>% rename(biocurr=bio) %>% left_join(dat1)
 dat$resid <- log(dat$biocurr/dat$bio)
 dat <- dat[1:(nrow(dat)-n),]
 print(paste("bias",round(mean(dat$resid),3),"acf",round(f(dat$resid),3),"cv",round(sd(dat$resid),3)))
 
 return(invisible(dat))
}


muppet_covar <- function(sigma,rho){
  rho <- rho[1]
  n <- length(sigma)
  x <- diag(sigma^2)
  for(i in 1:n){
    for(j in 1:i){
      x[i,j] <- sigma[i]*sigma[j]*rho^(i-j)
    }
  }
  x <- x + t(x) - diag(sigma^2)
  chol(solve(x))
}

                                        #Example of USE
RUN <- FALSE
if(RUN) {
dir <- "."
ages <- 2:10
years <- 1985:2018
dat <- fishvice::read_separ(dir,".")
rba <- dat$rba[dat$rba$age %in% ages,]
rbya <- dat$rbya[dat$rbya$year %in% years & dat$rbya$age %in% ages,]
tmpcorr <-  0.5613

x <- tapply(rbya$rU1,list(rbya$year,rbya$age),sum)
xx <- muppet_covar(rba$cvU1,tmpcorr)

x1 <-  x %*% t(xx)
rbya$scaledres <- c(t(x1))
}

# Functions to help in retroruns.  

Changepinfile <- function(file="muppet.par",txt = c("# lnRecr:","# lnEffort:"),outputfile="muppet.pin") {
    dat <- scan(file,what=character(),sep="\n",quiet=TRUE)
    for(k in 1:length(txt)){
        j <- grep(txt[k],dat)
        if(length(j) > 0) {
            k1 <- unlist(str_locate_all(dat[j+1]," "))
            dat[j+1]  <- substring(dat[j+1],1,k1[length(k1)]-1)
        }
    }
    write.table(dat,file=outputfile,row.names=FALSE,col.names=FALSE,sep="\n",quote=F)
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
