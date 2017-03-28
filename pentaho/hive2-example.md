The Pentaho version on bigfoot is 6.1, released in April, 2016. You should use this installation to access bigfoot hadoop cluster components. This is required by bigfoot kerberos secure cluster configuration. Running Petaho package outside of cluster wont work.

# Start Pentaho Spoon
1. ssh into bigfoot with X11-Forwarding enabled

    For examples in Linux or Mac,
    ```
    $ ssh -X bigfoot.ccs.miami.edu
    ```
    If login from Mac, make sure your local x-server started. XQuartz is an open source x-server on Mac.
2. change to Pentaho directory

    Pentaho is installed on bigfoot user node localy and configured to communicate with bigfoot hadoop cluster components through kerberos.
    ```
    $ cd /opt/data-integration/
    ```
    
3. start spoon

    start spoon from command line in your login session.
    ```
    $ ./spoon.sh
    ```
    Pentaho spoon GUI should start.
# Select Active Shim

Click `Tools` in top menu bar. Click `Hadoop Distributions`. Select `Cloudera CDH 5.5`. Restart Spoon to use the new Shim.

# Congfiguration and Test Run

1. Configure Hadoop Cluster

    * In Pentaho interface, click Jobs in View tab. Right click and the select 'New'. Working space will switch to `Design` tab. 
    * Click `View` to go back. Under `Job 1`, find `Hadoop Cluster`. Right click `New Cluster`.
    * Configure cluster in pop up window.
        * Cluster Name: example 'bigfoot'
        * HDFS section
            * Hostname: name.cluster
            * Port: use default 8020
            * User name and Password are not required. Leave as default.
        * Job Tracker section
            * Hostname: resource.cluster
            * Port: use default 8032
        * ZooKeeper section
            * Host name: name.cluster
            * Port: use default 2181
        * Oozie section
            * Url: http://oozie.cluster:11000/oozie
        
        Click `Test`. All test items should pass. Click `OK` to save the new cluster defination.
2. Configure Hive Database
    * Configure Hive Database connection
        * Under `Job 1`, right click `Database Connection`. Select `New`. Database configuration window pop up.
        * In `General` tab, set the following,
            * Connection name: for example `hivedb`
            * Connection Type: Hadoop Hive2
            * Host name: hive.cluster
            * Database name: for example `hpcjob`
            * Port number: 10000
            * User name and password leave as empty. not used
        * In `Options` tab, add the following parameter.
            * Parameter: principal
            * Value: hive/_HOST@CLUSTER
        * Click `Test` to confirm configuration. Click `OK` to save.
        
        
3. Create Sample Job
    * Switch to `Design` tab
    * Under `General`, click on `Start` and drag to work area on the right.
    * Under `Scripting`, click on `SQL` and drag to work area on the right.
    * Click on `Start` and press down `Shift` key. Drag mouse to `SQL` to create a link
    * Double click `SQL` to configure this task.
        * Job entry name
        * Connection: select the database connection just defined. `hivedb` in this example.
        * SQL Script: use the following example,
        
            ```sql
            drop table if exists user_stats;
            create table user_stats stored as parquet
            as
            select username, count(*) c from job_finish group by username order by c desc;
            ```
     * Click `Run` icon (triangle pointing to right). You will be asked to save job definition. Select your home folder and the input a new folder name.
     * Job starts. Job running progress will be displayed in work flow graph. You can also find other job information in `Execution Results` at the bottom.
        
# Check Results

* Hue
    * Login http://bigfoot-hue.ccs.miami.edu:88888 using your bigfoot user name and password.
    * Under `Query Editor` select `Hive`
    * Select database name, `hpcjob` in this test.
    * You will find the new table you just created from Spoon. Click on it to check its schema.
* Hive Beeline command line

    ```
    $ beeline -u 'jdbc:hive2://hive.cluster:10000/hpcjob;principal=hive/_HOST@CLUSTER'
    > show tables;
    > select * from user_stats limit 5;
    ```
* Spoon
    * On top menu, select `Tools`, select `Database`, then `Explore`.
    * Select the database connection defined earlier, `hivedb` in this example.
    * Check schema and tables. You can even preview tables. Try the new table just created.
    
