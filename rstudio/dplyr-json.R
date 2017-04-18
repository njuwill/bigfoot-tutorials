library(sparklyr)

# pick up right Spark version
readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

# Spark configuration, use default executor number 2
config <- spark_config()
config$spark.executor.instances <- 2

# connect to Spark
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = config)

# read pegasus users from json file 
users = spark_read_json(sc, "users", 
                            "/project/hpcjobs/pegasus-users.json")

# read pegasus groups from json file
groups = spark_read_json(sc, "groups", 
                            "/project/hpcjobs/pegasus-groups.json")
# print csv leading records
head(users)
head(groups)

# print colum names
colnames(users)
colnames(groups)

# uncomment the following to write spark data frames to hdfs
# make sure those files(folders) do not exist

#spark_write_csv(users, '/project/public/data/pegasus-users.csv')
#spark_write_csv(groups, '/project/public/data/pegasus-groups.csv')

# disconnect from Spark
spark_disconnect(sc)
