# Bigfoot Hive Tutorial

## Download Sample Data

Download sample data from [grouplearns.org](https://grouplens.org/datasets/movielens/). The data set we are going to use in this tutorial is [ml-100k.zip](http://files.grouplens.org/datasets/movielens/ml-100k.zip). 

First create folder on `bigfoot` to host sample data. Create two folders under `/project/public/data/`. Use your user name in each of the folder names. Replace `USERNAME` with your `bigfoot` user name.

* `USERNAME_rating`
* `USERNAME_user`

On bigfoot command line,

```
$ hadoop fs -mkdir /project/public/data/USERNAME_rating
$ hadoop fs -mkdir /project/public/data/USERNAME_user
```

Or from `Hue` web interface.

There are two ways to download and transfer to `bigfoot` `hdfs`.

* On local machine
    * click to link to download to local machine
    * Unzip it to a folder called `ml100k.zip`. Downloaded file may have been unzipped automatically.
    * Login `Hue` and upload `u.user` to `USERNAME_user`, upload `u.data` to `USERNAME_rating`
* On `bigfoot` login server
    ```
    $ wget http://files.grouplens.org/datasets/movielens/ml-100k.zip 
    $ unzip ml-100k.zip
    $ hadoop fs -put ml-100k/u.data /project/public/data/USERNAME_rating/
    $ hadoop fs -put ml-100k/u.user /project/public/data/USERNAME_user/
    ```

## Create tables from `BeeLine CLI`.

We are going to create 2 sample external tables in this section.

* Login `bigfoot.ccs.miami.edu` if you are not there.
* Start `BeeLine CLI`
    
    ```
    $ beeline -u 'jdbc:hive2://hive.cluster:10000/default;principal=hive/_HOST@CLUSTER'
    ```
* Create external tables  
    ```sql
    > create external table USERNAME_rating (userid INT, movieid INT, rating INT, unixtime STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE location '/project/public/data/USERNAME_rating';
    > create external table USERNAME_user (userid INT, age INT, gender STRING, occupation STRING, zipcode STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE location '/project/public/data/USERNAME_user';
    > show tables;
    > describe USERNAME_rating;
    > describe USERNAME_user;
    ```
    When tables created, source data files are not modified or relocated.
* Run Queries
    ```sql
    > select * from USERNAME_rating limit 5;
    > select count(*) from USERNAME_rating;
    > select count(distinct userid) from USERNAME_rating;
    > select userid, avg(rating) c from USERNAME_rating group by userid order by c desc limit 5;
    ```
* Drop tables
    ```sql
    > drop table USERNAME_rating;
    > drop table USERNAME_user;  
    ```
* Quit `BeeLine CLI`

    ```
    > !q
    ```

Since these are external tables, dropping table will not delete data files. Check data files

```
$ hadoop fs -ls /project/public/data/USERNAME_rating
$ hadoop fs -ls /project/public/data/USERNAME_user
```
We are going to create managed tables in next section. On bigfoot, because of the access control settings, data can only be loaded to managed table from `/project/public/data`. Therefore, let's move data file up one level and delete folders. 
```
$ hadoop fs -mv /project/public/data/USERNAME_rating/u.data /project/public/data/rating_USERNAME
$ hadoop fs -rm -r /project/public/data/USERNAME_rating
$ hadoop fs -mv /project/public/data/USERNAME_user/u.user /project/public/data/user_USERNAME
$ hadoop fs -rm -r /project/public/data/USERNAME_user
```

## Create Tables in Hue

Creating tables from `Hue` is limited to users with administrator privileges. Therefore procedures in this section may not work for you. Use instruction for command line instead.

* Login `http://bigfoot-hue.ccs.miami.edu:8888'
* Click on `Data Browsers` on top menu
* Click on `Metastore Tables` on drop down menu
* Navigate to database `default` in left panel
* On the right side, click  icon`Create a new table from a file`
* Input table name `USERNAME_rating`
* Select `/project/public/data/rating_USERNAME` as source file
* Click `Next`
* Accept default delimiter '\t'
* Click `Next`
* Change column names to `userid`, `moveid`, `rating` and `unixtime` on second page
* Click `Create Table`
* Repeat same procedure to create table `USERNAME_user` from source file `/project/public/data/user_USERNAME`. 
* Change default field delimiter to `other`, then type in '|'. Click `Preview`. Click `Next`. 
* Use column names `userid`, `age`, `gender`, `occupation` and `zipcode`. Change `zipcode` data type to string.
* Click 'Create Table`.
* Check left side panel, two new tables should be available.

Now get two managed tables created with data loaded. Your data files under `/project/public/data` will be relocated to `/user/hive/warehouse/`. Run the following command to find your tables.

```
$ hadoop fs -ls /user/hive/warehouse
```
We can use them to practice SQL queries.

## Transform Table File Format

You can create new table from old table with new format. Run the following from `Hue` query editor or from `BeeLine CLI`. ';' is not required in `Hue` query editor.

```sql
create table USERNAME_rating_parquet stored as parquet as select * from USERNAME_rating;
```
You can run similar query as the table in `TEXTFORMAT`, or join tables between them. Once you get `parquet` formatted tables, they can be accessed from `Impala` as well.

## Drop Tables

After finish query, they can be dropped either from `Hue` query editor or `BeeLine CLI` with `drop` command. ';' is not required in `Hue` query editor. Table can be dropped from `Metastore Tables` on `Hue` as well.

```sql
drop table USERNAME_rating;
drop table USERNAME_user;
drop table USERNAME_rating_parquet;
```
## Collection Types

The queries below tested in `hpcjob` database using `BeeLine CLI` or `Hue` query editor. To switch to `hpcjob` database from `BeeLine CLI`, run the following in a live session.

```
use hpcjob;
```

or switch in `Hue` query editor.

';' is optional in query editor.

```sql
-- check table schema
describe job_finish;

-- check STRUCT column field
select lsfrusage.utime, lsfrusage.stime from job_finish limit 5;

-- count size of ARRAY column field
select jobid, size(exechosts) from job_finish limit 5;

-- use ARRAY in where condition
select username, jobid from job_finish where array_contains(exechosts, 'n340.pegasus.edu') limit 5;
```
