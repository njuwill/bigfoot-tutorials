# R INTRODUCTION

# Creating a data set

R works with packages that contain the techniques and functions you need. To start with some basic examples you need to know how to install and load a package. 

~~~~
## installing a package (i.e. alr4 - Applied Linear Regression 4th Edition Data Sets)
install.packages("alr4")

## loading a package
library(alr4)
~~~~

R data is manipulated with dataframes; data should be preferable in "matrix" form. You can create a data set, read a csv file or use a dataset already available (for example, doing a query from bigfoot - explained in "bigfoot-tutorials/rstudio/impala-test.R")

~~~
## create a data set: create variables using the c function. This function keeps values together.
x1 <- c("big","data","analytics")
x2 <- c(4, 5, 2)

## dataframe function - you can add a name to each variable
data <- data.frame(words=x1,count=x2)

## data results:
      words count
1       big     4
2      data     5
3 analytics     2

## read a csv file - if the first row of the data is name for each variable, header should equal to TRUE
csv_data <- read.csv(name_of_file.csv,header=TRUE)
~~~

# Reviewing a data set

You can review the structure of the data set using the following functions.

~~~~
## using a data set example from the alr4 package: BigMac2003
head(BigMac2003) ## shows first rows of data set
BigMac2003[1,1] ## the brackets get an element of the data set; in this case the first row and first column
str(BigMac2003) ## shows the structure of the data set
dim(BigMac2003) ## shows how big a data set is
class(BigMac2003) ## tells the class of data set
names(BigMac2003) ## shows the variable names in the data set
attach(BigMac2003) ## to call the variables inside the data set by their names
detach(BigMac2003) ## once finished, is better to detach the data
summary(BigMac2003) ## gives general stadistics about each variable in the data set
~~~

Below is an example of the results from the review functions.
~~~
> head(BigMac2003) 
          BigMac Bread Rice FoodIndex  Bus Apt TeachGI TeachNI TaxRate TeachHours
Amsterdam     16     9    9      65.9 2.00 890    34.3    20.5 40.2332         39
Athens        21    12   19      63.5 0.61 620    19.5    15.9 18.4615         29
Auckland      19    19    9      55.4 1.57 780    22.0    16.1 26.8182         40
Bangkok       50    42   25      46.4 0.47 120     4.2     4.0  4.7619         35
Barcelona     22    19   10      62.9 0.91 590    25.5    20.1 21.1765         39
Basel         15     7    7      98.4 2.34 930    78.5    57.6 26.6242         35

> BigMac2003[1,1] 
[1] 16

> str(BigMac2003) 
'data.frame':	69 obs. of  10 variables:
 $ BigMac    : int  16 21 19 50 22 15 16 93 54 18 ...
 $ Bread     : int  9 12 19 42 19 7 10 48 20 11 ...
 $ Rice      : int  9 19 9 25 10 7 16 16 28 12 ...
 $ FoodIndex : num  65.9 63.5 55.4 46.4 62.9 98.4 64.4 33.3 36.9 74.7 ...
 $ Bus       : num  2 0.61 1.57 0.47 0.91 2.34 2.21 0.32 0.36 1.5 ...
 $ Apt       : int  890 620 780 120 590 930 630 200 350 590 ...
 $ TeachGI   : num  34.3 19.5 22 4.2 25.5 78.5 45 4.1 4.1 30.6 ...
 $ TeachNI   : num  20.5 15.9 16.1 4 20.1 57.6 28.9 3.9 3.3 18.9 ...
 $ TaxRate   : num  40.23 18.46 26.82 4.76 21.18 ...
 $ TeachHours: int  39 29 40 35 39 35 36 41 40 24 ...

> dim(BigMac2003) 
[1] 69 10

> class(BigMac2003) 
[1] "data.frame"

> names(BigMac2003)
 [1] "BigMac"     "Bread"      "Rice"       "FoodIndex"  "Bus"        "Apt"       
 [7] "TeachGI"    "TeachNI"    "TaxRate"    "TeachHours"
 
 > summary(BigMac2003)
     BigMac           Bread            Rice         FoodIndex           Bus       
 Min.   : 10.00   Min.   : 6.00   Min.   : 5.00   Min.   : 23.50   Min.   :0.090  
 1st Qu.: 16.00   1st Qu.:13.00   1st Qu.:12.00   1st Qu.: 41.20   1st Qu.:0.360  
 Median : 25.00   Median :19.00   Median :16.00   Median : 62.60   Median :0.830  
 Mean   : 37.28   Mean   :24.58   Mean   :19.94   Mean   : 61.93   Mean   :1.041  
 3rd Qu.: 48.00   3rd Qu.:28.00   3rd Qu.:22.00   3rd Qu.: 75.30   3rd Qu.:1.490  
 Max.   :185.00   Max.   :90.00   Max.   :96.00   Max.   :129.40   Max.   :3.700  
      Apt            TeachGI         TeachNI         TaxRate         TeachHours   
 Min.   :  90.0   Min.   : 0.60   Min.   : 0.50   Min.   :-7.317   Min.   :20.00  
 1st Qu.: 320.0   1st Qu.: 4.10   1st Qu.: 3.40   1st Qu.:15.000   1st Qu.:33.00  
 Median : 700.0   Median :17.80   Median :12.60   Median :21.739   Median :38.00  
 Mean   : 713.9   Mean   :21.22   Mean   :15.78   Mean   :21.482   Mean   :36.74  
 3rd Qu.: 950.0   3rd Qu.:32.30   3rd Qu.:22.50   3rd Qu.:28.807   3rd Qu.:40.00  
 Max.   :1930.0   Max.   :78.50   Max.   :57.60   Max.   :42.353   Max.   :58.00  
 ~~~

