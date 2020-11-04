######################
## ε-index function ##
######################

####################################
## Corey J. A. Bradshaw           ##
## Flinders University, Australia ##
## globalecologyflinders.com      ##
## October 2020                   ##
####################################

# 'dat.samp' is the sample data.frame loaded from a .csv file (format specified after function)
# 'sort.out' is a sorting option for the final results table based on desired index (default = 'e')
    # possible values: 'e' = pooled; 'ep' = normalised; 'd' = gender-debiased; 'dp' = normalised gender-debiased
    # If there are insufficient individuals per gender to estimate a gender-specific index, we recommmend not using
    # or sorting based on the gender-debiased index (option 'd')
    # If the individuals in the sample are not all in the same approximate discipline, we recommend not using
    # or sorting based on either of the two normalised indices (options 'ep' or 'dp')

epsilon.index.func <- function(dat.samp, sort.index='e') { 
  
  ## set internal functions
  AICc <- function(...) {
    models <- list(...)
    num.mod <- length(models)
    AICcs <- numeric(num.mod)
    ns <- numeric(num.mod)
    ks <- numeric(num.mod)
    AICc.vec <- rep(0,num.mod)
    for (i in 1:num.mod) {
      if (length(models[[i]]$df.residual) == 0) n <- models[[i]]$dims$N else n <- length(models[[i]]$residuals)
      if (length(models[[i]]$df.residual) == 0) k <- sum(models[[i]]$dims$ncol) else k <- (length(models[[i]]$coeff))+1
      AICcs[i] <- (-2*logLik(models[[i]])) + ((2*k*n)/(n-k-1))
      ns[i] <- n
      ks[i] <- k
      AICc.vec[i] <- AICcs[i]
    }
    return(AICc.vec)
  }
  
  delta.AIC <- function(x) x - min(x) ## where x is a vector of AIC
  weight.AIC <- function(x) (exp(-0.5*x))/sum(exp(-0.5*x)) ## Where x is a vector of dAIC
  ch.dev <- function(x) ((( as.numeric(x$null.deviance) - as.numeric(x$deviance) )/ as.numeric(x$null.deviance))*100) ## % change in deviance, where x is glm object
  
  linreg.ER <- function(x,y) { # where x and y are vectors of the same length; calls AICc, delta.AIC, weight.AIC functions
    fit.full <- lm(y ~ x); fit.null <- lm(y ~ 1)
    AIC.vec <- c(AICc(fit.full),AICc(fit.null))
    dAIC.vec <- delta.AIC(AIC.vec); wAIC.vec <- weight.AIC(dAIC.vec)
    ER <- wAIC.vec[1]/wAIC.vec[2]
    r.sq.adj <- as.numeric(summary(fit.full)[9])
    return(c(ER,r.sq.adj))
  }
  
  ## transforms
  dat.samp$gender <- as.character(dat.samp$gender)
  dat.samp$personID <- as.character(dat.samp$personID)
  dat.samp$y.e <- as.numeric(format(Sys.Date(), "%Y")) - dat.samp$firstyrpub
  dat.samp$lc10 <- ifelse(dat.samp$i10==0, 0, log(dat.samp$i10))
  dat.samp$lch <- log(dat.samp$h)
  dat.samp$lcmax <- log(1)
  dat.samp$li10 <- log(10)
  dat.samp$lih <- log(dat.samp$h)
  dat.samp$limax <- log(dat.samp$maxcit)
  dat.samp$mi <- dat.samp$h/dat.samp$y.e
  
  ## power-law relationship
  plot(as.numeric(dat.samp[1,12:14]), as.numeric(dat.samp[1,9:11]), lty=2, xlim=c(1,max(dat.samp$limax)), ylim=c(0,max(dat.samp$lc10)), col="white", xlab="log index", ylab="log frequency")
  
  lis.out <- lcs.out <- pers.out <- rep(NA,1)
  xypts.out <- matrix(NA,nrow=2, ncol=2)
  dat.samp$a <- dat.samp$b <- NA
  for (p in 1:dim(dat.samp)[1]) {
    lis <- as.numeric(dat.samp[p, 12:14])
    lis.out <- c(lis.out, lis)
    lcs <- as.numeric(dat.samp[p, 9:11])
    lcs.out <- c(lcs.out, lcs)
    pers <- rep(dat.samp[p, 4],3)
    pers.out <- c(pers.out,pers)
    fitp <- lm(lcs ~ lis)
    dat.samp$a[p] <- coef(fitp)[1]
    dat.samp$b[p] <- coef(fitp)[2]
    ystart.pt <- dat.samp$a[p] + dat.samp$b[p]
    yend.pt <- 0
    xpts <- c(1,lis[3])
    ypts <- c(ystart.pt, yend.pt)
    xypts <- cbind(xpts,ypts)
    colnames(xypts) <- c(paste(pers[1],"x",sep=""), paste(pers[1],"y",sep=""))
    xypts.out <- cbind(xypts.out, xypts)
    points(lis,lcs,pch=3,cex=0.5, col="black")
    abline(fitp, lty=2, col="grey")
  }

  ## area under the curve
  dat.samp$Alin <- NA
  for (q in 1:dim(dat.samp)[1]) {
    if (dat.samp$limax[q] > 1) {
      li.cont <- seq(1, dat.samp$limax[q], 0.05)
      pred.lin <- dat.samp$a[q] + dat.samp$b[q]*(li.cont)
      dat.samp$Alin[q] <- sum(pred.lin)/(length(li.cont)*(max(dat.samp$limax)))}
    if (dat.samp$limax[q] < 1) {
      dat.samp$Alin[q] <- 0}
  }

  ## residual ranking
  plot(log(dat.samp$y.e), dat.samp$Alin, pch=19, xlab="log years since 1st publication", ylab="Arel", ylim=c(min((dat.samp$Alin)),max((dat.samp$Alin))), xlim=c(min(log(dat.samp$y.e)),max(log(dat.samp$y.e))))
  fit.yAlin <- lm(dat.samp$Alin ~ log(dat.samp$y.e))
  if (coef(fit.yAlin)[2] < 0)  {
    fit.yAlin <- lm(dat.samp$Alin ~ 0 + log(dat.samp$y.e))
  }
  abline(fit.yAlin, lty=2, col="red")
  summary(fit.yAlin)
  #print(paste("AIC evidence ratio = ", round(linreg.ER(log(dat.samp$y.e), dat.samp$Alin)[1], 2), sep=""))
  #print(paste("Radj = ", round(linreg.ER(log(dat.samp$y.e), dat.samp$Alin)[2], 2), sep=""))
  
  ## calculate expectation relative to sample
  expectation <- as.character(ifelse(resid(fit.yAlin) > 0, "above", "below"))
  dat.out <- data.frame(dat.samp$personID, dat.samp$gender, dat.samp$y.e, resid(fit.yAlin), expectation, dat.samp$mi, dat.samp$h)
  dat.sort <- dat.out[order(dat.out[,4],decreasing=T),1:7]
  dat.sort$rank <- seq(1,length(dat.samp$personID),1)
  colnames(dat.sort) <- c("person","gender","yrs.publ", "eindex","expectation","m-quotient","h-index", "rank")
  dat.sort$person <- as.character(dat.sort$person)
  dat.sort$gender <- as.character(dat.sort$gender)
  dat.sort$expectation <- as.character(dat.sort$expectation)

  ## gender-debiased ε-index 
  # women
  dat.sampF <- subset(dat.samp, gender=="F")
  plot(log(dat.sampF$y.e), dat.sampF$Alin, pch=19, xlab="log years since 1st publication", ylab="Arel", ylim=c(min((dat.sampF$Alin)),max((dat.sampF$Alin))), xlim=c(min(log(dat.sampF$y.e)),max(log(dat.sampF$y.e))))
  fitF.yAlin <- lm(dat.sampF$Alin ~ log(dat.sampF$y.e))
  if (coef(fitF.yAlin)[2] < 0)  {
    fitF.yAlin <- lm(dat.sampF$Alin ~ 0 + log(dat.sampF$y.e))
  }
  abline(fitF.yAlin, lty=2, col="red")
  summary(fitF.yAlin)
  #print(paste("AIC evidence ratio = ", round(linreg.ER(log(dat.sampF$y.e), dat.sampF$Alin)[1], 2), sep=""))
  #print(paste("Radj = ", round(linreg.ER(log(dat.sampF$y.e), dat.sampF$Alin)[2], 2), sep=""))
  
  ## calculate expectation relative to sample
  expectationF <- as.character(ifelse(resid(fitF.yAlin) > 0, "above", "below"))
  datF.out <- data.frame(dat.sampF$personID, dat.sampF$gender, dat.sampF$y.e, resid(fitF.yAlin), expectationF, dat.sampF$mi, dat.sampF$h)
  datF.sort <- datF.out[order(datF.out[,4],decreasing=T),1:7]
  datF.sort$rankF <- seq(1,length(dat.sampF$personID),1)
  colnames(datF.sort) <- c("person","gender","yrs.publ", "eindex","expectation","m-quotient","h-index", "gender.rank")
  datF.sort$person <- as.character(datF.sort$person)
  datF.sort$gender <- as.character(datF.sort$gender)
  datF.sort$expectation <- as.character(datF.sort$expectation)
  
  # men
  dat.sampM <- subset(dat.samp, gender=="M")
  plot(log(dat.sampM$y.e), dat.sampM$Alin, pch=19, xlab="log years since 1st publication", ylab="Arel", ylim=c(min((dat.sampM$Alin)),max((dat.sampM$Alin))), xlim=c(min(log(dat.sampM$y.e)),max(log(dat.sampM$y.e))))
  fitM.yAlin <- lm(dat.sampM$Alin ~ log(dat.sampM$y.e))
  if (coef(fitM.yAlin)[2] < 0)  {
    fitM.yAlin <- lm(dat.sampM$Alin ~ 0 + log(dat.sampM$y.e))
  }
  abline(fitM.yAlin, lty=2, col="red")
  summary(fitM.yAlin)
  #print(paste("AIC evidence ratio = ", round(linreg.ER(log(dat.sampM$y.e), dat.sampM$Alin)[1], 2), sep=""))
  #print(paste("Radj = ", round(linreg.ER(log(dat.sampM$y.e), dat.sampM$Alin)[2], 2), sep=""))
  
  ## calculate expectation relative to sample
  expectationM <- as.character(ifelse(resid(fitM.yAlin) > 0, "above", "below"))
  datM.out <- data.frame(dat.sampM$personID, dat.sampM$gender, dat.sampM$y.e, resid(fitM.yAlin), expectationM, dat.sampM$mi, dat.sampM$h)
  datM.sort <- datM.out[order(datM.out[,4],decreasing=T),1:7]
  datM.sort$rankF <- seq(1,length(dat.sampM$personID),1)
  colnames(datM.sort) <- c("person","gender","yrs.publ", "eindex","expectation","m-quotient","h-index", "gender.rank")
  datM.sort$person <- as.character(datM.sort$person)
  datM.sort$gender <- as.character(datM.sort$gender)
  datM.sort$expectation <- as.character(datM.sort$expectation)
  
  # combine women & men subsets & re-rank
  datFM <- rbind(datF.sort,datM.sort)
  datFM.sort <- datFM[order(datFM[,4],decreasing=T),1:8]
  datFM.sort$rnk.debiased <- seq(1,length(datFM.sort$person),1)
  colnames(datFM.sort)[4] <- "gender.eindex"
  
  # add rank from pooled sample
  orig.rank <- dat.sort[,c(1,4,8)]
  datFM.mrg <- merge(datFM.sort, orig.rank, by="person", all=F, no.dups=T)
  colnames(datFM.mrg)[10] <- "pooled.eindex"
  colnames(datFM.mrg)[11] <- "pooled.rnk"
  full.out <- datFM.mrg[order(datFM.mrg[,9],decreasing=F), 1:11]  
  
  plot(full.out$pooled.rnk, full.out$rnk.debiased, xlab="pooled rank", ylab="debiased rank", pch=NULL, cex=0.7, col="white")
  origdebias.fit <- lm(full.out$rnk.debiased~full.out$pooled.rnk)
  points(full.out[which(full.out$gender=="M"),11], full.out[which(full.out$gender=="M"),9], col="red", pch="M", cex=0.7)
  points(full.out[which(full.out$gender=="F"),11], full.out[which(full.out$gender=="F"),9], col="black", pch="F", cex=0.7)
  abline(origdebias.fit, lty=2, col="red")
  
  ## scale (normalise)
  full.out$e.prime.index <- scale(full.out$pooled.eindex, scale=T, center=F)
  full.out$debiased.e.prime.index <- scale(full.out$gender.eindex, scale=T, center=F)
  
  # sort on desired metric & recalculate expectation based on sort metric
  # 'e' = pooled; 'ep' = normalised; 'd' = gender-debiased; 'dp' = normalised gender-debiased 
  if (sort.index == 'd') {
    sort.out <- full.out[order(full.out[,9],decreasing=F), 1:13]}
  if (sort.index == 'e') {
    sort.out <- full.out[order(full.out[,10],decreasing=T), 1:13]
    sort.out$expectation <- as.character(ifelse(sort.out[,10] > 0, 'above', 'below'))}
  if (sort.index == 'ep') {
    sort.out <- full.out[order(full.out[,12],decreasing=T), 1:13]
    sort.out$expectation <- ifelse(sort.out[,12] > 0, 'above', 'below')
    sort.out$eprime.rnk <- seq(1,dim(sort.out)[1], by=1)}
  if (sort.index == 'dp') {
    sort.out <- full.out[order(full.out[,13],decreasing=T), 1:13]
    sort.out$expectation <- ifelse(sort.out[,13] > 0, 'above', 'below')
    sort.out$eprime.debiased.rnk <- seq(1,dim(sort.out)[1], by=1)}
  
  # print final output
  return(sort.out)
  
} # end epsilon.index.func


