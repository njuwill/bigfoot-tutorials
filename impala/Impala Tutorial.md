# Hive Tutorial

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
Finally, drop the table. 
```sql
-- drop table
drop table users;
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
