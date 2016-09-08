kafka-deb-packaging
===================

Simple debian packaging for Apache Kafka
You can change version and scala_version in the script according to your requirements.


## Changelog

2016-Sep-07 : Kafka 0.10.0.1

2015-Mar-18 : Updated for latest Kafka 0.8.2.1 and use sbt in system path.

2015-Jun-13 :
  - Use the binary distribution instead
  - Run under kafka user
  - Added init.d script
  - Patch for correct default paths
  - Better directory structure
  - Install script dependencies right in the script
  - Specified package dependencies
