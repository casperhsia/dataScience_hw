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
	stop("USAGE: Rscript main.R -fold n –out op.csv", call.=FALSE)
}

# open data
data <- read.csv("./STULONGData.txt",header=TRUE)
dataY <- subset(data, death == 'Y')
dataN <- subset(data, death == 'N')

# randomly shuffle the data
dataY <- dataY[sample(nrow(dataY)),]
dataN <- dataN[sample(nrow(dataN)),]

# create n folds
n <- as.integer(args[f+1])
foldsY <- cut(seq(1,nrow(dataY)),breaks=n,labels=FALSE)
foldsN <- cut(seq(1,nrow(dataN)),breaks=n,labels=FALSE)

# n fold cross validation
accuracy <- c(0,0)
for(i in 1:n){
    testIndexesY <- which(foldsY==i,arr.ind=TRUE)
    testIndexesN <- which(foldsN==i,arr.ind=TRUE)

    testDataY <- dataY[testIndexesY, ]
    testDataN <- dataN[testIndexesN, ]
    trainDataY <- dataY[-testIndexesY, ]
    trainDataN <- dataN[-testIndexesN, ]

    # training, y is label. use SVM
    x <- rbind(trainDataY[,1:23], trainDataN[,1:23])
    # x <- trainData[,c(3,8,9,15,16,17,20,22)]
    y <- c(trainDataY[,24], trainDataN[,24])
    print(y)
    
    model <- svm(x,y)
    # predict
    trainResult <- predict(model, x)
    testResult <- predict(model, append(testDataY[,1:23], testDataN[,1:23]))
    # prdict table, for example:
    #	testResult CP CW EC IM
    #			CP 65  0  0  0
    # 			CW  0  5  0  0
    #			EC  0  0  1  1
    #			IM  0  0  0  9
    trRTable <- table(trainResult, y)
    tRTable <- table(testResult, append(testDataY[,24], testDataN[,24]))
    print(trRTable)
    # not choose the best model!! add them and count the averge
    accuracy[1] <- accuracy[1] + ( sum(trRTable[1,1])+sum(trRTable[2,2]) ) / sum(trRTable)
    accuracy[2] <- accuracy[2] + ( sum(tRTable[1,1])+sum(tRTable[2,2]) ) / sum(tRTable)
}

# average acc
accuracy <- accuracy / n
# output file
set <- c("training", "test")

result <- cbind(set, accuracy)
colnames(result) <- c("set", "accuracy")

write.table(result, file = args[o+1], sep=',', row.names=FALSE)
