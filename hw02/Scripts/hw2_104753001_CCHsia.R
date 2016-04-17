library('ROCR')
# implement confusion matrix, output a dataframe
confusionMatrix_func <- function(target, temp) { #temp is dataframe
    resultFrame <- data.frame(ref_p=c(0,0), ref_n=c(0,0))
    row.names(resultFrame) <- c("pred_p","pred_n")

    if(target != "male" && target != "female") {
        stop("ERROR: unknown target argument, -target must be male/female")
    }

    for(x in 1:nrow(temp)) {
        p <- tolower(temp[x,]['prediction'])
        r <- tolower(temp[x,]['reference'])
        if(p==target) { # positive
            if(p==r) { # TP
                resultFrame[1,1] <- resultFrame[1,1]+1
            } else { # FP
                resultFrame[1,2] <- resultFrame[1,2]+1
            }

        } else { # negative
            if(p==r) { # TN
                resultFrame[2,2] <- resultFrame[2,2]+1 
            } else { # FN
                resultFrame[2,1] <- resultFrame[2,1]+1
            }
        }
    }
    return(resultFrame)
}

# do query(F1, AUC, ...), conf is confusionMatrix_func()'s datafrme
query_func <- function(query, conf, temp, target) {
    tp <- conf[1,1]
    fp <- conf[1,2]
    tn <- conf[2,2]
    fn <- conf[2,1]
    if(query=="F1"){
        return(2*tp/(2*tp+fp+fn))
    } else if(query=="AUC") { # use ROCR package.
        pred <- prediction(temp$pred.score, temp$reference)
        auc <- as.numeric(performance(pred,"auc")@y.values)
        return(auc)
    } else if(query=="sensitivity") {
        return(tp/(tp+fn))
    } else if(query=="specificity") {
        return(tn/(fp+tn))
    } else {
        stop("ERROR: unknown query argument, -query must be one or more in [F1 AUC sensitivity specificity]")
    }
}

plotROC <- function(temp) {
    pred <- prediction(temp$pred.score, temp$reference)
    roc <- performance(pred, "tpr", "fpr")
    return(roc)
}

args <- commandArgs(trailingOnly = T)
# get the position in args
t <- pmatch("-target", args)    # male | female
q <- pmatch("-query", args)     # could be F1, AUC, Sensitivity, Specifity
f <- pmatch("-files", args)     # set1 ~ set5
o <- pmatch("-out", args)       # ouput folder
end <- length(args)+1           # add pseudo element after last one

sortPosition <- sort(c(t, q, f, o, end))
fileCount <- 0
queryCount <- 0 
f_flag <- T
q_flag <- T
for(item in sortPosition) {
    if(item > f && f_flag) { # get the distance between "-files" and next "-xxxx".
        fileCount <- item-f-1
        f_flag <- F
    }
    if(item > q && q_flag) { # get the distance between "-query" and next "-xxxx".
        queryCount <- item-q-1
        q_flag <- F
    } 
}

# error in argument, show the tips
# only check some obvious input error, use the package will be better than parsing by myself.
if (length(args)==0 | is.na(t) | is.na(q) | is.na(f) | is.na(o)) {
	stop("USAGE: Rscript hw2_104753001_CCHsia.R [-target male/female] [-query F1 AUC sensitivity specifity] [-files ../data/set1 ../data/set2 ...] [-out ../Results]", call.=FALSE)
}

# open data
for(x in c(1:fileCount)) { # for in "../Data/set1~5 folders"
    filePath <- args[f+x]
    methodBind <- c()
    color <- c("red", "orange", "azure4", "green", "blue", "midnightblue", "mediumpurple", "plum", "black", "green4") # plot color, 4 is blue
    sig <- c()
    png(filename=paste(args[o+1], "/", basename(filePath), "_ROC.png", sep=""))

    for(y in c(1:10)) { # for in "method1~10 files"
        path <- paste(filePath, "/method", y, ".csv",sep="") # get method 1-10
        temp <- read.table(path, sep = ",", stringsAsFactors=F, header=T)
        conf <- confusionMatrix_func(args[t+1] ,temp) # create confusion matrix
        names <- c()
        methodRow <- c()
        for(z in c(1:queryCount)) { # the argument could be 1 or >1 of [F1, AUC, sensitivity, specifity]
            querySpecies <- args[q+z]
            names <- c(names, toString(querySpecies))
            tmp = round(query_func(querySpecies, conf, temp, args[t+1]), 2)
            methodRow <- c(methodRow, tmp)
        }
        methodBind <- rbind(methodBind, methodRow)

        # siganificant, threshold set to 0.1
        # if use 0.05, all the result will be "no"
        # not sure about this part, here use fishertest and input is confusionMatrix.
        pValue <- fisher.test(conf)$p.value
        if(pValue<=0.1) {
            sig <- c(sig, "yes")
        } else {
            sig <- c(sig, "no")
        }

        # plot the ROC curve
        if(y==1){
            plot(plotROC(temp), main="ROC Curve", lty=y, col=color[y])
        } else {
            #plot(plotROC(temp), add=T, col=color)
            lines(plotROC(temp)@x.values[[1]], plotROC(temp)@y.values[[1]], lty=y, col=color[y])
        }
    }

    rownames(methodBind) <- NULL
    method <- paste("method", 1:10, sep="")
    colnames(methodBind) <- names
    index <- apply(methodBind,2,which.max)
    highest <- c("highest", method[index])
    # bind the result together
    result <- cbind(method, methodBind)
    result <- rbind(result, highest)
    siganificant <- c(sig, "nan")
    result <- cbind(result, siganificant)
    rownames(result) <- NULL

    # write file
    outputfile <- data.frame(result)
    write.table(outputfile, file=paste(args[o+1], "/", basename(filePath), ".csv", sep=""), row.names=F, sep=",", quote=F)
    #legend("topleft", names(result), cex=0.8, col=color, lty=1:3, lwd=2, bty="n")
    #legend("topleft", names(result), cex=0.8, col=color, pch=21:23, lty=1:3)
    legend("bottomright",paste("method", 1:10, sep=""),lty=1:6, col=color,border="white",cex=1.0,box.col = "black")
    dev.off()# Turn off device driver (to flush output to png
}
