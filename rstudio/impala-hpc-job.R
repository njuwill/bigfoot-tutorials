# load RJDBC package
library("RJDBC")

# create driver
drv <- JDBC(driverClass = "com.cloudera.impala.jdbc41.Driver", 
            classPath = list.files("jdbc-driver",pattern="jar$",full.names=T), 
            identifier.quote="`")

# create connection
conn <- dbConnect(drv, "jdbc:impala://n01.cluster:21050/hpcjob;AuthMech=1;KrbRealm=CLUSTER;KrbHostFQDN=n01.cluster;KrbServiceName=impala")

# run impala query to generate group job number count ranking
jobstats <- dbGetQuery(conn, "select gid, count(*) c from 
                       (select gid, jobid from job_finish j join
                       (select uid, gid from pegasus_users u join pegasus_groups g where u.gidnumber = g.gidnumber) a 
                       where j.username = a.uid)
                       b group by gid order by c desc")

# barplot user ranking
barplot(jobstats[[2]][1:20], names.arg=jobstats[[1]][1:20])

# disconnect jdbc connection
dbDisconnect(conn)
