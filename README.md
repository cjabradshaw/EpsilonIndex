# EpsilonIndex
R function to assess the ε-index of a researcher's relative citation performance

Prof Corey J. A. Bradshaw, Flinders University, Adelaide, Australia (October 2020)
e-mail: corey.bradshaw@flinders.edu.au

Existing citation-based indices used to rank research performance do not permit a fair comparison of researchers among career stages or disciplines, nor do they treat women and men equally. We designed the ε-index, which is simple to calculate, based on open-access data, corrects for disciplinary variation, can be adjusted for career breaks, and sets a sample-specific threshold above and below which a researcher is deemed to be performing above or below expectation.

Code accompanies the article:

BRADSHAW, CJA, JM CHALKER, SA CRABTREE, B EIJKELKAMP, JA LONG, JR SMITH, K TRINAJSTIC, V WEISBECKER. In review. A fairer way to compare researchers at any career stage and in any discipline using open-access citation data. In review.

DIRECTIONS

Load the function ('epsilon.index.func') in R, and import a data.frame from a .csv file exactly the same format as the example file attached ('datasample.csv'):

- COLUMN 1: 'personID' — any character identification of an individual researcher (can be a name)
- COLUMN 2: 'gender' - researcher's gender ("F" or "M")
- COLUMN 3: 'i10' - researcher's i10 index (# papers with ≥ 10 citations); must be > 0
- COLUMN 4: 'h' - researcher's h-index
- COLUMN 5: 'maxcit' - number of citations of researcher's peer-reviewed paper with most citations
- COLUMN 6: 'firstyrpub' - the year of the researcher's first published peer-reviewed paper

Simply run the function as follows:

    epsilon.index.func(dat.samp=example.dat)

The output file includes the following columns:

- person: researcher's ID (specified by user)
- gender: F=female; M=male
- yrs.publ: number of years since first peer-reviewed article
- gender.ε-index: ε-index relative to others of the same gender in the sample
- expectation: whether above or below expectation relative to others of the same gender
- m-quotient: h-index ÷ yrs.publ
- h-index: h-index
- gender.rank: rank from gender.ε-index (1 = highest)
- rnk.debiased: gender-debiased rank (1 = highest)
- pooled.ε-index: ε-index generated from the entire sample (not gender-specific)
- pooled.rnk: rank from pooled.ε-index (1 = highest)
- ε′-index: scaled ε-index
- debiased.ε′-index: scaled gender.ε-index
