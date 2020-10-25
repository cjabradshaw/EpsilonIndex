# <i>ε</i>-index

R function to assess the <i>ε</i>-index of a researcher's relative citation performance

Prof Corey J. A. Bradshaw, Flinders University, Adelaide, Australia (October 2020); e-mail: corey.bradshaw@flinders.edu.au; URL: http://globalecologyflinders.com

Existing citation-based indices used to rank research performance do not permit a fair comparison of researchers among career stages or disciplines, nor do they treat women and men equally. We designed the ε-index, which is simple to calculate, based on open-access data, corrects for disciplinary variation, can be adjusted for career breaks, and sets a sample-specific threshold above and below which a researcher is deemed to be performing above or below expectation.

Code accompanies the article:

<strong>BRADSHAW, CJA, JM CHALKER, SA CRABTREE, BA EIJKELKAMP, JA LONG, JR SMITH, K TRINAJSTIC, V WEISBECKER. In review. A fairer way to compare researchers at any career stage and in any discipline using open-access citation data. In review.</strong>

--
<strong>DIRECTIONS</strong>

Load the function ('epsilon.index.func') in R, and import a data.frame from a .csv file exactly the same format as the example file attached ('datasample.csv'):

- <strong>COLUMN 1</strong>: <i>personID</i> — any character identification of an individual researcher (can be a name)
- <strong>COLUMN 2</strong>: <i>gender</i> - researcher's gender ("F" or "M")
- <strong>COLUMN 3</strong>: <i>i10</i> - researcher's i10 index (# papers with ≥ 10 citations); must be > 0
- <strong>COLUMN 4</strong>: <i>h</i> - researcher's <i>h</i>-index
- <strong>COLUMN 5</strong>: <i>maxcit</i> - number of citations of researcher's most cited peer-reviewed paper
- <strong>COLUMN 6</strong>: <i>firstyrpub</i> - the year of the researcher's first published peer-reviewed paper

Simply run the function as follows:

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
