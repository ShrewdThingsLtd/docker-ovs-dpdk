#!/bin/bash

set -x

OVS_RUNTIME_DIR=/usr/local/var/run/openvswitch
mkdir -p $OVS_RUNTIME_DIR
export PATH=$PATH:/usr/local/share/openvswitch/scripts
export DB_SOCK=$OVS_RUNTIME_DIR/db.sock
export OVS_DIR=/usr/src/ovs
export OVS_RUN_DIR=$OVS_DIR/run
export OVS_ETC_DIR=$OVS_DIR/etc
export OVS_LOG_DIR=$OVS_DIR/log

mkdir -p $OVS_RUN_DIR
mkdir -p $OVS_ETC_DIR
mkdir -p $OVS_LOG_DIR


sysctl -w vm.nr_hugepages=2048
mkdir -p /mnt/huge
#mount -t hugetlbfs -o pagesize=1G nodev /mnt/huge
grep HugePages_ /proc/meminfo

ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema
ovs-vsctl --no-wait init

ovsdb-server \
        --remote=punix:$DB_SOCK \
        --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
        --log-file=$OVS_LOG_DIR/ovsdb-server.log \
        --pidfile \
        --detach

ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
ovs-ctl --no-ovsdb-server --db-sock="$DB_SOCK" start
ovs-vsctl get Open_vSwitch . dpdk_initialized
ovs-vswitchd --version
ovs-vsctl get Open_vSwitch . dpdk_version
ovs-ctl status

if false
then

ovs-vsctl \
  --no-wait \
  --log-file=$OVS_LOG_DIR/ovs-vsctl.log \
  init

rm /dev/vhost-net

ovs-vswitchd \
  --dpdk -c 0x1 -n 4 \
  -- unix:$DB_SOCK \
  --log-file=$OVS_LOG_DIR/ovs-vswitchd.log \
  --pidfile
fi

set +x

