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

# Download csv loader jar file

# Parse and Load to Hive Table

# Make Table Available in Impala
