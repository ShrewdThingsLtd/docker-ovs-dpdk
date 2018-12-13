#!/bin/bash

echo "Modifying DPDK configuration..."
# OVS needs DPDK compiled with these...
sed -i s/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/ $DPDK_DIR/config/common_linuxapp
sed -i s/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/ $DPDK_DIR/config/common_linuxapp
sed -i s/CONFIG_RTE_LIBRTE_VHOST_USER=y/CONFIG_RTE_LIBRTE_VHOST_USER=n/ $DPDK_DIR/config/common_linuxapp

