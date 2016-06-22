# library of libSVM
# http://www.csie.ntu.edu.tw/~cjlin/libsvm/R_example
library(e1071)

args <- commandArgs(trailingOnly=TRUE)
# get the position in args
# n is args[f+1], and opFilename is args[o+1]
f <- pmatch("-fold", args)
o <- pmatch("-out", args)
m <- pmatch("-feature", args)

# error in argument, show the tips
# only check some obvious input error, use the package will be better than parsing by myself.
if (length(args)==0 | is.na(f) | is.na(o) | is.na(m)) {
	stop("USAGE: Rscript main.R -fold n -feature [all, slct, rand] –out op.csv", call.=FALSE)
}

# open data
data <- read.csv("./STULONGData.txt",header=TRUE)

# randomly shuffle the data
data <- data[sample(nrow(data)),]

# create n folds
n <- as.integer(args[f+1])
folds <- cut(seq(1,nrow(data)),breaks=n,labels=FALSE)

# n fold cross validation
goodfeature <- c(3,8,9,15,16,17,20,22)
randomfeature <- sample(1:23, 8, replace=F)
result <- c() 
for(i in 1:n){
    testIndexes <- which(folds==i,arr.ind=TRUE)

    testData <- data[testIndexes, ]
    trainData <- data[-testIndexes, ]
    
    trainY <- subset(trainData, death == 'Y')
    trainN <- subset(trainData, death == 'N')
    
    # balance the training data 50%:50%
    counterY <- nrow(trainY)
    trainN <- head(trainN, counterY)
    trainData <- rbind(trainY, trainN)

    # training, y is label. use SVM
    # all slct rand
    x <- trainData[,1:23] #all 
    if(args[o+1]=='slct'){
        x <- trainData[,goodfeature]}
    if(args[o+1]=='rand'){
        x <- trainData[,randomfeature]}
    # x <- trainData[,c(3,8,9,15,16,17,20,22)]

    y <- trainData[,24]
    model <- svm(x,y)
    # predict
    trainResult <- predict(model, x)
    testResult <- predict(model, testData[,1:23])
    # prdict table, for example:
    #	testResult CP CW EC IM
    #			CP 65  0  0  0
    # 			CW  0  5  0  0
    #			EC  0  0  1  1
    #			IM  0  0  0  9
    trRTable <- table(trainResult, y)
    tRTable <- table(testResult, testData[,24])
    
    # not choose the best model!! add them and count the averge
    
    tp <- tRTable[2,2]
    fp <- tRTable[1,2]
    tn <- tRTable[1,1]
    fn <- tRTable[2,1]
    
    acc <- c(i, "Acc", (tp+tn)/(tp+fp+tn+fn))
    f1 <- c(i, "F1", 2*tp/(2*tp+fp+fn))
    recall <- c(i, "Recall", tp/(tp+fn))
    precision <- c(i, "Precision", tp/(tp+fp))
    
    result <- rbind(result, acc, f1, recall, precision)
}

# output file

#result <- cbind(set, accuracy)
colnames(result) <- c("iterTimes", "Type", "Value")
write.table(result, file = args[o+1], sep=',', row.names=FALSE)
