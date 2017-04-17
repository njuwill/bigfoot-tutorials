library(sparklyr)

readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

config <- spark_config()
config$spark.executor.instances <- 40

# replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",
                    version = "1.6.0", 
                    config = config)

# read job_finish from parquet file

pgyr15 = spark_read_csv(sc, "pgyr15", 
                            "/project/public/PGYR15/OP_DTL_GNRL_PGYR2015_P01172017.csv");

# print csv leading records
head(pgyr15)

# print colum names
colnames(pgyr15)

# create user job number report by projects
results <- pgyr15 %>% 
  group_by(Change_Type) %>% 
  summarise(count=n()) %>% 
  select(Change_Type, count) %>% 
  collect


# make barplot
barplot(results[[2]], names.arg=results[[1]])

spark_disconnect(sc)

