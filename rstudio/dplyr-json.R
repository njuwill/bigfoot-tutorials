library(sparklyr)

readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

config <- spark_config()
config$spark.executor.instances <- 2

# replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = config)

# read job_finish from parquet file

users = spark_read_json(sc, "users", 
                            "/project/hpcjobs/pegasus-users.json")

groups = spark_read_json(sc, "groups", 
                            "/project/hpcjobs/pegasus-groups.json")
# print csv leading records
head(users)
head(groups)

# print colum names
colnames(users)
colnames(groups)

spark_disconnect(sc)
