this example is copied from Spark quick start for [version 2.2.0](https://spark.apache.org/docs/latest/quick-start.html)

create folder layout

```
mkdir sample.spark
cd sample.spar
mkdir -p src/main/scala
```

add sample job script as src/main/scala/SimpleApp.scala
```scala
/* SimpleApp.scala */
import org.apache.spark.sql.SparkSession

object SimpleApp {
  def main(args: Array[String]) {
    val logFile = "PATH_TO_YOUR_FILE_IN_YOUR_HDFS_HOME" // Should be some file on your system
    val spark = SparkSession.builder.appName("Simple Application").getOrCreate()
    val logData = spark.read.textFile(logFile).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    spark.stop()
  }
}
```
`PATH_TO_YOUR_FILE_IN_YOUR_HDFS_HOME` is the path to your text file under your `hdfs` home, including folder name(s) if file is under a folder.

This sample job will load your text file and count the number of A's and B's and print them out on your screen.

create `build.sbt` at top directory with the following content
```
name := "Simple Project"

version := "1.0"

scalaVersion := "2.11.8"

libraryDependencies += "org.apache.spark" %% "spark-sql" % "2.2.0"
```

then build jar for this sample task.

```
/PATH/TO/sbt package
```
jar file is created in a new folder under current directory as `target/scala-2.11/simple-project_2.11-1.0.jar`

then submit through new Spark `2.2.0`

```
/opt/spark-2.2.0-bin-hadoop2.6/bin/spark-submit --master yarn-client --num-executors 2 --executor-cores 1 --class SimpleApp target/scala-2.11/simple-project_2.11-1.0.jar 
```

This job is submitted to `yarn` cluster and run on compute nodes. It asks for 2 executors and 1 core per executor. 

This sample does not work for default spark, which is version 1.6.0. You should use the full absolute path to spark version 2.2.0.
