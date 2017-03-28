## installing a package that include a dataset with 53,940 observations of 10 variables. The name of the dataset is "diamonds".

install.packages("ggplot2")
library(ggplot2)
data(diamonds)
str(diamonds)

## installing the package for random forest (a model that would need more computing time when using a big data set). 
## For the model, we use the variable price as the 'y' variable and the rest of the variables in the dataset as 'x' variables.

install.packages("randomForest")
library(randomForest)

## LOCAL COMPUTING

## to calculate the amount of time it took to run the model we use proc.time() function to mark start and end of time.

# Start the clock!
ptm <- proc.time()
# Running Model
test <- randomForest(price~., diamonds, method="class")
# Stop the clock
proc.time() - ptm

## time running was aproximately of 42 minutes using bdrstudio

## SPARKR COMPUTING

## to connect to the cluster we need to open 'sparklyr' and 'dbi' packages and connect to the cluster

library(sparklyr)
readRenviron("/usr/lib64/R/etc/Renviron")
library(DBI)
sc <- spark_connect(master = "yarn-client",version = "1.6.0", config = list(default = list(spark.yarn.principal = "USERNAME@CLUSTER")))

## we need to copy the dataset to the cluster for the computing

library(dplyr)
diamonds_tbl <- copy_to(sc, diamonds)

## calculating time to run model

# Start the clock!
ptm <- proc.time()
test <- randomForest(price~., diamonds, method="class")
# Stop the clock
proc.time() - ptm

## time running was aproximately of 22 minutes using sparkR in bdrstudio
