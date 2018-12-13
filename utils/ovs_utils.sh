#!/bin/bash

set -x

ovs_prerequisites() {

	echo 'autoconf automake libtool openssl libssl-dev python libcap-ng-dev python-six libfuse-dev'
}

ovs_clone() {

	git_clone $SRC_DIR $OVS_REPO $OVS_VERSION
}

ovs_pull() {

	git_pull "${OVS_DIR}" "${OVS_VERSION}"
}

ovs_dpdk_config() {

	sed -i s/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/ $DPDK_DIR/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/ $DPDK_DIR/config/common_linuxapp
	sed -i s/CONFIG_RTE_LIBRTE_VHOST_USER=y/CONFIG_RTE_LIBRTE_VHOST_USER=n/ $DPDK_DIR/config/common_linuxapp
}

set +x

