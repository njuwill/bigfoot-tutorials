library(sparklyr)

readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)

# load dplyr, a package to help data frame manipulation
library(dplyr) 

# replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",version = "1.6.0", config = list(default = list(spark.yarn.principal = "USER_NAME@CLUSTER")))

# select database
dbGetQuery(sc, "USE hpcjob")

# create table dataframe
job_finish=tbl(sc,"job_finish")

# create user job number report by projects
results <- job_finish %>% 
    filter(username=="zhu") %>% 
    group_by(projectname) %>% 
    summarise(count=n()) %>% 
    select(projectname, count) %>% 
    collect

# make barplot
barplot(results[[2]], names.arg=results[[1]])