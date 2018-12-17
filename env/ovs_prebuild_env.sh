#!/bin/bash

export TGT_IP="172.17.0.1"
export TGT_USER=root
export TGT_PASS=devops123
export TGT_SRC_DIR=/root/GITHUB/ST
export DPDK_TARGET=x86_64-native-linuxapp-gcc

app_dpdk_configure() {

	exec_apt_install "$(ovs_prerequisites)"
	#exec_apt_clean
	ovs_dpdk_config
}
