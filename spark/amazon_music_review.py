# spark-submit --master yarn-client --num-executors 4 --executor-cores 1 amazon_music_review.py

from pyspark import SparkContext
from pyspark import SparkConf

conf = SparkConf()
conf.setAppName('spark-work-shot')
conf.setMaster('yarn-client')

sc = SparkContext(conf=conf)
sqlContext = HiveContext(sc)

reviews = sqlContext.read.json("/project/public/spark-workshop/amazon_reviews_Musical_Instruments_5.json")

reviews.registerTempTable("amazon")

stat = sqlContext.sql('select asin, count(*) c from amazon group by asin order by c desc limit 100').map(lambda x: (x.asin, x.c)).collect()

for s in stat:
    print s[0], s[1] 

#B003VWJ2K8 163
#B0002E1G5C 143
#B0002F7K7Y 116
#B003VWKPHC 114
#B0002H0A3S 93
#B0002CZVXM 74
#B0006NDF8A 71
#B0009G1E0K 69
#B0002E2KPC 68
#B0002GLDQM 67
#B004XNK7AI 65
#B005FKF1PY 63
#B00646MZHK 62
