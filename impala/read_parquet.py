#
# spark-submit --master yarn read_parquet.py
#

from pyspark import SparkContext
from pyspark import SparkConf
from pyspark.sql import SQLContext
import os, sys

sconf = SparkConf().setAppName("sparksql parquet")
sc = SparkContext(conf=sconf)
sqlContext = SQLContext(sc)

sqlContext.read.parquet('/user/hive/warehouse/users_parquet').registerTempTable("users")

occupations = sqlContext.sql("select occupation, count(occupation) c from users group by occupation order by c desc").map(lambda x: (x[0], x[1])).collect()

for o in occupations:
    print o[0], o[1]
