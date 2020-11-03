# <i>ε</i>-index

<a target="_blank" href="https://cran.r-project.org">R</a> function to calculate the <i>ε</i>-index of a researcher's relative citation performance

Prof Corey J. A. Bradshaw <br>
<a href="http://globalecologyflinders.com" target="_blank">Global Ecology</a>, <a href="http://flinders.edu.au" target="_blank">Flinders University</a>, Adelaide, Australia <br>
October 2020 <br>
<a href=mailto:corey.bradshaw@flinders.edu.au>e-mail</a> <br>

Existing citation-based indices used to rank research performance do not permit a fair comparison of researchers among career stages or disciplines, nor do they treat women and men equally. We designed the ε-index, which is simple to calculate, based on open-access data, corrects for disciplinary variation, can be adjusted for career breaks, and sets a sample-specific threshold above and below which a researcher is deemed to be performing above or below expectation.

Code accompanies the article:

<strong><a href="https://globalecologyflinders.com/people/#CJAB" target="_blank">BRADSHAW, CJA</a>, <a href="https://www.chalkerlab.com/jmc" target="_blank">JM CHALKER</a>, <a href="https://stefanicrabtree.com/about-stefani/" target="_blank">SA CRABTREE</a>, <a href="https://researchnow.flinders.edu.au/en/persons/bart-eijkelkamp" target="_blank">BA EIJKELKAMP</a>, <a href="https://en.wikipedia.org/wiki/John_A._Long" target="_blank">JA LONG</a>, <a href="https://www.flinders.edu.au/people/justine.smith" target="_blank">JR SMITH</a>, <a href="https://staffportal.curtin.edu.au/staff/profile/view/K.Trinajstic/" target="_blank">K TRINAJSTIC</a>, <a href="https://researchnow.flinders.edu.au/en/persons/vera-weisbecker" target="_blank">V WEISBECKER</a>. 2020. A fairer way to compare researchers at any career stage and in any discipline using open-access citation data. <i><strong>Authorea</strong></i> pre-print <a href="https://doi.org/10.22541/au.160373218.83526843/v1">DOI:10.22541/au.160373218.83526843/v1</a> (in review elsewhere).</strong>

-- <br>
<strong>DIRECTIONS</strong>

1. Create a <a href="https://en.wikipedia.org/wiki/Comma-separated_values">.csv</a> file of <strong>exactly the same format</strong> as the example file in this repository ('<a href="https://github.com/cjabradshaw/EpsilonIndex/blob/main/datasample.csv">datasample.csv</a>'):

 - <strong>COLUMN 1</strong>: <i>personID</i> — any character identification of an individual researcher (can be a name)
 - <strong>COLUMN 2</strong>: <i>gender</i> — researcher's gender ("F" or "M")
 - <strong>COLUMN 3</strong>: <i>i10</i> — researcher's i10 index (# papers with ≥ 10 citations); <strong>must be > 0</strong>
 - <strong>COLUMN 4</strong>: <i>h</i> — researcher's <i>h</i>-index
 - <strong>COLUMN 5</strong>: <i>maxcit</i> — number of citations of researcher's most cited peer-reviewed paper
 - <strong>COLUMN 6</strong>: <i>firstyrpub</i> — the year of the researcher's first published peer-reviewed paper

2. Import the sample .csv file, or your own following the format indicated above (make sure first to specify the directory in which 'datasample.csv' resides using the 'setwd()' command):
  
        setwd("/path") # where /path is the directory path on your machine
        example.dat <- read.csv("datasample.csv", header=T) 

3. Alternatively, you can automatically harvest the necessary citation data from Google Scholar using the 'get.profile.func.R' function, which produces a file that can be called directly by the 'epsilon.index.func.R':

  i. Predefine a Google Scholar ids vector (12-character user ID from scholar.google.com), e.g.,
 
        ids <- c("1sO0O3wAAAAJ","ZBUju2QAAAAJ","oGAui-IAAAAJ","cpJnEYIAAAAJ","ptDEg44AAAAJ","PJYrOvQAAAAJ","4UxbBYIAAAAJ") 

  ii. Then define a 'genders' vector of the same length, e.g.,
  
        genders <- c("M","M","F","M","M","F","F") # character vector of researcher gender

  iii. Load get.profile.func
  
  iv. Define an input file that the epsilon.index.func will use, e.g.,

        example.dat <- get.profiledat.func(ids, genders)

4. Load the function ('epsilon.index.func') in R by submitting the entire function code (<a href="https://github.com/cjabradshaw/EpsilonIndex/blob/main/epsilon.index.R">lines 12 to 196</a>) to the R console.

5. Simply run the function as follows:

        epsilon.index.func(dat.samp=example.dat)

The output includes the following columns:

- <i>person</i>: researcher's ID (specified by user)
- <i>gender</i>: F=female; M=male
- <i>yrs.publ</i>: number of years since first peer-reviewed article
- <i>gender.eindex</i>: <i>ε</i>-index relative to others of the same gender in the sample
- <i>expectation</i>: whether above or below expectation relative to others of the same gender
- <i>m-quotient</i>: <i>h</i>-index ÷ yrs.publ
- <i>h-index</i>: <i>h</i>-index
- <i>gender.rank</i>: rank from gender.eindex (1 = highest)
- <i>rnk.debiased</i>: gender-debiased rank (1 = highest)
- <i>pooled.eindex</i>: <i>ε</i>-index generated from the entire sample (not gender-specific)
- <i>pooled.rnk</i>: rank from pooled.eindex (1 = highest)
- <i>e.prime.index</i>: scaled pooled.eindex (<i>ε</i>′-index)
- <i>debiased.e.prime.index</i>: scaled gender.eindex (gender <i>ε</i>′-index)

5. You can easily export the output to a file like this:

        out <- epsilon.index.func(dat.samp=example.dat)
        write.table(out,file="rank.output.csv",sep=",",dec = ".", row.names = F,col.names = TRUE)


