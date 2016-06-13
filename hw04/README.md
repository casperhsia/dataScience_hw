#Homework04 for Data Science in Practice
##Requirement
To run the program, you need the package **package e1071**.

Then you have to install and include it:

    install.packages("e1071")
    library("e1071")
##hw4\_104753001\_CCHsia.R
hw4\_104753001\_CCHsia.R is the main program. It will take few minutes to complete the program. User have to input following argument:

1. -fold n
2. -out output.csv

For example, the input can be: 

	Rscript hw4_104753001_CCHsia.R -fold 10 -out output.csv

It will perform 10-fold cross-validation, and give the result.

##Method
I use libSVM for R. To execute the Rscript, you have to install **package e1071**.

##Reference
- libSVM [1] (http://www.csie.ntu.edu.tw/~cjlin/libsvm/R_example)
[2] (https://c3h3notes.wordpress.com/2010/10/20/r%E4%B8%8A%E7%9A%84libsvm-package-e1071/)
- cross validation [1] (http://stats.stackexchange.com/questions/61090/how-to-split-a-data-set-to-do-10-fold-cross-validation)
[2] (http://www.r-bloggers.com/cross-validation-for-predictive-analytics-using-r/)
