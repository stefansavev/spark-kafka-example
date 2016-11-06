# spark-kafka-example
The example from spark kafka with docker configuration

## Building

```docker-compose build```

## Running

```docker-compose up```

Once the container has started you can run:

```./send_data.sh```

This command will:
- execute the script scripts/send_data.sh in the docker container
- send data to Kafka
- force spark streaming to process the data
