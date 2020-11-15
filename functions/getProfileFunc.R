getProfileFunc <- function(gsdata) {
  profileslist <- lapply(gsdata[,1], get_profile)
  hs <- i10s <- maxcits <- Y1s <- rep(NA,dim(gsdata)[1])
  for (r in 1:(dim(gsdata)[1])) {
    hs[r] <- profileslist[[r]]$h_index
    i10s[r] <- profileslist[[r]]$i10_index
    maxcits[r] <- get_publications(profileslist[[r]])[1,5]
    Y1s[r] <- get_oldest_article(profileslist[[r]])
  }
  inputdata <- data.frame(gsdata[,1], gsdata[,2], i10s, hs, maxcits, Y1s)
  colnames(inputdata) <- c("personID", "gender", "i10", "h", "maxcit","firstyrpub")
  return(inputdata)
}
