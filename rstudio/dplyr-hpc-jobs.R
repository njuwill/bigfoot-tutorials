# point to Spark 2.0.2 on rstudio server
Sys.setenv(SPARK_HOME="/opt/spark-2.0.2-bin-hadoop2.6")
Sys.setenv(HADOOP_CONF_DIR="/etc/hadoop/conf")

library(sparklyr)

#readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

# Spark configuration to add more executors
config <- spark_config()
config$spark.executor.instances <- 40

# connect to Spark
sc <- spark_connect(master = "yarn-client",
                    version = "2.0.0", 
                    config = config)

# read pegasus user json file
users <- spark_read_json(sc, "users", 
                            "/project/hpcjobs/pegasus-users.json")

# read pegasus group json file
groups <- spark_read_json(sc, "groups", 
                            "/project/hpcjobs/pegasus-groups.json")

# join user and group to get uid to gid mapping
ug_map <- users %>% inner_join(groups, by="gidNumber") %>% select(uid, gid)

# read job data file from hive warehouse and select fields to save data transfer
job_finish <- spark_read_parquet(sc, "job_finish", "/user/hive/warehouse/hpcjob.db/job_finish") %>% select(username, jobid);

# join job data frame with uid-gid mapping, run aggregation and query for job nubmer counts per group. order results by count
results <-job_finish %>%
  inner_join(ug_map, by=c("username" =  "uid")) %>%
  group_by(gid) %>% summarise(count=n()) %>% 
  select(gid, count) %>% 
  arrange(-count) %>% 
  collect

# make barplot
barplot(results[[2]], names.arg=results[[1]])

# disconnect from Spark
spark_disconnect(sc)
