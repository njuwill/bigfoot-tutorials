# Download sample csv file

This demo use a sample csv data file from [https://support.spatialkey.com/spatialkey-sample-csv-data/]. Find 'Real Estate Transactions', and click the download link to download sample data to your local computer.

You can download from command line using `wget` or `curl`. 
```
wget http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv
```

# Copy data to bigfoot HDFS

We are going to run Spark job to load data to Impala. The tool we are going to use will read data from `HDFS` storage. There are two ways to load data to `HDFS`.

## Use bigfoot home as staging space

You can transfer data first to your home directory on bigfoot. Then use hadoop command to push it to `HDFS`. The advantage is that you can handle big data file easily.

### copy data to bigfoot home

This can be done either with Linux/Mac command line, or Filezilla from Windows

* from command line

    You can use `scp`, `sftp` or other command line data transfer commands.

    ```
    scp Sacramentorealestatetransactions.csv bigfoot.ccs.miami.edu:
    ```

* from Windows

    Filezilla is a nice application to transfer data through network on Windows. 
    
    Make sure you used `sftp://bigfoot.ccs.miami.edu` in target server address.

### push data to hdfs

Upload data to hdfs using hadoop command.

```
hadoop fs -put Sacramentorealestatetransactions.csv
```

This will keep the same file name in hdfs. If you would like to change file name, add new name in the end of the command.

```
hadoop fs -put Sacramentorealestatetransactions.csv realestatetransactions.csv
```

## Use Hue web interface

When data size is not big, another convenient way to upload data to hdfs is through Hue web interface. After login Hue web site, on top right, find `File Browser`. Click on it. Then you will find `Upload`. Click on it and select Files. Follow instruction to finish uploading. 

If you want to change file name after uploading, you can do it from bigfoot command line.

```
hadoop fs -mv Sacramentorealestatetransactions.csv realestatetransactions.csv
```

# Download csv loader jar file

Download file `loadcsv.jar` from current folder to your local computer. Then upload it to your bigfoot home. This file is also available from bigfoot bigfoot hdfs. It is located under `/project/public`. You can download it in command line to your bigfoot home.

```
hadoop fs -get /project/public/loadcsv.jar
```

# Parse and Load to Hive Table

Submit a Spark job to parse and load the sampe csv to impala in a new table. Here are two examples. Both use [databricks csv package](https://github.com/databricks/spark-csv) to parse csv files to data frame and then save it to Hive using Spark HiveContext.

The first example uses a jar file, `loadcsv.ja`, which is programmed in Scala and compiled using sbt.

```
spark-submit --master yarn --num-executors 40 --class LoadCsv loadcsv.jar -t realestatetransactions -d default -f ',' --quote '"' -s true Sacramentorealestatetransactions.csv
```
The second example is programmed in Python. You can find the source code `load_csv_with_sparksql.py` from this repository. You will also need databrick csv library, `spark-csv-assembly-1.4.0.jar`, which is also available from this reposity. Once you have these two files ready, run the following command to submit spark job to load csv to Hive.

```
spark-submit --master yarn-client --num-executors 5 --executor-cores 1 --jars spark-csv-assembly-1.4.0.jar load_csv_with_sparksql.py
```

You can adjust the arguments depends on your source data file. This examples above uses 40 and 5 executors. 

The new table is called `realestatetransactions` in `default` database on bigfoot. This table is now available in `Hive`. The table is create in `parquet` format . You can try the following to access it from command line.

```
$ beeline -u 'jdbc:hive2://hive.cluster:10000/default;principal=hive/_HOST@CLUSTER'
...
0: jdbc:hive2://hive.cluster:10000/default> show tables;
0: jdbc:hive2://hive.cluster:10000/default> select count(*) from realestatetransactions;
+------+--+
| _c0  |
+------+--+
| 982  |
+------+--+
1 row selected (26.096 seconds)

```
When query finishes, run `!q` to exit from beeline.

# Make Table Available in Impala

Even though Impala and Hive share the same data file and meta data, you will need to notify Impala for this new table before you can use it. From command line,

```
impala-shell -k -i n01 -d default

[n01:21000] > invalidate metadata realestatetransactions;
Query: invalidate metadata realestatetransactions

Fetched 0 row(s) in 0.10s
```
Run simple query and exit.
```
[n01:21000] > select count(*) from realestatetransactions;
Query: select count(*) from realestatetransactions
+----------+
| count(*) |
+----------+
| 982      |
+----------+
Fetched 1 row(s) in 3.48s
[n01:21000] > exit;
```
Or do this from Hue interface. 
