# Spark Tutorials

## Prepare sample data

* download `Complete 2015 Program Year Open Payments Dataset` from [cms.gov](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html) to local computer. 

This file is zipped, but still has big size. There a smaller version available from `bigfoot` hdfs at `/project/public/PGYR15_P011717.ZIP`. You can login `hue.ccs.miami.edu:8888` to download it to your local machine to use in this tutorial.

* copy zip file to `bigfoot`
    ```
    $ scp PGYR15_P011717.ZIP bigfoot.ccs.miami.edu:
    ```
* login to `bigfoot`
    ```
    $ ssh bigfoot.ccs.miami.edu
    ```
    This command will your local user account name on your local machine to login bigfoot. If you use a different account name on your local machine than `bigfoot`, add your account name in this command.
    ```
    $ ssh BIG_FOOT_USER_NAME@bigfoot.ccs.miami.edu
    ```
* create a folder and unzip it
    ```
    $ mkdir PGYR15
    $ cd PGYR15
    $ unzip ../PGYR15_P011717.ZIP
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
    $ hdfs fsck -locations -blocks -files /project/public/PGYR15/OP_DTL_OWNRSHP_PGYR2015_P01172017.csv
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

Create job script `spark-quick-start.py` using your favoriate editor on bigfoot home, or download it from github.com.

```
$ wget https://raw.githubusercontent.com/zongjunhu/bigfoot-tutorials/master/spark/spark-quick-start.py

--2017-04-06 12:03:21--  https://raw.githubusercontent.com/zongjunhu/bigfoot-tutorials/master/spark/spark-quick-start.py
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 192.30.253.112, 192.30.253.113
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|192.30.253.112|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: ‘spark-quick-start.py’

    [ <=>                                                                                                                                                                                                 ] 34,722      --.-K/s   in 0.009s  

    2017-04-06 12:03:21 (3.73 MB/s) - ‘spark-quick-start.py’ saved [34722]

$ cat spark-quick-start.py
```

If the file you downloaded is not right, you can download it from `/project/public/spark-quick-start/` on `bigfoot`.

```
$ hadoop fs -get /project/public/spark-quick-start/spark-quick-start.py
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

Create or download `spark-quick-start-word-count.py` from github `https://raw.githubusercontent.com/zongjunhu/bigfoot-tutorials/master/spark/spark-quick-word-count.py`. Then submit it to cluster.

```
$ spark-submit --master yarn --num-executors 5 spark-quick-start-word-count.py
...
17/04/06 12:32:54 INFO scheduler.DAGScheduler: ResultStage 7 (runJob at PythonRDD.scala:393) finished in 0.076 s
17/04/06 12:32:54 INFO scheduler.DAGScheduler: Job 3 finished: runJob at PythonRDD.scala:393, took 0.172601 s
max line length:  155
top 5 words: 
the 63
of 26
in 25
that 21
data 20
17/04/06 12:32:54 INFO spark.SparkContext: Invoking stop() from shutdown hook
17/04/06 12:32:54 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/metrics/json,null}
17/04/06 12:32:54 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/stages/stage/kill,null}
...
```
The `cache()` function is used to avoid reading input files twice. 

When you have big output, or you just simply need the output go to a file, instead on screen, use `saveAsTextFile` function to save results to `hdfs`. Create `spark-quick-start-hdfs-out.py` or download it from github `https://raw.githubusercontent.com/zongjunhu/bigfoot-tutorials/master/spark/spark-quick-start-hdfs-output.py`. Then run as a `spark` job.

```
$ spark-submit --master yarn --num-executors 5 spark-quick-start-hdfs-output.py
```

Lots of message fly, but not word list in screen output. Check you home in hdfs.

```
$ hadoop fs -ls
...
drwxr-xr-x   - zhu hadoop          0 2017-04-06 12:44 quick-start-word-count
...
$ hadoop fs -ls quick-start-word-count
Found 3 items
-rw-r--r--   3 zhu hadoop          0 2017-04-06 12:44 quick-start-word-count/_SUCCESS
-rw-r--r--   3 zhu hadoop       2084 2017-04-06 12:44 quick-start-word-count/part-00000
-rw-r--r--   3 zhu hadoop       3559 2017-04-06 12:44 quick-start-word-count/part-00001
```

Download results and check locally.

```
$ hadoop fs -getmerge quick-start-word-count quick-start-word-count.txt
$ cat quick-start-word-count.txt
$ rm quick-start-word-count.txt
$ hadoop fs -rm -r quick-start-word-count
```

