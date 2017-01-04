library(sparklyr)

readRenviron("/usr/lib64/R/etc/Renviron")

library(DBI)
library(dplyr) 

sc <- spark_connect(master = "yarn-client",version = "1.6.0", config = list(default = list(spark.yarn.principal = "USER_NAME@CLUSTER")))

dbGetQuery(sc, "USE hpcjob")

job_finish=tbl(sc,"job_finish")

results <- job_finish %>% 
    filter(username=="zhu") %>% 
    group_by(projectname) %>% 
    summarise(count=n()) %>% 
    select(projectname, count) %>% 
    collect

barplot(results[[2]], names.arg=results[[1]])
