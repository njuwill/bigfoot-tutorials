# WRITING DATAFRAMES INTO CSV FILES OR EXCEL FILES

## Initial code

Start by copying impala jdbc driver to your home directory as explained on impala-test.R tutorial.

```
# create driver
library(RJDBC)
drv <- JDBC(driverClass = "com.cloudera.impala.jdbc41.Driver", classPath = list.files("jdbc-driver",pattern="jar$",full.names=T), identifier.quote="`")

# create connection
conn <- dbConnect(drv, "jdbc:impala://n01.cluster:21050/hpcjob;AuthMech=1;KrbRealm=CLUSTER;KrbHostFQDN=n01.cluster;KrbServiceName=impala")

```

## Create DataFrame

Once connected, you can create a query to retrieve the desired information you want to save in excel or csv format

```
# create dataframe
cpu_by_user <- dbGetQuery(conn, "select user_name, project, sum(cpu_hours) from hpcjobs.job_finish group by user_name order by sum(cpu_hours) desc")
```

## Writing dataframe to CSV File: 

The file will be saved on your local space. Creating csv files is part of the R package.
```
# csv file
write.csv(cpu_by_user, "cpu_report.csv")
```

## Writing dataframe to Excel File

The file will be saved on your local space. To create an excel file you first need to download the “xlsx” package in R.
```
# downloading package
install.packages("xlsx")

library(xlsx)

# create excel file
write.xlsx(cpu_by_user, "cpu_report.xlsx")

# read in R an excel file. You have to specify the sheet number you want to read besides the name of the file)
read.xlsx("cpu_report.xlsx", 1)
```
