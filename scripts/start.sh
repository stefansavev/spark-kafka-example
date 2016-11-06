#!/bin/bash

echo "start.sh: Starting zookeper/kafka and running example"

#sleep 100000

CONFIG_DIR=/opt/kafka_2.11-0.10.1.0/config

cd /opt/zookeeper-3.4.9/ && bin/zkServer.sh start ${CONFIG_DIR}/zookeeper.properties

sleep 2

cd /opt/kafka_2.11-0.10.1.0 && bin/kafka-server-start.sh ${CONFIG_DIR}/server.properties &

sleep 2

cd /opt/kafka_2.11-0.10.1.0 && bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

sleep 2

cd /opt/kafka_2.11-0.10.1.0 && ( \
echo "hello world!" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test)

cd /opt/example && ./run.sh

echo "Done with streaming job."
wait
