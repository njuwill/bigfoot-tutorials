library(sparklyr)
library(ggplot2)
library(dplyr) 

# pick standard Spark version
readRenviron("/usr/lib64/R/etc/Renviron")

# Spark configuration, use more executors to improve data loading speed
# and computing efficiency
config <- spark_config()
config$spark.executor.instances <- 40

# connect to Spark
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = config)

# read job_finish from hive warehouse parquet file
job_finish <- spark_read_parquet(sc, "job_finish", "/user/hive/warehouse/hpcjob.db/job_finish") %>%
  filter(starttime > '2013-01-01') %>%
  select(maxnumprocessors, maxrswap, projectname)

# sample jobs
job_sample <- sdf_sample(job_finish, 0.0001)

# print job distributions
job_sample %>%
  collect %>%
  ggplot(aes(maxnumprocessors, maxrswap)) +
  geom_point(aes(maxnumprocessors, maxrswap),
             size = 2, alpha = 0.5)+
  labs(
    x = "num of processors",
    y = "max memory",
    title = "Job Distribution",
    subtitle = "Sampled Pegasus Job Distribution"
  )

# disconnect from Spark
spark_disconnect(sc)
