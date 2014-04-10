#!/bin/bash
set -e
set -u
name=kafka
version="0.8.1"
scala_version="2.10"
description="Apache Kafka is a distributed publish-subscribe messaging system."
url="https://kafka.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
package_version="-1"
src_package="kafka_${scala_version}-${version}.tgz"
download_url="https://dist.apache.org/repos/dist/release/kafka/${version}/${src_package}"
origdir="$(pwd)"
license="Apache Software License 2.0"

#_ MAIN _#
function cleanup() {
    rm -rf ${name}*.deb
}

function bootstrap() {
    if [[ ! -f "${src_package}" ]]; then
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
}

function build() {
    cp ${origdir}/kafka-broker.default build/etc/default/kafka-broker
    cp ${origdir}/kafka-broker.upstart.conf build/etc/init/kafka-broker.conf 

    tar zxf ${origdir}/${src_package}
    cd kafka_${scala_version}-${version}
    cp -rp config/* ../build/etc/kafka
    mv config config.old
    cp ${origdir}/log4j.properties ../build/etc/kafka
    mv * ../build/usr/lib/kafka
    cd ../build
}

function mkdeb() {
  /data/jenkins/.rbenv/shims/fpm -t deb \
    -n ${name} \
    -v ${version}${package_version} \
    --description "${description}" \
    --url="{$url}" \
    -a ${arch} \
    --category ${section} \
    --vendor "" \
    --license "${license}" \
    --after-install ../../../kafka-broker.postinst \
    -m "${USER}@${HOSTNAME}" \
    --config-files /etc/default/kafka-broker \
    --config-files /etc/init/kafka-broker.conf \
    --license "${license}" \
    --prefix=/ \
    -s dir \
    -- .
  mv kafka*.deb ${origdir}
  popd
}

function main() {
    cleanup
    bootstrap
    build
    mkdeb
}

main
