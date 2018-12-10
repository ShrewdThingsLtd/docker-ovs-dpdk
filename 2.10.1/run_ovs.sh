#!/bin/bash

set -x

#export DB_SOCK=/usr/local/var/run/openvswitch/db.sock
export OVS_DIR=/usr/src/ovs
export OVS_RUN_DIR=$OVS_DIR/run
export OVS_ETC_DIR=$OVS_DIR/etc
export OVS_LOG_DIR=$OVS_DIR/log

mkdir -p $OVS_RUN_DIR
mkdir -p $OVS_ETC_DIR
mkdir -p $OVS_LOG_DIR

OVS_RUNTIME_DIR=/usr/local/var/run/openvswitch
mkdir -p $OVS_RUNTIME_DIR
DB_SOCK=$OVS_RUNTIME_DIR/db.sock

sysctl -w vm.nr_hugepages=2048
mkdir -p /mnt/huge
#mount -t hugetlbfs -o pagesize=1G nodev /mnt/huge
grep HugePages_ /proc/meminfo

ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

ovsdb-server \
  --remote=punix:$DB_SOCK \
  --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
  --log-file=$OVS_LOG_DIR/ovsdb-server.log \
  --pidfile \
  --detach

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

set +x

