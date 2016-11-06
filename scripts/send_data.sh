#!/bin/bash

cd /opt/kafka_2.11-0.10.1.0 && \
  (echo "new_msg" | bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test)
