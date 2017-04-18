# load sparklyr package
library(sparklyr)

# update r environment (SPARK_HOME updated)
readRenviron("/usr/lib64/R/etc/Renviron")

# load DBI package
library(DBI)

# initialize spark context, replace USER_NAME with your bigfoot user name
sc <- spark_connect(master = "yarn-client",version = "1.6.0")

# query hive table, count finished hpc jobs
test <- dbGetQuery(sc, 'Select count(*) from hpcjob.job_finish')

# query through sparksql, rank job numbers by group
rank <- dbGetQuery(sc, 'select gid, count(*) c from 
                       (select gid, jobid from job_finish j join
                       (select uid, gid from pegasus_users u join pegasus_groups g where u.gidnumber = g.gidnumber) a 
                       where j.username = a.uid)
                       b group by gid order by c desc')

# barplot user ranking
barplot(rank[[2]][1:20], names.arg=rank[[1]][1:20])

spark_disconnect(sc)
