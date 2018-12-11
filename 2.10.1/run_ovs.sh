#!/bin/bash

set -x

export WORK_DIR=/usr/src
. $WORK_DIR/ovs_utils.sh

ovs_wipeout

sysctl -w vm.nr_hugepages=2048
mkdir -p /mnt/huge
#mount -t hugetlbfs -o pagesize=1G nodev /mnt/huge
mount -t hugetlbfs nodev /mnt/huge
grep HugePages_ /proc/meminfo

ovsdb_server_start
ovs_restart


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

