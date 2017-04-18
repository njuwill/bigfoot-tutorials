library(sparklyr)

# pick standard Spark version
readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

# Spark configuration, use more executors to improve data loading speed
# and computing efficiency
config <- spark_config()
config$spark.executor.instances <- 40

# connect to Spark
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = config)

# read job_finish from hive warehouse parquet file
job_finish = spark_read_parquet(sc, "job_finish", "/user/hive/warehouse/hpcjob.db/job_finish");

# create user job number report by projects
results <- job_finish %>% 
  filter(username=="zhu") %>% 
  group_by(projectname) %>% 
  summarise(count=n()) %>% 
  select(projectname, count) %>% 
  collect

# make barplot
barplot(results[[2]], names.arg=results[[1]])

# disconnect from Spark
spark_disconnect(sc)
