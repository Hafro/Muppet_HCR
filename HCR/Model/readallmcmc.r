readallmcmc <- function(file){
    years <- scan(file,skip=1,nlines=1)
    nyrs <- length(years)
    ages <- scan(file,skip=3,nlines=1)
    nages <- length(ages) 
    variables <- scan(file,skip=5,nlines=1) #.  1 N etc
    names(variables) <- c("n","cw","sw","mat","f","cno")
    n1 <- length(variables[variables==1])
    print(paste("n1",n1))
    nvar <- 1:length(variables)
    nvar <- nvar[variables==1]
    dat <- read.table(file,skip=8,header=F)
    niter <- nrow(dat)/(nyrs*n1)
    iter <- 1:niter
    result <- expand.grid(list(year=years,variable=nvar,iter=iter,age=ages))
    result$value <- c(unlist(dat))
    return(result)
}
