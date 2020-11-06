############################################################################################
## function to harvest the necessary Google Scholar profile data to run the epsilon index ##
############################################################################################

####################################
## Corey J. A. Bradshaw           ##
## Flinders University, Australia ##
## globalecologyflinders.com      ##
## November 2020                  ##
####################################

install.packages("scholar")
library(scholar)

## To run, first predefine a Google Scholar ids vector (12-character user ID from scholar.google.com):
## e.g., ids <- c("1sO0O3wAAAAJ","ZBUju2QAAAAJ","oGAui-IAAAAJ","cpJnEYIAAAAJ","ptDEg44AAAAJ","PJYrOvQAAAAJ","4UxbBYIAAAAJ")
## and a genders vector of the same length:
## e.g., genders <- c("M","M","F","M","M","F","F") # character vector of researcher gender

## load function
get.profiledat.func <- function(ids.vector, genders.vector) { # 'ids.vector' is the character vector of Google Scholar IDs, and 'genders.vector' is the character vector of researcher gender
  profiles.list <- lapply(ids.vector, get_profile)
  hs <- i10s <- maxcits <- Y1s <- rep(NA,length(ids.vector))
  for (r in 1:length(ids.vector)) {
    hs[r] <- profiles.list[[r]]$h_index
    i10s[r] <- profiles.list[[r]]$i10_index
    maxcits[r] <- get_publications(as.character(profileslist[[r]]$id))$cites[1]
    Y1s[r] <- get_oldest_article(profileslist[[r]]$id)
  }
  input.data <- data.frame(ids.vector, genders.vector, i10s, hs, maxcits, Y1s)
  colnames(input.data) <- c("personID", "gender", "i10", "h", "maxcit","firstyrpub")
  return(input.data)
}

## define an input file that the epsilon.index.func will use:
## e.g., input.data <- get.profiledat.func(ids, genders)
