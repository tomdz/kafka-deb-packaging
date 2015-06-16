#!/bin/bash
# Before you run this script, you need to install the following dependencies:
#  sudo apt-get install rubygems ruby-dev build-essential
#
# Then install fpm, either
#  sudo gem install fpm
# or
#  gem install --user-install fpm   and configure PATH accordingly, see `gem env`

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
package_version="-1"
bin_package="kafka_${scala_version}-${version}.tgz"
download_url="http://mirror.metrocast.net/apache/kafka/${version}/${bin_package}"
origdir="$(pwd)"

#_ MAIN _#
rm -rf ${name}*.deb
if [[ ! -f "${bin_package}" ]]; then
  wget ${download_url}
fi
rm -rf tmp
mkdir -p tmp && pushd tmp
mkdir -p build/usr/share/kafka
mkdir -p build/etc/kafka
mkdir -p build/var/log/kafka

cp -R ${origdir}/files/* build

tar zxf ${origdir}/${bin_package}
cd kafka_${scala_version}-${version}

mv config/* ../build/etc/kafka
rm -r config
rm -rf bin/windows
mv * ../build/usr/share/kafka
cd ../build
pushd usr/share/kafka
patch -p1 < ${origdir}/paths.patch
popd

fpm -t deb \
    -n ${name} \
    -v ${version}${package_version} \
    --description "${description}" \
    --url="{$url}" \
    -a ${arch} \
    --category ${section} \
    --vendor "" \
    --license "${license}" \
    --config-files etc/kafka \
    --deb-init usr/share/kafka/kafka.init \
    --after-install usr/share/kafka/kafka.postinst \
    --after-remove usr/share/kafka/kafka.postrm \
    -d openjdk-7-jre-headless \
    -d zookeeperd \
    -m "${USER}@localhost" \
    --prefix=/ \
    -s dir \
    -- .
mv kafka*.deb ${origdir}/kafka_${scala_version}-${version}.deb
popd
