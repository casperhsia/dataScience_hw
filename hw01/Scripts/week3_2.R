#aParser <- argumentParser()
#aparser$add_argument("-query", "--maxmin_query"



args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("USAGE: Rscript week3_1.R input", call.=FALSE)
} else if (length(args)==1) {
  i_f <- args[1] 
}
print(i_f)

d <- read.table(i_f,stringsAsFactors=F,header=F)
colnames(d) <- c('Status.of.existing.checking.account',
                 'Duration.in.month',  'Credit.history', 'Purpose',
                 'Credit.amount', 'Savings account/bonds',
                 'Present.employment.since',
                 'Installment.rate.in.percentage.of.disposable.income',
                 'Personal.status.and.sex', 'Other.debtors/guarantors',
                 'Present.residence.since', 'Property', 'Age.in.years',
                 'Other.installment.plans', 'Housing',
                 'Number.of.existing.credits.at.this.bank', 'Job',
                 'Number.of.people.being.liable.to.provide.maintenance.for',
                 'Telephone', 'foreign.worker', 'Good.Loan')
d$Good.Loan <- as.factor(ifelse(d$Good.Loan==1,'GoodLoan','BadLoan'))
mapping <- list(
  'A40'='car (new)',
  'A41'='car (used)',
  'A42'='furniture/equipment',
  'A43'='radio/television',
  'A44'='domestic appliances')
for(i in 1:(dim(d))[2]) {             	# Note: 1
  if(class(d[,i])=='character') {
    d[,i] <- as.factor(as.character(mapping[d[,i]]))  	# Note: 2
  }
}
summary(d$Purpose)
table(d$Purpose,d$Good.Loan)
