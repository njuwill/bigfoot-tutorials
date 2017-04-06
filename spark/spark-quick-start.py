from pyspark import SparkContext
from pyspark import SparkConf

conf = SparkConf()
conf.setAppName('Spark Quick Start Sample')

sc = SparkContext(conf=conf)

f = sc.textFile('/project/public/PGYR15/OP_DTL_RSRCH_PGYR2015_P01172017.csv')
count = f.count()

print "total number of lines counted:", count

