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
- ../Results is a folder. The output will have # of -files argument .csv and .png. (We got 3 .csv and 3 .png for this example.)

##Data
The testing data is in this folder. According to -files argument.

##Results
There is an example of output in the folder. Accordding to -out argument.

![alt tag](https://raw.githubusercontent.com/casperhsia/dataScience_hw/master/hw02/Results/set1_ROC.png) "ROC of set1")
