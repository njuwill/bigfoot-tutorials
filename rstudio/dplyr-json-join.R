# point to Spark 2.0.2
Sys.setenv(SPARK_HOME="/opt/spark-2.0.2-bin-hadoop2.6")
Sys.setenv(HADOOP_CONF_DIR="/etc/hadoop/conf")

library(sparklyr)

#readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

# Spark configuration to use less executor number. 2 is the default
config <- spark_config()
config$spark.executor.instances <- 2

# connect to Spark
sc <- spark_connect(master = "yarn-client",
                    version = "2.0.0", 
                    config = config)

# read pegasus user list from json file
users = spark_read_json(sc, "users", 
                            "/project/hpcjobs/pegasus-users.json")

# read pegasus group list from json file
groups = spark_read_json(sc, "groups", 
                            "/project/hpcjobs/pegasus-groups.json")
# print csv leading records
head(users)
head(groups)

# print colum names
colnames(users)
colnames(groups)

# join users with groups using gid number, count user number per groups
results = users %>% 
  inner_join(groups, by="gidNumber") %>% 
  group_by(gid) %>% summarise(count=n()) %>% 
  select(gid, count) %>% 
  collect

# make barplot
barplot(results[[2]], names.arg=results[[1]])

# disconnect from Spark
spark_disconnect(sc)
