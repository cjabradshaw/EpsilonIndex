# <i>ε</i>-index

<a target="_blank" href="https://cran.r-project.org">R</a> function to assess the <i>ε</i>-index of a researcher's relative citation performance

Prof Corey J. A. Bradshaw <br>
<a href="http://globalecologyflinders.com" target="_blank">Global Ecology</a>, <a href="http://flinders.edu.au" target="_blank">Flinders University</a>, Adelaide, Australia <br>
October 2020 <br>
<a href=mailto:corey.bradshaw@flinders.edu.au>e-mail</a> <br>

Existing citation-based indices used to rank research performance do not permit a fair comparison of researchers among career stages or disciplines, nor do they treat women and men equally. We designed the ε-index, which is simple to calculate, based on open-access data, corrects for disciplinary variation, can be adjusted for career breaks, and sets a sample-specific threshold above and below which a researcher is deemed to be performing above or below expectation.

Code accompanies the article:

<strong><a href="https://globalecologyflinders.com/people/#CJAB" target="_blank">BRADSHAW, CJA</a>, <a href="https://www.chalkerlab.com/jmc" target="_blank">JM CHALKER</a>, <a href="https://stefanicrabtree.com/about-stefani/" target="_blank">SA CRABTREE</a>, <a href="https://researchnow.flinders.edu.au/en/persons/bart-eijkelkamp" target="_blank">BA EIJKELKAMP</a>, <a href="https://en.wikipedia.org/wiki/John_A._Long" target="_blank">JA LONG</a>, <a href="https://www.flinders.edu.au/people/justine.smith" target="_blank">JR SMITH</a>, <a href="https://staffportal.curtin.edu.au/staff/profile/view/K.Trinajstic/" target="_blank">K TRINAJSTIC</a>, <a href="https://researchnow.flinders.edu.au/en/persons/vera-weisbecker" target="_blank">V WEISBECKER</a>. In review. A fairer way to compare researchers at any career stage and in any discipline using open-access citation data. In review.</strong>

-- <br>
<strong>DIRECTIONS</strong>

Load the function ('epsilon.index.func') in R, and import a data.frame from a <a href="https://en.wikipedia.org/wiki/Comma-separated_values">.csv</a> file exactly the same format as the example file in this repository ('datasample.csv'):

- <strong>COLUMN 1</strong>: <i>personID</i> — any character identification of an individual researcher (can be a name)
- <strong>COLUMN 2</strong>: <i>gender</i> - researcher's gender ("F" or "M")
- <strong>COLUMN 3</strong>: <i>i10</i> - researcher's i10 index (# papers with ≥ 10 citations); must be > 0
- <strong>COLUMN 4</strong>: <i>h</i> - researcher's <i>h</i>-index
- <strong>COLUMN 5</strong>: <i>maxcit</i> - number of citations of researcher's most cited peer-reviewed paper
- <strong>COLUMN 6</strong>: <i>firstyrpub</i> - the year of the researcher's first published peer-reviewed paper

First, import the sample .csv file (or your own following the format indicated above):

    example.dat <- read.csv("datasample.csv", header=T) 

Then simply run the function as follows:

    epsilon.index.func(dat.samp=example.dat)

The output file includes the following columns:

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
