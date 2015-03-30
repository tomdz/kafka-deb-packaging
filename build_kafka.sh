#!/bin/bash
# 2015-Mar-18 Updated to latest Kafka stable: 0.8.2.1
# 2015-Mar-20 Added the init.d script and changed to use binary download of scala 2.10, Kafka 0.8.2.1

set -e
set -u
name=kafka
version=0.8.2.1
scala_version=2.10
description="Apache Kafka is a distributed publish-subscribe messaging system."
url="https://kafka.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
package_version="-7"
bin_package="kafka_${scala_version}-${version}.tgz"
src_package="kafka-${version}-src.tgz"
src_download_url="http://mirror.sdunix.com/apache/kafka/${version}/${src_package}"
origdir="$(pwd)"

#_ MAIN _#
rm -rf ${name}*.deb
if [[ ! -f "${src_package}" ]]; then
  wget -c ${src_download_url}
fi
mkdir -p tmp && pushd tmp
rm -rf kafka
mkdir -p kafka
cd kafka
mkdir -p build/usr/lib/kafka
mkdir -p build/usr/lib/kafka/logs
mkdir -p build/etc/default
mkdir -p build/etc/init
mkdir -p build/etc/init.d
mkdir -p build/etc/kafka
mkdir -p build/var/log/kafka
#mkdir -p build/var/run/kafka

cp ${origdir}/kafka-broker.default build/etc/default/kafka-broker
cp ${origdir}/kafka-broker.upstart.conf build/etc/init/kafka-broker.conf
cp ${origdir}/kafka-broker.init.d build/etc/init.d/kafka

# This code line uses the src packages
tar zxf ${origdir}/${src_package}
cd kafka-${version}-src
# updated to gradle build as per Kafka README
gradle
./gradlew releaseTarGz
cp ./core/build/distributions/${bin_package} ${origdir}/${bin_package}
cd ..

# Now resume regular binary exploding
# Updated to use the Binary package
rm -rf kafka_${scala_version}-${version}
tar zxf ${origdir}/${bin_package}
cd kafka_${scala_version}-${version}
cp config/server.properties ../build/etc/kafka
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
