#!/bin/bash
set -e
set -u
name=kafka
version=0.10.1.1
scala_version=2.11
description="Apache Kafka is a distributed publish-subscribe messaging system."
url="https://kafka.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
package_version="-1"
src_package="kafka_${scala_version}-${version}.tgz"
download_url="http://mirror.cc.columbia.edu/pub/software/apache/kafka/${version}/${src_package}"
origdir="$(pwd)"

#_ MAIN _#
rm -rf ${name}*.deb
if [ ! -f "${src_package}" ]; then
  wget ${download_url}
fi
mkdir -p tmp && pushd tmp
rm -rf kafka
mkdir -p kafka
cd kafka
mkdir -p build/usr/lib/kafka
mkdir -p build/etc/default
mkdir -p build/etc/init
mkdir -p build/etc/kafka
mkdir -p build/var/log/kafka

cp ${origdir}/kafka-broker.default build/etc/default/kafka-broker
cp ${origdir}/kafka-broker.upstart.conf build/etc/init/kafka-broker.conf

tar zxf ${origdir}/${src_package}
cd kafka_${scala_version}-${version}
mv config/log4j.properties config/server.properties ../build/etc/kafka
mv * ../build/usr/lib/kafka
cd ../build

fpm -t deb \
    -n ${name} \
    -v ${version}${package_version} \
    --description "${description}" \
    --url="{$url}" \
    -a ${arch} \
    --category ${section} \
    --vendor "" \
    --license "${license}" \
    -m "${USER}@localhost" \
    --prefix=/ \
    -s dir \
    -- .
mv kafka*.deb ${origdir}
popd
