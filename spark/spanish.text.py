# scan spanish journals in sequence file, find most frequent words with minimum length of 4
# command to run on bigfoot to repeat sample results
#spark-submit --master yarn-client --num-executors 100 --executor-cores 2 --executor-memory 2G --driver-memory 2G spanish.text.py

from pyspark import SparkContext
from pyspark import SparkConf
import re

# minilen is the minimum length of the words to be considered in frequency ranking.
def split_to_words(txt, minlen):
    res = re.split(r'[\r\n\s]+', str(txt))
    arr = {}
    for w in res:
        if len(w) >= minlen:
            #w = w.decode('utf-8-sig').encode('utf-8').lower()
            w = w.decode('utf-8-sig').lower()
            arr[w] = 1 if not arr.has_key(w) else arr[w] + 1
    return arr.items()

conf = SparkConf()
conf.setAppName('Spanish')

sc = SparkContext(conf=conf)

f = sc.sequenceFile('/project/public/collections-as-data', 'org.apache.hadoop.io.Text', 'org.apache.hadoop.io.BytesWritable').cache()
scanned = f.filter(lambda(n, t): n.split('/')[-1].startswith('chc') and n.endswith('txt'))

count = f.count()
txtcount = scanned.count()

top10 = scanned.flatMap(lambda(n, t): split_to_words(t, 4)).reduceByKey(lambda a, b: a+b).sortBy(lambda x: -x[1]).take(10)

print 'found ', count, 'files, ', txtcount, ' of them are scanned files'

for t in top10:
    print t[0].encode('utf-8'), t[1]

# sample results
# found  53905 files,  53902  of them are scanned files
# para 1866797
# esta 1016435
# este 729596
# habana 459149
# josé 436988
# gaceta 410787
# general 382795
# presente 367913
# idem 361412
# como 339901
