kafka-deb-packaging
===================

Simple debian packaging for Apache Kafka

## Changelog
2015-Mar-18 : Updated for latest Kafka 0.8.2.1 and use sbt in system path.
2015-Mar-30 : Final Test, ready for git pull

# Tested Systems

Ubuntu 14.04LTS, Amazon EC2


# Sample Output

~/git/kafka-deb-packaging$ ./dist_kafka.sh

--2015-03-30 17:39:01--  http://mirror.sdunix.com/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz
Resolving mirror.sdunix.com (mirror.sdunix.com)... 74.206.97.82
Connecting to mirror.sdunix.com (mirror.sdunix.com)|74.206.97.82|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16162559 (15M) [application/x-gzip]
Saving to: ‘kafka_2.10-0.8.2.1.tgz’

100%[========================>] 16,162,559   340KB/s   in 44s

2015-03-30 17:39:45 (361 KB/s) - ‘kafka_2.10-0.8.2.1.tgz’ saved [16162559/16162559]

~/git/kafka-deb-packaging/tmp ~/git/kafka-deb-packaging
Created package {:path=>"kafka_0.8.2.1-5_all.deb"}
~/git/kafka-deb-packaging
