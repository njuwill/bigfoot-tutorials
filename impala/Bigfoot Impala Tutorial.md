# Bigfoot Impala Tutorial

## Prepare Sample Data

This tutorial use the same sample data from [grouplearns.org](https://grouplens.org/datasets/movielens/). Please follow the instructions in [Hive Tutorial](https://github.com/zongjunhu/bigfoot-tutorials/blob/master/hive/Big%20Foot%20Hive%20Tutorial.md) to download and prepare data in `hdfs`. We are expecting sample data file located under `/project/public/data`.

Here is a quick sample from `bigfoot` `ssh` command line.

```
$ wget http://files.grouplens.org/datasets/movielens/ml-100k.zip 
$ unzip ml-100k.zip
$ hadoop fs -put ml-100k/u.user /project/public/data/
```

## Run Test Example in `Impala Shell`

On bigfoot command line, start `impala` shell.

```
$ impala-shell -k -i n01 -d default;
[n01:21000] >
```

This command start `impala` shell session to connect to `impala` server on cluster node `n01` (`-i n01`). It uses `Kerberos` ticket (`-k`) and connects to database `default`. You can connect to any node in the range of `n01-n13` on bigfoot. The same results expected.

In this session, create table `users` from the data file we just uploaded. Run a few simple queries.

```sql
-- create table, match schema in data file
create table users(userid int, age int, gender string, occupation string, zip string) row format delimited fields terminated by '|';

-- review schema of the new table
describe users;

-- load data from data file to table
load data inpath '/project/public/data/u.user' into table users;

-- run queries
-- count rows
select count(*) from users;
-- group by occupation and display user counts
select occupation, count(*) c from users group by occupation order by c desc;
```

### Table file location

This example creates a managed table in `hive` warehouse folder. If you check for table files before dropping table, you will see similar output like below.

```
$ hadoop fs -ls /user/hive/warehouse/users
Found 1 items
-rwxrwx--x+  3 hive hive      22628 2017-04-12 16:38 /user/hive/warehouse/users/u.user

$ hadoop fs -tail /user/hive/warehouse/users/u.user
1|38|M|executive|L1V3W
902|45|F|artist|97203
903|28|M|educator|20850
904|17|F|student|61073
905|27|M|other|30350
906|45|M|librarian|70124
907|25|F|other|80526
908|44|F|librarian|68504
909|50|F|educator|53171
...
```
### Table file format

Let's copy this text file based table to a parquet based table and check its difference.
```
[n01:21000] > create table users_parquet stored as parquet as select * from users;
Query: create table users_parquet stored as parquet as select * from users
+---------------------+
| summary             |
+---------------------+
| Inserted 943 row(s) |
+---------------------+
Fetched 1 row(s) in 2.75s

[n01:21000] > show table stats users;
Query: show table stats users
+-------+--------+---------+--------------+-------------------+--------+-------------------+-----------------------------------------+
| #Rows | #Files | Size    | Bytes Cached | Cache Replication | Format | Incremental stats | Location                                |
+-------+--------+---------+--------------+-------------------+--------+-------------------+-----------------------------------------+
| -1    | 1      | 22.10KB | NOT CACHED   | NOT CACHED        | TEXT   | false             | hdfs://nameha/project/public/data/users |
+-------+--------+---------+--------------+-------------------+--------+-------------------+-----------------------------------------+
Fetched 1 row(s) in 0.02s

[n01:21000] > show table stats users_parquet;
Query: show table stats users_parquet
+-------+--------+---------+--------------+-------------------+---------+-------------------+-------------------------------------------------+
| #Rows | #Files | Size    | Bytes Cached | Cache Replication | Format  | Incremental stats | Location                                        |
+-------+--------+---------+--------------+-------------------+---------+-------------------+-------------------------------------------------+
| -1    | 1      | 13.05KB | NOT CACHED   | NOT CACHED        | PARQUET | false             | hdfs://nameha/user/hive/warehouse/users_parquet |
+-------+--------+---------+--------------+-------------------+---------+-------------------+-------------------------------------------------+
Fetched 1 row(s) in 0.01s

```
Comparing these two little tables with the same contents, `parquet` file format saves lots of space in storage.

### Access table file from Spark

The new parquet table is located under `hive` warehouse folder at `/user/hive/warehouse/users_parquet`. We can run a Spark job to access this file and use `SparkSQL` to run query inside spark job. You can find the `python` source code (`read_parquet.py`) of this simple task in `github` respository. `SparkSQL` is another fast query engine for hadoop files. It has similar performance as `impala`.

Run the following out side `impala` shell from `bigfoot` command line.

```
$ spark-submit --master yarn read_parquet.py
...
17/04/13 13:31:37 INFO cluster.YarnScheduler: Removed TaskSet 5.0, whose tasks have all completed, from pool 
17/04/13 13:31:37 INFO scheduler.DAGScheduler: ResultStage 5 (collect at /home/zhu/tests/bigfoot-tutorials/impala/read_parquet.py:16) finished in 1.340 s
17/04/13 13:31:37 INFO scheduler.DAGScheduler: Job 2 finished: collect at /home/zhu/tests/bigfoot-tutorials/impala/read_parquet.py:16, took 3.338160 s
student 196
other 105
educator 95
administrator 79
engineer 67
programmer 66
librarian 51
writer 45
executive 32
scientist 31
artist 28
technician 27
marketing 26
entertainment 18
healthcare 16
retired 14
salesman 12
lawyer 12
none 9
doctor 7
homemaker 7
17/04/13 13:31:37 INFO spark.SparkContext: Invoking stop() from shutdown hook
17/04/13 13:31:37 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/static/sql,null}
17/04/13 13:31:37 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/SQL/execution/json,null}
17/04/13 13:31:37 INFO handler.ContextHandler: stopped o.s.j.s.ServletContextHandler{/SQL/execution,null}

```

### Column data type modification
```
[n01:21000] > describe users;
Query: describe users
+------------+--------+---------+
| name       | type   | comment |
+------------+--------+---------+
| userid     | int    |         |
| age        | int    |         |
| gender     | string |         |
| occupation | string |         |
| zip        | string |         |
+------------+--------+---------+
Fetched 5 row(s) in 1.25s
```

Since `age` is `int`, we can do number comparison.

```
[n01:21000] > select userid, age, gender from users where age > 35 limit 5;
Query: select userid, age, gender from users where age > 35 limit 5
+--------+-----+--------+
| userid | age | gender |
+--------+-----+--------+
| 2      | 53  | F      |
| 6      | 42  | M      |
| 7      | 57  | M      |
| 8      | 36  | M      |
| 10     | 53  | M      |
+--------+-----+--------+
Fetched 5 row(s) in 0.56s
```

Same data file. But let's change `age` type to `string`. We can now do string comparison.

```
[n01:21000] > alter table users change age age string;
Query: alter table users change age age string

[n01:21000] > select userid, age, gender from users where age like '3%' limit 5;
Query: select userid, age, gender from users where age like '3%' limit 5
+--------+-----+--------+
| userid | age | gender |
+--------+-----+--------+
| 5      | 33  | F      |
| 8      | 36  | M      |
| 11     | 39  | F      |
| 17     | 30  | M      |
| 18     | 35  | F      |
+--------+-----+--------+
Fetched 5 row(s) in 0.52s
```
This trick works when table file format is text file.

Finally, drop the table. 
```sql
-- drop table
drop table users;
drop table users_parquet;
```
And exit from `impala` shell session.

```
[n01:21000] > exit;
```

When data file is loaded from source location, it is relocated to `hive` warehouse folder, like managed Hive table. After table is dropped, the source file disappears from both the source folder and the warehouse folder. For example, when check source folder on hdfs, the following is expected.

```
$ hadoop fs -ls /project/public/data/u.user
ls: `/project/public/data/u.user': No such file or directory
```

## External Table Test

Similar to `hive`, `external table` is another option to create table in database. Instead of putting data file directly under `/project/public/data`, create a folder to host the the sample file and then upload file into the new folder.

```
$ hadoop fs -mkdir /project/public/data/users/
$ hadoop fs -put ml-100k/u.user /project/public/data/users/
```

The folder name can be anything you preferred, once there is no space used in it. Then in `impala` shell session, you can create an external table as the following. The new path is used in `location` part in the command. 

```sql
-- create external table
create table users(userid int, age int, gender string, occupation string, zip string) row format delimited fields terminated by '|' location '/project/public/data/users';

-- run queries
select count(*) from users;

-- drop table
drop table users;
```

Unlike `hive` external table,  `impala` deletes source data file and its parent folder after `external` table is dropped. Since it is external table, `impala` does not relocate source data to `hive` warehouse folder.
