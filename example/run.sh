#!/bin/bash

set -eu

MY_JAR=target/scala-2.11/simple-project_2.11-2.0.1.jar

MY_CLASS=someorg.spark.example.TestKafka

ZK_HOST=localhost

KAFKA_TOPIC=test

${SPARK_HOME}/bin/spark-submit \
  --class $MY_CLASS \
  --master local[*] \
  --packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.0.1 \
  $MY_JAR $ZK_HOST consumer $KAFKA_TOPIC 1
