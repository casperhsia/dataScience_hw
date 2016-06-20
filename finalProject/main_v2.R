# library of libSVM
# http://www.csie.ntu.edu.tw/~cjlin/libsvm/R_example
library(e1071)

args <- commandArgs(trailingOnly=TRUE)
# get the position in args
o <- pmatch("-out", args)

# error in argument, show the tips
# only check some obvious input error, use the package will be better than parsing by myself.
if (length(args)==0 | is.na(o)) {
	stop("USAGE: Rscript main_v2.R –out op.csv", call.=FALSE)
}

# open data
train <- read.csv("./train.csv",header=TRUE)
test <- read.csv("./test.csv",header=TRUE)

    accuracy <- c(0,0)
    # training, y is label. use SVM
    # x <- train[,1:23]
    # c(3,8,9,15,16,17,20,22)
    featrueSelect <- c(4,5,6,7,8,9,10,11)
    x <- train[,featrueSelect]
    y <- train[,24]
    model <- svm(x,y)
    # predict
    trainResult <- predict(model, x)
    #testResult <- predict(model, test[,1:23])
    testResult <- predict(model, test[,featrueSelect])

    # prdict table, for example:
    #	testResult  Y N
    #			 Y 65  0
    # 			 N  1  5
    trRTable <- table(trainResult, y)
    tRTable <- table(testResult, test[,24])
    print(trRTable)
    print(tRTable)
    # not choose the best model!! add them and count the averge
    accuracy[1] <- accuracy[1] + ( sum(trRTable[1,1])+sum(trRTable[2,2]) ) / sum(trRTable)
    accuracy[2] <- accuracy[2] + ( sum(tRTable[1,1])+sum(tRTable[2,2]) ) / sum(tRTable)

    print(tRTable)
    tp <- tRTable[2,2]
    fp <- tRTable[2,1]
    tn <- tRTable[1,1]
    fn <- tRTable[1,2]

    message("accuracy: ", (tp+tn)/(tp+fp+tn+fn))
    message("F1: ", 2*tp/(2*tp+fp+fn))
    message("Recall: ", tp/(tp+fn))
    message("Precision: ", tp/(tp+fp))
    message("==========")


# output file
set <- c("training", "test")

result <- cbind(set, accuracy)
colnames(result) <- c("set", "accuracy")

write.table(result, file = args[o+1], sep=',', row.names=FALSE)
