FROM ubuntu:16.04

#=====================================================================
#Step 1: Add basic linux tools and commands

#Based on: https://github.com/dockerfile/ubuntu/blob/master/Dockerfile

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

#=====================================================================
#Step 2: Install Oracle java

#Based on https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile
# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-add-repository -y ppa:webupd8team/java && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


#=====================================================================
#Step 3: Download and untar Spark

# Change working dir to /opt. Spark will be install under /opt/spark-
WORKDIR /opt

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz

RUN tar -xzvf spark-2.0.0-bin-hadoop2.7.tgz

ENV SPARK_HOME /opt/spark-2.0.0-bin-hadoop2.7

ENV PATH $SPARK_HOME/bin:$PATH

#======================================================================
#Step 4: Download zookeeper

RUN wget http://apache.lauf-forum.at/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz

RUN tar -xzvf zookeeper-3.4.9.tar.gz

#======================================================================
#Step 5: Download Kafka

RUN wget http://apache.lauf-forum.at/kafka/0.10.1.0/kafka_2.11-0.10.1.0.tgz

RUN tar -xzvf kafka_2.11-0.10.1.0.tgz


#=======================================================================
#Step 6: Install tini

#Based on recommendations in http://jupyter-notebook.readthedocs.io/en/latest/public_server.html

# Add Tini. Tini operates as a process subreaper for processes
ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

#=======================================================================
#Step 7: Install SBT
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/0.13.13/sbt-0.13.13.tgz
RUN tar -xzvf  sbt-0.13.13.tgz

ENV PATH /opt/sbt-launcher-packaging-0.13.13/bin/:$PATH

ADD example/ example/

RUN \
    cd example \
    && ./build.sh

# Start zookeper, kafka and execute the spark example
ADD scripts scripts/

WORKDIR /opt/scripts
CMD ["./start.sh"]
