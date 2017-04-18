library(sparklyr)

# pick standard spark version on bigfoot
readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

# create spark connection, use default configuration
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = spark_config())

# select database
dbGetQuery(sc, "USE hpcjob")

# create table dataframe from table
job_finish=tbl(sc,"job_finish")

# create user job number report by projects
results <- job_finish %>% 
  filter(username=="nperlin") %>% 
  group_by(projectname) %>% 
  summarise(count=n()) %>% 
  select(projectname, count) %>% 
  collect

# make barplot
barplot(results[[2]], names.arg=results[[1]])

# disconnect from Spark
spark_disconnect(sc)
