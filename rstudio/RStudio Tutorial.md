# Bigfoot RStudio Server Tutorial

## Access RStudio Server

Access to RStudio Server on `Bigfoot` cluster is available for campus users, either locally connected to campus network, or remote into campus network through university VPN.

Please use your web browser to login `bigfoot` RStudio Server as the following,

* url: http://bdrstudio.ccs.miami.edu:8787
* credentials: `bigfoot` user name and password

After you login, you will see a work environment as the following,

1. Edit: upper section on the left side. 
2. Console: lower section on the left side
3. Environment: upper section on the right side
4. Plotting and other resources: lower section on the right

The `Edit` section may not appear until you have created/opened a file for editing.

## Bigfoot Kerberose Authentication

In order to access resources (data files, databases) on bigfoot from your R session, you need authenticate to `bigfoot` `kerberos` server to receive a ticket. This is required only when you want to access `bigfoot` resource in your computing task. If you run R tasks on `RStudio Server` itself, this is not necessary.

Please follow the steps below to gain `kerberos` ticket for your R session.

1. On top menu bar, find `Tool` and click.
2. Click on `Shell` in dropdown menu.
3. In the popup window, type in `kinit`. Answer with your `bigfoot` password. Quiet response means success.
4. Click `Close` on the popup window to finish.

Once you have gained this ticket, it is going to be valid for all your future activities in your login session. You can always redo this procedure to refresh your `kerberos` ticket when something goes wrong and there is any authentication issue.

## Logout or Start New R session

On top right of the web page, there are two icons to let you logout or quick from existing R session.

* Logout will get you out of your `RStudio Server` login session, but your R session will be kept.
* When things go wrong, you can start a new R session without logging out. When existing R session is cancelled, you will be asked to create a new session. You will lose your resources in your old session to have a clean start.

## Impala JDBC Driver

When querying through `impala` `jdbc` connection, `impala` `jdbc` driver is required. Down the the driver from `bigfoot` hdfs to your home directory. 

From bigfoot `ssh` command line, 

```
hadoop fs -get /project/public/jdbc-driver
```

## Spark Comments

### Spark versions

The standard Spark installation on `bigfoot` is version 1.6.0. It works for most of the sample cases in this tutorial. However, package `dplyr` requires Spark version 2.0.0 and above to make data frame joins. Therefore a few of the sample R script uses a separated new Spark version 2.0.2 for computing. Please make sure you pick up the right Spark version in your own tasks.

In order to use the new Spark version, in R script, the following is required.

```R
# point Spark to new version
Sys.setenv(SPARK_HOME="/opt/spark-2.0.2-bin-hadoop2.6")
Sys.setenv(HADOOP_CONF_DIR="/etc/hadoop/conf")

# comment out the configuration for standard Spark
# readRenviron("/usr/lib64/R/etc/Renviron")
```

### Spark executor number

When Spark reads data files directly from HDFS, no matter the format of the file itself, if the file is big, usually more cpus are required to gain performance. In some of the sample R script, task asks 40 executors for computing. Since there is a hard limit on total cpu number in bigfoot, too many jobs like this will compete for resource. It is recommended not to try too many similar cases with 40 cpus at the same time on cluster. Either use a smaller number, 6 for example, or try those jobs at different time.  

## Edit R Script and Other Files

On the lowser section on the right side, there is a `File` tab. Click on it to review your files on your `bigfoot` home folder. You can navigate to other sub-folders as well. You can click on A R script or other text file for editing. File will be openned on the upper `Edit` section on the left side. You can also select a file by clicking on the check box on the left to the file name. Then you are able to copy, delete or rename it.

To create a new file, either a R script or any other text file, click `File` on top menu and select `New File`. Select the type of file you are going to create. Then you will have an empty file open for your editing in the `Edit` section. Once editing is finished, you can click the `Save` button to save to a file in your `bigfoot` home. You will be asked for a path.

## Run Sample Tasks

There are two ways to run R script

* Run script in `console` section interactively.
* Open R script in `Edit` section and the run it in batch mode.

In batch mode, your script will be run from the beginning to the end without interruption. The lines in your script will be played sequentially in `console` section. If there is error occurs, your script will stop at the error step in `console` section and wait for your input.

Here are a list of sample R scripts to for your to try big data tasks on `bigfoot`. Most of the examples below use ***hpcjob*** database. Please change database name to ***default*** to query tables you created in `hive` and `impala` tutorials.

* dplyr-csv.R
    
    Open a 6G csv file through Spark and query it as a data frame. Create group counts in a bar plot. 40 executors requested.
    
* dplyr-hpc-jobs.R

    Open json files and parquet database table file from Spark and join them to generate a HPC job counts report by groud id. Requires Spark 2.0.x. 40 executors requested.

* dplyr-json-join.R

    Read json files with Spark and join them to get a user counts by group id. Make a bar plot. This is part of the tests for `dplyr-json-join.R`. Requires Spark 2.0.x.
    
* dplyr-json.R

    Read json files with Spark, check data frame schema.

* dplyr-parquet.R

    Load parquet data file from Hive warehouse and process it as a data frame. Use aggregation to create HPC job report for a user by projects. 40 executors requested.
    
* dplyr-test.R

    Query data base table through Spark and DBI. Generate user job count report by projects.
    
* impala-plot.R

    Fast query on a single big table to create project job counting report. Make a barplot to present the results.

* impala-test.R

   Very basic `impala` `jdbc` test for R. Show database table list and total job number count.
   
* sparklyr-test.R

    Open table through Spark and run query to create project job count. Present results with bar plot.
    
* impala-hpc-job.R

    Use `impala` `jdbc` driver to do a 3 table join. Create HPC job count report by groups. Present results using bar plot. This is a faster version for `dplyr-hpc-jobs.R`.

