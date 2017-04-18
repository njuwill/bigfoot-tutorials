# load RJDBC package
library("RJDBC")

# create driver
drv <- JDBC(driverClass = "com.cloudera.impala.jdbc41.Driver", classPath = list.files("jdbc-driver",pattern="jar$",full.names=T), identifier.quote="`")

# create connection
conn <- dbConnect(drv, "jdbc:impala://n01.cluster:21050/hpcjob;AuthMech=1;KrbRealm=CLUSTER;KrbHostFQDN=n01.cluster;KrbServiceName=impala")

# run query through impala jdbc
projects <- dbGetQuery(conn, "select projectname, count(*) c from job_finish group by projectname order by c desc")
jobs

# barplot user ranking
barplot(projects[[2]][1:20], names.arg=projects[[1]][1:20])

# disconnect from impala jdbc connection
dbDisconnect(conn)