When result file is small, you can get these down in a single `spark` task. You can use [spark-quick-start-local-output.py](https://raw.githubusercontent.com/zongjunhu/bigfoot-tutorials/master/spark/spark-quick-start-local-output.py) for testing.

```
$ spark-submit --master yarn --num-executors 5 spark-quick-start-local-output.py
```

After job finish, the results will be saved in your current work directory as `quick-start-work-count.txt`

```
$ ls -l quick-start-work-count.txt
$ cat quick-start-work-count.txt
$ rm quick-start-work-count.txt
```

## Spark Join Example

We are going to use `Pegasus` system log to count the number of times a user group has logged in. Input files are available in `bigfoot`.

* /project/public/pegasus_log_sample/
    
    system log samples

* /project/public/pegasus_log_sample_user_group_map.txt

    user group mapping

Create script `spark-quick-start-join.py` or download it from github `https://raw.githubusercontent.com/zongjunhu/bigfoot-tutorials/master/spark/spark-quick-start-join.py`. Submit script to cluster.

```
$ spark-submit --master yarn --num-executors 5 spark-quick-start-join.py
...
17/04/06 14:23:02 INFO scheduler.DAGScheduler: ResultStage 3 (collect at /home/zhu/tests/bigfoot-tutorials/spark/spark-quick-start-join.py:22) finished in 0.239 s
17/04/06 14:23:02 INFO scheduler.DAGScheduler: Job 0 finished: collect at /home/zhu/tests/bigfoot-tutorials/spark/spark-quick-start-join.py:22, took 4.402998 s
mihganlst 1
cchem 2
lin 3
mapes 2
iskandarani 6
zuidema 25
cms 6
adr 2
mihg 1
lembix 12
ccsuser 21
17/04/06 14:23:02 INFO spark.SparkContext: Invoking stop() from shutdown hook
17/04/06 14:23:02 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/metrics/json,null}
```

The number of times group users logged in `pegasus` is printed out on screen.

## Amazon Review Sample Data

Amazon released lots of interesting [review dataset](http://jmcauley.ucsd.edu/data/amazon/) for research purpose and it is a great source to use to learn spark. Here is a sample session to use one of the review data to run a sample Spark job.

* download data on `Bigfoot` to user home
    ```
    $ wget http://snap.stanford.edu/data/amazon/productGraph/categoryFiles/reviews_Books_5.json.gz
    $ ls -l reviews_Books_5.json.gz
    -rw-r--r--  1 zhu sysuser 3.1G Aug 11 01:17 reviews_Books_5.json.gz
    ```
* unzip file
    ```
    $ gunzip reviews_Books_5.json.gz
    $ ls -lh reviews_Books_5.json
    -rw-r--r-- 1 zhu sysuser 8.9G Aug 11 01:17 reviews_Books_5.json
    ```
* check json structure
    ```
    $ head -n 1 reviews_Books_5.json
    ```
    ```json
    {"reviewerID": "A10000012B7CGYKOMPQ4L", "asin": "000100039X", "reviewerName": "Adam", "helpful": [0, 0], "reviewText": "Spiritually and mentally inspiring! A book that allows you to question your morals and will help you discover who you really are!", "overall": 5.0, "summary": "Wonderful!", "unixReviewTime": 1355616000, "reviewTime": "12 16, 2012"}
    ```
* upload to `Bigfoot` `HDFS`
    ```
    $ hadoop fs -put reviews_Books_5.json /project/public/spark-workshop/amazon_reviews_Books_5.json
    $ hadoop fs -ls  /project/public/spark-workshop/amazon_reviews_Books_5.json
    -rw-r--r--   3 zhu hadoop 9458009255 2017-08-11 10:18 /project/public/spark-workshop/amazon_reviews_Books_5.json
    ```
* run sample Spark Job. Result is written back to `HDFS`.
    ```
    $ spark-submit --master yarn --num-executors 20 amazon_book_review.py
    ```
* check and download results
    ```
    $ hadoop fs -ls amazon_book_review
    Found 49 items
    -rw-r--r--   3 zhu hadoop          0 2017-08-11 10:58 amazon_book_review/_SUCCESS
    -rw-r--r--   3 zhu hadoop      58833 2017-08-11 10:58 amazon_book_review/part-00000
    -rw-r--r--   3 zhu hadoop      69645 2017-08-11 10:58 amazon_book_review/part-00001
    ...
    ...
    -rw-r--r--   3 zhu hadoop       9482 2017-08-11 10:58 amazon_book_review/part-00046
    -rw-r--r--   3 zhu hadoop          0 2017-08-11 10:58 amazon_book_review/part-00047
    
    $ hadoop fs -getmerge amazon_book_review amazon_book_review.txt
    
    $ head amazon_book_review.txt
    (u'Amazon Customer', 295436)
    (u'Kindle Customer', 37961)
    (None, 25546)
    (u'Harriet Klausner', 23212)
    (u'Midwest Book Review', 16090)
    (u'Avid Reader', 6043)
    (u'Bookreporter', 5878)
    (u'Lisa', 4558)
    (u'Linda', 4340)
    (u'Jennifer', 4286)
    ```
* load json as table in `Bigfoot` Hive and Impala
    ```
    $ spark-submit --master yarn --num-executors 20 amazon_book_review.table.py
    ```

    
