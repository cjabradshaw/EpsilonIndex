linregER <- function(x,y) { # where x and y are vectors of the same length; calls AICc, delta.AIC, weight.AIC functions
  fitFull <- lm(y ~ x); fitNull <- lm(y ~ 1)
  AICvec <- c(AICc(fitFull),AICc(fitNull))
  dAICvec <- deltaIC(AICvec); wAICvec <- weightIC(dAICvec)
  ER <- wAICvec[1]/wAICvec[2]
  rSqAdj <- as.numeric(summary(fitFull)[9])
  return(c(ER,rSqAdj))
}
