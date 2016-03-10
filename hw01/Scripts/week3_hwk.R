args <- commandArgs(trailingOnly=T)

# get the position in args
q <- pmatch("-query", args)
f <- pmatch("-files", args)
o <- pmatch("-out", args)
fileCount <- length(args)-5

# error in argument, show the tips
# only check some obvious input error, use the package will be better than parsing by myself.
if (length(args)==0 | is.na(q) | is.na(f) | is.na(o)) {
	stop("USAGE: Rscript week3_hwk.R [-query max/min] [-files file1 file2 ...] [-out output.csv]", call.=FALSE)
}

# open data
path <- "../Data/"
temp <- data.frame()
result <- data.frame(type=c("weight", "height"))

for (x in c(1:fileCount)) {
	fname <- args[f+x]
	temp <- read.table(paste(path, fname, sep=""), sep = ",", stringsAsFactors=F, header=T)
	
	if (args[q+1]=="max"){
		result[,fname] <- c(max(temp$weight, na.rm = T), max(temp$height, na.rm = T))
	} else if (args[q+1]=="min") {
		result[,fname] <- c(min(temp$weight, na.rm = T), min(temp$height, na.rm = T))
	} else {
		stop("USAGE: Rscript week3_hwk.R [-query max/min] [-files file1 file2 ...] [-out output.csv]", call.=FALSE)
	}
}

# then use apply() to get the colnames of the max/min value.
if (args[q+1]=="max"){
	result[,args[q+1]] <- colnames(result)[apply(result[,2:ncol(result)], 1, which.max)+1]
} else if (args[q+1]=="min") {
	result[,args[q+1]] <- colnames(result)[apply(result[,2:ncol(result)], 1, which.min)+1]
}
# output and write file
write.table(result, file=args[o+1], row.names=F ,sep=",")

