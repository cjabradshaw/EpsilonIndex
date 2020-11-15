AICc <- function(...) {
  models <- list(...)
  numMod <- length(models)
  AICcs <- numeric(numMod)
  ns <- numeric(numMod)
  ks <- numeric(numMod)
  AICcvec <- rep(0,numMod)
  for (i in 1:numMod) {
    if (length(models[[i]]$df.residual) == 0) n <- models[[i]]$dims$N else n <- length(models[[i]]$residuals)
    if (length(models[[i]]$df.residual) == 0) k <- sum(models[[i]]$dims$ncol) else k <- (length(models[[i]]$coeff))+1
    AICcs[i] <- (-2*logLik(models[[i]])) + ((2*k*n)/(n-k-1))
    ns[i] <- n
    ks[i] <- k
    AICcvec[i] <- AICcs[i]
  }
  return(AICcvec)
}
