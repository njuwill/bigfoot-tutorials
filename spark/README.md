# Spark Tutorials

## Prepare sample data

* download `Complete 2015 Program Year Open Payments Dataset` from [cms.gov](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html) to local computer
* copy zip file to `bigfoot`
    ```
    $ scp PGYR15_P011717.ZIP bigfoot.ccs.miami.edu:
    ```
* login to `bigfoot`
    ```
    $ ssh bigfoot.ccs.miami.edu
    ```
* create a folder and unzip it
    ```
    $ mkdir PGYR15
    $ cd PGYR15
    $ unzip -l ../PGYR15_P011717.ZIP
    $ du -sm .
    6350    .
    ```
    The last command shows the total size of the data after unzipping.
* copy to home directory in `bigfoot`
    ```
    $ cd ..
    $ hadoop fs -put PGYR15
    ```
    This command will push the whole folder to home path inside `bigfoot` `hdfs`. It is then ready for further processing. The folder will be at `/user/USERNAME/PGYR15` in `hdfs`. Make sure you do not have this folder created before. `hadoop fs -put` wont overwrite existing files/directories. We can also specify a specific path as target location. For example, the following command copied data to `/project/public/PGYR15`.
    ```
    $ hadoop fs -put PGYR15 /project/public/
    ```
* check data and practice
    ```
    $ hadoop fs -ls PGYR15
    ```

## Hdfs file management from command line

Practicing data management on bigfoot with hadoop commands

```
# check contents in your home on bigfoot hdfs
$ hadoop fs -ls

# create temporary directory for practicing
$ hadoop fs -mkdir temp

# copy file
$ hadoop fs -cp PGYR2015/OP_DTL_OWNRSHP_PGYR2015_P01172017.csv temp

# check copying result
$ hadoop fs -ls temp

# change file name
$ hadoop fs -mv temp/OP_DTL_OWNRSHP_PGYR2015_P01172017.csv temp/new_file.csv

# copy file in saem folder
$ hadoop fs -cp temp/new_file.csv temp/new_file_copy.csv

# check copying results
$ hadoop fs -ls temp

# download file to your bigfoot home
$ hadoop fs -get temp/new_file.csv

# check file
$ ls -l new_file.csv
$ head new_file.csv
$ tail new_file.csv

# remove temporary file from bigfoot home
$ rm new_file.csv

# download folder
$ hadoop fs -get temp

# check downloading results
$ ls -l temp

# remove temporary folder under your bigfoot home
$ rm -rf temp

# download folder to a single merged file
$ hadoop fs -getmerge temp temp.txt

# check file size
$ ls -l temp.txt

# remove temporary file
$ rm temp.txt

# remove file in hdfs
$ hadoop fs -rm temp/new_file.csv

# check files in hdfs temp folder
$ hadoop fs -ls temp

# remove temporary folder on bigfoot hdfs home
$ hadoop fs -rm -r temp

# check remote hdfs home, temporary folder should be gone
$ hadoop fs -ls
```

Remove sample data on remote home to save space. The same sample data is available at `/project/public/PGYR15`.

```
$ hadoop fs -rm -r public/PGYR15
$ hadoop fs -ls
```

# Spark Quick Start

On `bigfoot` command line, start python `spark` shell.

```
$ pyskark
```

Wait for prompt `>>>`. Run a simple task to count number of lines of a text file from sample dataset.

```
>>> f = sc.textFile('/project/public/PGYR15/OP_PGYR2015_README_P01172017.txt')
>>> f.count()
...
17/04/06 11:27:09 INFO scheduler.DAGScheduler: ResultStage 0 (count at <stdin>:1) finished in 0.509 s
17/04/06 11:27:09 INFO scheduler.DAGScheduler: Job 0 finished: count at <stdin>:1, took 0.594611 s
40
>>> exit()
```

This `spark` session runs interactively and locally on `bigfoot` local. When input file size becomes big, a better way and it is always recommended is to run through `yarn` and cluster compute nodes. Now try a bigger file with more cpus.

```
$ pyspark --master yarn --num-executors 5
```

It will take longer time to get the prompt. This example uses 5 cpus. When you request more cpus, it may take a little more time to get all computing container set up. Once the prompt is ready, run the same task as above.

```
>>> f = sc.textFile('/project/public/PGYR15/OP_DTL_RSRCH_PGYR2015_P01172017.csv')
>>> f.count()
...
17/04/06 11:35:37 INFO cluster.YarnScheduler: Removed TaskSet 0.0, whose tasks have all completed, from pool 
17/04/06 11:35:37 INFO scheduler.DAGScheduler: Job 0 finished: count at <stdin>:1, took 4.471564 s
762574
>>> exit()
```

Running task in interactive mode is good for debugging and quick testing, not good for big and complicated tasks. It will be better to have a script to include all the analysis logics and submit it to class and let job scheduler to finish task by itself. Some tasks will take hours, even days to finish.

Create job script using your favoriate editor on bigfoot home, or download the script from `/project/public/`.

```
$ hadoop fs -get /project/public/spark-quick-start.py
$ cat spark-quick-start.py
```

Submit job to cluster.

```
$ spark-submit --master yarn --num-executors 5 spark-quick-start.py
```

Again, lots of information. When job finished, you should be able find the output somewhere buried in those lines. 

```
...
17/04/06 11:57:23 INFO cluster.YarnScheduler: Removed TaskSet 0.0, whose tasks have all completed, from pool 
17/04/06 11:57:23 INFO scheduler.DAGScheduler: Job 0 finished: count at /home/zhu/tests/bigfoot-tutorials/spark/spark-quick-start.py:10, took 3.965641 s
total number of lines counted: 762574
17/04/06 11:57:23 INFO spark.SparkContext: Invoking stop() from shutdown hook
17/04/06 11:57:23 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/metrics/json,null}
...
17/04/06 11:57:23 INFO util.ShutdownHookManager: Shutdown hook called
17/04/06 11:57:23 INFO util.ShutdownHookManager: Deleting directory /tmp/spark-6bc7152e-936a-4296-a000-eeb500b163fc
17/04/06 11:57:23 INFO util.ShutdownHookManager: Deleting directory /tmp/spark-6bc7152e-936a-4296-a000-eeb500b163fc/pyspark-f118ed6b-d0e3-4e4e-bbb0-61ddada9b742
```


