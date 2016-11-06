package someorg.spark.example

import org.apache.spark.SparkConf
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka._

object TestKafka {

  //see here: http://spark.apache.org/docs/latest/streaming-kafka-0-8-integration.html
  def main(args: Array[String]): Unit ={
    if (args.length < 4) {
      System.err.println("Usage: KafkaWordCount <zkQuorum> <group> <topics> <numThreads>")
      System.exit(1)
    }

    val Array(zkQuorum, group, topics, numThreads) = args
    val sparkConf = new SparkConf().setMaster("local[*]").setAppName("KafkaWordCount")
    val ssc = new StreamingContext(sparkConf, Seconds(20))
    ssc.checkpoint("checkpoint")

    val topicMap = topics.split(",").map((_, numThreads.toInt)).toMap
    val lines = KafkaUtils.createStream(ssc, zkQuorum, group, topicMap).map(_._2)

    lines.print()
    /*
    val words = lines.flatMap(_.split(" "))
    val wordCounts = words.map(x => (x, 1L))
      .reduceByKeyAndWindow(_ + _, _ - _, Minutes(10), Seconds(10), 2)
    wordCounts.print()
    */

    ssc.start()
    ssc.awaitTermination()
  }
}
