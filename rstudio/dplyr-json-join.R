Sys.setenv(SPARK_HOME="/opt/spark-2.0.2-bin-hadoop2.6")
Sys.setenv(HADOOP_CONF_DIR="/etc/hadoop/conf")

library(sparklyr)

#readRenviron("/usr/lib64/R/etc/Renviron-spark-2.1")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

config <- spark_config()
config$spark.executor.instances <- 2

# replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",
                    version = "2.0.0", 
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

results = users %>% inner_join(groups, by="gidNumber") %>% group_by(gid) %>% summarise(count=n()) %>% select(gid, count) %>% collect

# make barplot
barplot(results[[2]], names.arg=results[[1]])

spark_disconnect(sc)
