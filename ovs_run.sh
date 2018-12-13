#!/bin/bash

set -x

. ${SRC_DIR}/utils/ovs_runtime.sh

ovs_wipeout

sysctl -w vm.nr_hugepages=2048
mkdir -p /mnt/huge
#mount -t hugetlbfs -o pagesize=1G nodev /mnt/huge
mount -t hugetlbfs nodev /mnt/huge
grep HugePages_ /proc/meminfo

ovsdb_server_start
ovs_restart

set +x
