# copy impala jdbc driver to your home directory
# this sample code assume your local driver folder is /home/USERNAME/jdbc-driver# 
# jdbc-driver is available from bigfoot hdfs storage
# hadoop fs -get /project/hpcjob/jdbc-driver
#

# load RJDBC package
library("RJDBC")

# create driver
drv <- JDBC(driverClass = "com.cloudera.impala.jdbc41.Driver",
                        classPath = list.files("jdbc-driver",pattern="jar$",full.names=T),
                                    identifier.quote="`")
# create connection
conn <- dbConnect(drv, "jdbc:impala://n01.cluster:21050/hpcjob;AuthMech=1;KrbRealm=CLUSTER;KrbHostFQDN=n01.cluster;KrbServiceName=impala")

# sample queries
show_databases <- dbGetQuery(conn, "show databases")
show_databases

jobs <- dbGetQuery(conn, "select count(*) from job_finish")
jobs
