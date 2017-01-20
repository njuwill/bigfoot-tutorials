from pyspark import SparkContext
from pyspark import SparkConf
from pyspark.sql import HiveContext

conf = SparkConf()
conf.setAppName('load csv')
conf.setMaster('yarn-client')
#conf.set('spark.hadoop.textinputformat.record.delimiter', "\n")


sc = SparkContext(conf=conf)
sqlContext = HiveContext(sc)

df = sqlContext.read.format("com.databricks.spark.csv").
    option("header", "true").
    option("inferSchema", "true").
    load("Sacramentorealestatetransactions.csv")

df.registerTempTable("tb")

sqlContext.sql("drop table if exists default.realestatetransactions")

sqlContext.sql("create table default.realestatetransactions stored as parquet as select * from tb")
