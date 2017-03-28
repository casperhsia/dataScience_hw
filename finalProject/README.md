# Final for Data Science in Practice
## Requirement
To run the program, you need the package **package e1071**.

It's a SVM package developed by NTU, here is the link and some information: [package e1071] (https://cran.r-project.org/web/packages/e1071/index.html). You have to install and include it:

    install.packages("e1071")
    library("e1071")

## Run main.R
main.R is the main program. It will take few minutes to complete the program. User have to input following argument:

1.  -fold n
2.  -feature [all, slct, rand]
3.  -out output.csv

For example, the input can be:

    Rscript main.R -fold 10 -feature all -out output.csv

## Visualization
The link of the online [visualization demo] (https://summer.shinyapps.io/finalProject/).

We can compare different method of feature selection, and also observe the graph of cross validation.
## Reference
- libSVM [1] (http://www.csie.ntu.edu.tw/~cjlin/libsvm/R_example)
[2] (https://c3h3notes.wordpress.com/2010/10/20/r%E4%B8%8A%E7%9A%84libsvm-package-e1071/)
- shinyapps [1] (https://www.shinyapps.io/)
