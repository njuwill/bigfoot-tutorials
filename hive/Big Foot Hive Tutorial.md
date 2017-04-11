# Bigfoot Hive Tutorial

## Download Sample Data

Download sample data from [grouplearns.org](https://grouplens.org/datasets/movielens/). The data set we are going to use in this tutorial is [ml-100k.zip](http://files.grouplens.org/datasets/movielens/ml-100k.zip). 

First create folder on `bigfoot` to host sample data. Create two folders under `/project/public/data/`. Use your user name in each of the folder names. Replace `USERNAME` with your `bigfoot` user name.

* `USERNAME_rating`
* `USERNAME_user`

There are two ways to download and transfer to `bigfoot` `hdfs`.

* On local machine
    * click to link to download to local machine
    * Unzip it to a folder called `ml100k.zip`. Downloaded file may have been unzipped automatically.
    * Login `Hue` and upload `u.user` to `USERNAME_user`, upload `u.data` to `USERNAME_rating`
* On `bigfoot` login server
    ```
    $ wget http://files.grouplens.org/datasets/movielens/ml-100k.zip 
    $ unzip ml-100k.zip
    $ hadoop fs -put u.data /project/public/data/USERNAME_rating/
    $ hadoop fs -put u.user /project/public/data/USERNAME_user/
    ```

## Create tables from `BeeLine CLI`.

* Login `bigfoot.ccs.miami.edu` if you are not there.
* Start `BeeLine CLI`
    
    ```
    $ beeline -u 'jdbc:hive2://hive.cluster:10000/default;principal=hive/_HOST@CLUSTER'
    ```
* Create external tables  
    ```
    > create external table USERNAME_rating (userid INT, movieid INT, rating INT, unixtime STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE location '/project/public/data/USERNAME_rating';
    > create external table USERNAME_user (userid INT, age INT, gender STRING, occupation STRING, zipcode STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' STORED AS TEXTFILE location '/project/public/data/USERNAME_user';
    > show tables;
    > describe USERNAME_rating;
    > describe USERNAME_user;
    ```
* Run Queries
    ```
    > select * from USERNAME_rating limit 5;
    > select count(*) from USERNAME_rating;
    > select count(distinct userid) from USERNAME_rating;
    > select userid, avg(rating) c from USERNAME_rating group by userid order by c desc limit 5;
    ```
* Drop tables
    ```
    > drop table USERNAME_rating;
    > drop table USERNAME_user;  
    ```
* Quit `BeeLine CLI`

    ```
    > !q
    ```

Check data files

```
$ hadoop fs -ls /project/public/data/USERNAME_rating
$ hadoop fs -ls /project/public/data/USERNAME_user;
```

Move data file up one level and delete folders
```
$ hadoop fs -mv /project/public/data/USERNAME_rating/u.data /project/public/data/rating_USERNAME
$ hadoop fs -rm -r /project/public/data/USERNAME_rating
$ hadoop fs -mv /project/public/data/USERNAME_user/u.user /project/public/data/user_USERNAME
$ hadoop fs -rm -r /project/public/data/USERNAME_user
```

## Create Tables in Hue

* Login `http://bigfoot-hue.ccs.miami.edu:8888'
* Click on `Data Browsers` on top menu
* Click on `Metastore Tables` on drop down menu
* Navigate to database `default` in left panel
* On the right side, click  icon`Create a new table from a file`
* Input table name `USERNAME_rating`
* Select `/project/public/data/rating_USERNAME` as source file
* Click `Next`
* Change column names to `userid`, `moveid` and `rating` on second page
* Continue to last page to create table
* Repeat same procedure to create table `USERNAME_user` from source file `/project/public/data/user_USERNAME`. Change default field delimiter to '|'. Use column names `userid`, `age`, `gender`, `occupation` and `zipcode`. Change `zipcode` data type to string.
