# data source: http://stat-computing.org/dataexpo/2009/the-data.html
# year 2008

library(sparklyr)
library(ggplot2)
library(dplyr) 

readRenviron("/usr/lib64/R/etc/Renviron")

# load dplyr, a package to help data frame manipulation

config <- spark_config()
config$spark.executor.instances <- 20

# replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = config)

# read job_finish from parquet file

air = spark_read_parquet(sc, "air", 
                            "/user/hive/warehouse/air_2008");

delay <- air %>% 
  group_by(tailnum) %>%
  summarise(count = n(), dist = mean(distance), delay = mean(arrdelay)) %>%
  filter(count > 20, dist < 2000, !is.na(delay)) %>%
  collect

# plot delays
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area(max_size = 2)

#air_collect <-air %>% summarise(count=n()) %>% collect


# disconnect from Spark
spark_disconnect(sc)

