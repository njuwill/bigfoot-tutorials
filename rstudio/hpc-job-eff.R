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
job_eff <- spark_read_parquet(sc, "job_finish", "/user/hive/warehouse/hpcjob.db/hpc_job_eff") %>%
  select(starttime, endtime, maxnumprocessors, stime, utime)

# sample jobs
job_sample <- sdf_sample(job_eff, 0.0001)

# print job distributions
job_sample %>%
  mutate(eff = (utime+stime)/(maxnumprocessors*(unix_timestamp(endtime)-unix_timestamp(starttime)))) %>%
  na.omit() %>%
  filter(maxnumprocessors < 50 & eff > 0) %>%
  collect %>%
  ggplot(aes(maxnumprocessors, eff)) +
  geom_point(aes(maxnumprocessors, eff),
             size = 2, alpha = 0.5)+
  labs(
    x = "num of processors",
    y = "efficiency",
    title = "Job Distribution",
    subtitle = "Sampled Pegasus Job Distribution"
  )

# disconnect from Spark
spark_disconnect(sc)
