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
  mutate(eff = (utime+stime)/(maxnumprocessors*(unix_timestamp(endtime)-unix_timestamp(starttime)))) %>%
  na.omit() %>%
  group_by(username) %>%
  summarise(count=n(), ncpu = mean(maxnumprocessors), neff = mean(eff) ) %>%
  filter(count > 10, neff < 10, ncpu<50)

# print job distributions
job_eff %>%
  collect %>%
  ggplot(aes(ncpu, neff)) +
  geom_point(aes(ncpu, neff),
             size = 2, alpha = 0.5)+
  geom_smooth() +
  labs(
    x = "num of processors",
    y = "efficiency",
    title = "User Job Distribution",
    subtitle = "Sampled Pegasus Job Distribution"
  )

# disconnect from Spark
spark_disconnect(sc)
