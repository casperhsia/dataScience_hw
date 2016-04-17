#Homework02 for Data Science in Practice
##Scripts
In this folder, __hw2\_104753001\_CCHsia.R__ is the main program. User have to input following argument:

1. -target male/female
2. -query F1 AUC sensitivity specificity
3. -files ../Data/set1 ../Data/set2 ...
4. -out ../Results

For example, the input can be: 

    Rscript hw2_104753001_CCHsia.R -target female -query F1 AUC sensitivity specificity -files ../Data/set1 ../Data/set2 ../Data/set5 -out ../Results

The explanation of this command:

- female is positive.
- It will give [F1,AUC,sensitivity,specificity] value. You can choose only one (-query F1) or more than one (-query F1 AUC).
- ../Data/set1 is a folder contains 10 .csv of method.
- ../Results is a folder. The output will have # of -files argument .csv and .png. (We got 3 .csv and 3 .png in this example.)

##Data
The testing data is in this folder. According to -files argument.

##Results
There is an example of output in the folder. Accordding to -out argument.

I set the threshold of the siganificant as 0.01, but still get most "no" result.


![alt tag](https://raw.githubusercontent.com/casperhsia/dataScience_hw/master/hw02/Results/set1_ROC.png)

##Reference
R Plot  [1](http://www.harding.edu/fmccown/r/)
[2](http://www.statmethods.net/advgraphs/parameters.html)
[3](http://stackoverflow.com/questions/19053440/r-legend-with-points-and-lines-being-different-colors-for-the-same-legend-item)

ROCR Plot  [1](http://www.inside-r.org/packages/cran/verification/docs/roc.plot)
[2](http://stackoverflow.com/questions/14085281/multiple-roc-curves-in-one-plot-rocr)
[3](http://www.r-bloggers.com/an-example-of-roc-curves-plotting-with-rocr/)

ROCR  [1](https://cran.r-project.org/web/packages/ROCR/ROCR.pdf)

P-value  [1](http://stats.stackexchange.com/questions/75050/in-r-how-to-compute-the-p-value-for-area-under-roc)
[2](http://blog.xuite.net/metafun/life/82541806-p-value%E3%80%81%E9%A1%AF%E8%91%97%E6%B0%B4%E6%BA%96%E3%80%81Type+I+error,+Type+2+error)

FisherTest  [1](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/fisher.test.html)
