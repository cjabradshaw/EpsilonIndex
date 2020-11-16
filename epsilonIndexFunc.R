epsilonIndexFunc <- function(datsamp, bygender='no', sortindex='e') {
  
  ## transforms
  datsamp[,2] <- as.character(datsamp[,2])
  datsamp[,1] <- as.character(datsamp[,1])
  ye <- as.numeric(format(Sys.Date(), "%Y")) - datsamp[,6]
  lc10 <- ifelse(datsamp[,3]==0, 0, log(datsamp[,3]))
  lch <- log(datsamp[,4])
  lcmax <- rep(log(1), length(lch))
  li10 <- rep(log(10), length(lch))
  lih <- log(datsamp[,4])
  limax <- log(datsamp[,5])
  mi <- round(datsamp[,4]/ye,4)
  
  ## power-law relationship
  lis.out <- lcs.out <- pers.out <- rep(NA,1)
  xypts.out <- matrix(NA,nrow=2, ncol=2)
  av <- bv <- NA
  for (p in 1:dim(datsamp)[1]) {
    lis <- as.numeric(c(li10[p],lih[p],limax[p]))
    lis.out <- c(lis.out, lis)
    lcs <- as.numeric(c(lc10[p],lch[p],lcmax[p]))
    lcs.out <- c(lcs.out, lcs)
    pers <- rep(datsamp[p, 4],3)
    pers.out <- c(pers.out,pers)
    fitp <- lm(lcs ~ lis)
    av[p] <- coef(fitp)[1]
    bv[p] <- coef(fitp)[2]
    ystart.pt <- av[p] + bv[p]
    yend.pt <- 0
    xpts <- c(1,lis[3])
    ypts <- c(ystart.pt, yend.pt)
    xypts <- cbind(xpts,ypts)
    colnames(xypts) <- c(paste(pers[1],"x",sep=""), paste(pers[1],"y",sep=""))
    xypts.out <- cbind(xypts.out, xypts)
  }

  ## area under the curve
  Alin <- NA
  for (q in 1:dim(datsamp)[1]) {
    if (limax[q] > 1) {
      li.cont <- seq(1, limax[q], 0.05)
      pred.lin <- av[q] + bv[q]*(li.cont)
      Alin[q] <- sum(pred.lin)/(length(li.cont)*(max(limax)))}
    if (limax[q] < 1) {
      Alin[q] <- 0}
  }

  # normalise
  AlinP <- scale(Alin, scale=T, center=F)
  
  ## residual ranking
  fit.yAlin <- lm(Alin ~ log(ye))
  if (coef(fit.yAlin)[2] < 0)  {
    fit.yAlin <- lm(Alin ~ 0 + log(ye))
  }
  
  fit.yAlinP <- lm(AlinP ~ log(ye))
  if (coef(fit.yAlinP)[2] < 0)  {
    fit.yAlinP <- lm(AlinP ~ 0 + log(ye))
  }
  
  ## calculate expectation relative to sample
  expectation <- as.character(ifelse(resid(fit.yAlin) > 0, "above", "below"))
  dat.out <- data.frame(datsamp[,1], datsamp[,2], ye, Alin, resid(fit.yAlin), resid(fit.yAlinP), expectation, mi, datsamp[,4])
  dat.sort1 <- dat.out[order(dat.out[,5],decreasing=T),]
  Rnk <- seq(1,length(datsamp[,1]),1)
  dat.sort <- data.frame(dat.sort1,Rnk)
  colnames(dat.sort) <- c("ID","gen","yrsP","cM","e","eP","exp","m","h","Rnk")
  dat.sort[,1] <- as.character(dat.sort[,1])
  dat.sort[,2] <- as.character(dat.sort[,2])
  dat.sort[,7] <- as.character(dat.sort[,7])

  if (bygender == "yes") {
    ## gender-debiased ε-index 
    # women
    dat.comb <- data.frame(datsamp,ye,lc10,lch,lcmax,li10,lih,limax,mi,av,bv,Alin)
    colnames(dat.comb)[1:6] <- c("ID","gen","i10","h","maxcit","firstyrpub")
    datsampF <- subset(dat.comb, gen=="F")
    fitF.yAlin <- lm(datsampF[,17] ~ log(datsampF[,7]))
    
    # normalise
    fitF.yAlinP <- lm(scale(datsampF[,17], scale=T, center=F) ~ log(datsampF[,7]))
    
    if (coef(fitF.yAlin)[2] < 0)  {
      fitF.yAlin <- lm(datsampF[,17] ~ 0 + log(datsampF[,7]))
    }
    
    if (coef(fitF.yAlinP)[2] < 0)  {
      fitF.yAlinP <- lm(scale(datsampF[,17], scale=T, center=F) ~ 0 + log(datsampF[,7]))
    }
  
    ## calculate expectation relative to sample
    expectationF <- as.character(ifelse(resid(fitF.yAlin) > 0, "above", "below"))
    datF.out <- data.frame(datsampF[,1], datsampF[,2], datsampF[,7], round(scale(datsampF[,17], scale=T, center=F),4), round(resid(fitF.yAlin),4), expectationF, datsampF[,14], datsampF[,4], round(resid(fitF.yAlinP),4))
    datF.sort1 <- datF.out[order(datF.out[,5],decreasing=T), ]
    rankF <- seq(1,length(datsampF[,1]),1)
    datF.sort <- data.frame(datF.sort1,rankF)
    colnames(datF.sort) <- c("ID","gen","yrsP","cMs","e","exp","m","h","debEP","genRnk")
    datF.sort[,1] <- as.character(datF.sort[,1])
    datF.sort[,2] <- as.character(datF.sort[,2])
    datF.sort[,6] <- as.character(datF.sort[,6])
    
    # men
    datsampM <- subset(dat.comb, gen=="M")
    fitM.yAlin <- lm(datsampM[,17] ~ log(datsampM[,7]))
    
    # normalise
    fitM.yAlinP <- lm(scale(datsampM[,17], scale=T, center=F) ~ log(datsampM[,7]))
    
    if (coef(fitM.yAlin)[2] < 0)  {
      fitM.yAlin <- lm(datsampM[,17] ~ 0 + log(datsampM[,7]))
    }
    
    if (coef(fitM.yAlinP)[2] < 0)  {
      fitM.yAlinP <- lm(scale(datsampM[,17], scale=T, center=F) ~ 0 + log(datsampM[,7]))
    }
    
    ## calculate expectation relative to sample
    expectationM <- as.character(ifelse(resid(fitM.yAlin) > 0, "above", "below"))
    datM.out <- data.frame(datsampM[,1], datsampM[,2], datsampM[,7], round(scale(datsampM[,17], scale=T, center=F),4), round(resid(fitM.yAlin),4), expectationM, datsampM[,14], datsampM[,4], round(resid(fitM.yAlinP),4))
    datM.sort1 <- datM.out[order(datM.out[,5],decreasing=T), ]
    rankM <- seq(1,length(datsampM[,1]),1)
    datM.sort <- data.frame(datM.sort1,rankM)
    colnames(datM.sort) <- c("ID","gen","yrsP","cMs","e","exp","m","h","debEP","genRnk")
    datM.sort[,1] <- as.character(datM.sort[,1])
    datM.sort[,2] <- as.character(datM.sort[,2])
    datM.sort[,6] <- as.character(datM.sort[,6])
    
    # combine women & men subsets & re-rank
    datFM <- rbind(datF.sort,datM.sort)
    datFM.sort1 <- datFM[order(datFM[,5],decreasing=T), ]
    debRnk <- seq(1,length(datFM.sort1[,1]),1)
    datFM.sort <- data.frame(datFM.sort1,debRnk)
    #colnames(datFM.sort)[1:10] <- colnames(datFM)
    colnames(datFM.sort)[5] <- "genE"
    datFM.sort[,5] <- round(datFM.sort[,5],4)
    
    # add rank from pooled sample
    orig.rank <- dat.sort[, c(1,4,5,6,10)]
    datFM.mrg <- merge(datFM.sort, orig.rank, by="ID", all=F, no.dups=T)
    colnames(datFM.mrg)[13] <- "poolE"
    datFM.mrg[,13] <- round(datFM.mrg[,13], 4)
    datFM.mrg[,14] <- round(as.numeric(datFM.mrg[,14]), 4)
    datFM.mrg[,12] <- round(datFM.mrg[,12], 4)
    colnames(datFM.mrg)[15] <- "poolRnk"
    full.out1 <- datFM.mrg[order(datFM.mrg[,11],decreasing=F), ]  
    
    # sort on desired metric & recalculate expectation based on sort metric
    # 'e' = pooled; 'ep' = normalised; 'd' = gender-debiased; 'dp' = normalised gender-debiased 
    if (sortindex == 'd') {
      sortout <- full.out1[order(full.out1[,11],decreasing=F), 1:15]}
    if (sortindex == 'e') {
      sortout <- full.out1[order(full.out1[,15],decreasing=F), 1:15]
      sortout[,6] <- as.character(ifelse(sortout[,13] > 0, 'above', 'below'))}
    if (sortindex == 'ep') {
      sortout1 <- full.out1[order(full.out1[,14],decreasing=T), 1:15]
      sortout1[,6] <- ifelse(sortout1[,14] > 0, 'above', 'below')
      ePRnk <- seq(1,dim(sortout1)[1], by=1)
      sortout <- data.frame(sortout1,ePRnk)}
    if (sortindex == 'dp') {
      sortout1 <- full.out1[order(full.out1[,9],decreasing=T), 1:15]
      sortout1[,6] <- ifelse(sortout1[,9] > 0, 'above', 'below')
      ePdebRnk <- seq(1,dim(sortout1)[1], by=1)
      sortout <- data.frame(sortout1,ePdebRnk)}
  } # end bygender = yes if statement

  if (bygender == "no") {
    full.out <- dat.sort
    full.out[,4] <- round(full.out[,4], 4)
    full.out[,5] <- round(full.out[,5], 4)
    full.out[,6] <- round(as.numeric(full.out[,6]), 4)
    colnames(full.out)[5] <- "poolE"
    colnames(full.out)[10] <- "poolRnk"
    sortout <- full.out
  } # end bygender = no if statement
  
  # print final output
  return(sortout)
  
} # end epsilonIndexFunc