## import data
## data should be in the following format:
## .csv file (comma-delimited)
## COLUMN 1: 'personID' - any character identification of an individual researcher (can be a name)
## COLUMN 2: 'gender' - researcher's gender ("F" or "M")
## COLUMN 3: 'i10' - researcher's i10 index (# papers with ≥ 10 citations); must be > 0
## COLUMN 4: 'h' - researcher's h-index
## COLUMN 5: 'maxcit' - number of citations of researcher's most cited peer-reviewed paper
## COLUMN 6: 'firstyrpub' - the year of the researcher's first published peer-reviewed paper

example.dat <- read.csv("datasample.csv", header=T) # .csv file of data for researcher sample

## apply function
epsilon.index.func(dat.samp=example.dat)

# The output file includes the following columns:
# person: researcher's ID (specified by user)
# gender: F=female; M=male
# yrs.publ: number of years since first peer-reviewed article
# gender.eindex: ε-index relative to others of the same gender in the sample
# expectation: whether above or below expectation relative to others of the same gender
# m-quotient: h-index ÷ yrs.publ
# h-index: h-index
# gender.rank: rank from gender.ε-index (1 = highest)
# rnk.debiased: gender-debiased rank (1 = highest)
# pooled.eindex: ε-index generated from the entire sample (not gender-specific)
# pooled.rnk: rank from pooled.ε-index (1 = highest)
# e.prime.index: scaled ε-index (ε′-index)
# debiased.e.prime.index: scaled gender.ε-index (gender ε′-index)
