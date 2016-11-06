#!/bin/bash

PS=`docker ps | grep sparkkafka | awk '{print $1}'`

echo $PS
docker exec -it $PS /opt/scripts/send_data.sh


