# spark-submit --master yarn --num-executors 200 pegasus-logs.py
from pyspark import SparkContext
from pyspark import SparkConf

def extract_user_ip(line):
    tokens = line.split()
    return (tokens[8], tokens[10])

conf = SparkConf()
conf.setAppName('Pegasus User Access Analysis')

sc = SparkContext(conf=conf)

# (uid, ip)
f = sc.textFile('/project/hpcjobs/pegasus_logs/server_log/FlumeData*')\
        .filter(lambda x: x.find('Accept') > 0 and x.find('root') < 0)\
        .map(lambda x: extract_user_ip(x)).cache() 

# (uid, count)
user_visits = f.distinct().groupByKey().map(lambda x: (x[0], len(x[1]))).sortBy(lambda x: x[1]).collect()

for u in user_visits:
    print u[0], u[1]
