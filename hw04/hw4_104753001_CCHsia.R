# library of libSVM
# http://www.csie.ntu.edu.tw/~cjlin/libsvm/R_example
library(e1071)

args <- commandArgs(trailingOnly=TRUE)
# get the position in args
# n is args[f+1], and opFilename is args[o+1]
f <- pmatch("-fold", args)
o <- pmatch("-out", args)

# error in argument, show the tips
# only check some obvious input error, use the package will be better than parsing by myself.
if (length(args)==0 | is.na(f) | is.na(o)) {
	stop("USAGE: Rscript hw4_104753001_CCHsia.R -fold n –out op.csv", call.=FALSE)
}

# open data
data <- read.csv("./Archaeal_tfpssm.csv",header=FALSE)

# randomly shuffle the data
data <- data[sample(nrow(data)),]

# create n folds
n <- as.integer(args[f+1])
folds <- cut(seq(1,nrow(data)),breaks=n,labels=FALSE)

# n fold cross validation
accuracy <- c(0,0,0)
for(i in 1:n){
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- data[testIndexes, ]
    trainData <- data[-testIndexes, ]

    # % of training vs % of calibration = 90 vs 10
    calibration <- cut(seq(1,nrow(trainData)),breaks=10,labels=FALSE)
    calibrationIndexes <- which(calibration==i,arr.ind=TRUE)
    calibrationData <- trainData[calibrationIndexes, ]
    trainData <- trainData[-calibrationIndexes, ]


    # training, y is label. use SVM
    x <- trainData[,3:5602]
    y <- trainData[,2]
    model <- svm(x,y)

    # predict
    trainResult <- predict(model, x)
    calibrationResult <- predict(model, calibrationData[3:5602])
    testResult <- predict(model, testData[3:5602])

    # prdict table, for example:
    #	testResult CP CW EC IM
    #			CP 65  0  0  0
    # 			CW  0  5  0  0
    #			EC  0  0  1  1
    #			IM  0  0  0  9
    trRTable <- table(trainResult, y)
    cRTable <- table(calibrationResult, calibrationData[,2])
    tRTable <- table(testResult, testData[,2])

    # choose best result, by testData
    correctCount <- sum(tRTable[1,1])+sum(tRTable[2,2])+sum(tRTable[3,3])+sum(tRTable[4,4])
    totalCount <- sum(tRTable)
    if(correctCount / totalCount > accuracy[3]){ # if this fold is better
    	accuracy[1] <- ( sum(trRTable[1,1])+sum(trRTable[2,2])+sum(trRTable[3,3])+sum(trRTable[4,4]) ) / sum(trRTable)
    	accuracy[2] <- ( sum(cRTable[1,1])+sum(cRTable[2,2])+sum(cRTable[3,3])+sum(cRTable[4,4]) ) / sum(cRTable)
    	accuracy[3] <- correctCount / totalCount
    }
}


# output file
set <- c("training", "calibration", "test")

result <- cbind(set, accuracy)
colnames(result) <- c("set", "accuracy")

write.table(result, file = args[o+1], sep=',', row.names=FALSE)