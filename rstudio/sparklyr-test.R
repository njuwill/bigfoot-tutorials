# load sparklyr package
library(sparklyr)

# update r environment (SPARK_HOME updated)
readRenviron("/usr/lib64/R/etc/Renviron")

# load DBI package
library(DBI)

# initialize spark context, replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",version = "1.6.0", config = list(default = list(spark.yarn.principal = "USER_NAME@CLUSTER")))

# query hive table, count finished hpc jobs
test <- dbGetQuery(sc, 'Select count(*) from hpcjob.job_finish')

# query hive table, rank users by number of jobs
rank <- dbGetQuery(sc, 'Select username, count(*) c from hpcjob.job_finish group by username order by c desc')

# barplot user ranking
barplot(rank[[2]][1:20], names.arg=rank[[1]][1:20])