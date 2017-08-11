# spark-submit --master yarn --num-executors 10 --jars spark-csv-assembly-1.4.0.jar amazon_book.rating.py
from pyspark import SparkContext
from pyspark import SparkConf
from pyspark.sql import HiveContext
from pyspark.sql.types import StructType, IntegerType, StringType, FloatType, TimestampType, StructField

conf = SparkConf()
conf.setAppName('spark-workshop')
conf.setMaster('yarn-client')

sc = SparkContext(conf=conf)
sqlContext = HiveContext(sc)

customSchema = StructType(
        [
            StructField("user", StringType(), True),
            StructField("item", StringType(), True),
            StructField("rating", FloatType(), True),
            StructField("timestamp", IntegerType(), True)
            ]
        )

df = sqlContext.read.format("com.databricks.spark.csv")\
    .option("header", "false")\
    .option("inferSchema", "false")\
    .schema(customSchema)\
    .load("/project/public/spark-workshop/amazon_ratings_Books.csv")

df.registerTempTable("tb")

sqlContext.sql("drop table if exists default.amazon_book_rating")

sqlContext.sql("create table default.amazon_book_rating stored as parquet as select * from tb")
