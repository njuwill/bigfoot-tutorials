# Using CSV Serde

This tutorial is to show you how to use CSV serde for data that separates its values with commas, but while at the same time using commas within the data and distinguishing them with quotes.
For example from the sample data used in this tutorial:
```
movieid, title, genre,
...
10, GoldenEye (1995), Action|Adventure|Thriller,
11, "American President, The (1995)", Comedy|Drama|Romance,
12, Dracula: Dead and Loving It (1995), Comedy|Horror,
```

## Sample Data
To make it easier to follow the first time, it is recommend to use the same data provided, this being [ml-latest-small.zip](http://files.grouplens.org/datasets/movielens/ml-latest-small.zip) from [grouplens.org](https://grouplens.org/datasets/movielens/).

First step is to create a folder in bigfoot using the command line.  Let's call it `movies_[your username]` so we don't have any overlaps. So in my case, my username is `sgs93`, so for me it would be `movies_sgs93`.
```
$ hadoop fs -mkdir /project/public/data/movies_sgs93
```
If you ever want to check to make sure you are on track throughout this whole tutorial, you can always use
```
$ hadoop fs -ls [folder/file location]
```
or
```
$ ls -l [folder/file location]
```
and look for it there.

Now we want to download and unzip the sample file we will be using:
```
$ wget http://files.grouplens.org/datasets/movielens/ml-latest-small.zip
$ unzip ml-latest-small.zip
```
And place it in the directory we made on hadoop:
```
$ hadoop fs -put ml-latest-small/movies.csv /project/public/data/movies_sgs93
```
Remember, the directory name should be `movies_[your username]`, not `movies_sgs93` as that is just my example using my username.

## Using Hive to make the Table
Now to open up hive, we use 
```
$ beeline -u 'jdbc:hive2://hive.cluster:10000/default;principal=hive/_HOST@CLUSTER'
```
If this is done correctly, each line is going to start off with `0: jdbc:hive2://hive.cluster:10000/default>`
Now we are going to create the table and call it `movies_[your usename]`:
```
.../default> create external table movies_sgs93 (movieid int, title string, genre string) row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde' stored as textfile location '/project/public/data/movies_sgs93' tblproperties ("skip.header.line.count"="1");
```
What this does is create the table with the parameters you specify that will match with data being used from the location and will also skip any commas used in between quotes.  The last part containing the line `tblproperties ("skip.header.line.count"="1")` skips the first line in the data because in this specific data we are using, the first line is just the title of the columns and is not needed.

We can now see the table under the list of tables using
```
.../default> show tables;
```
and see its parameters using
```
.../default> describe [table name]
```
where `[table name]` is the name you have for your table, so in my case `movies_sgs93`.

We can now run a query on the table, and test to see if the `row format serde` part worked during the creation of the table:
```
.../default> select * from movies_sgs93 limit 15;
```
If done correctly using the sample data provided, the movie title in the same row as movieid `11` should be `American President, The (1995)` which contains a comma in the data and means the table was created properly.

Congratz!

When you are all done with the table, you can drop the table by doing
```
.../default> drop table movies_sgs93;
```
