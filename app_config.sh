#!/bin/bash

. ${SRC_DIR}/app_env.sh
. ${SRC_DIR}/utils/ovs_utils.sh

exec_apt_install "$(ovs_prerequisites)"
#exec_apt_clean
ovs_dpdk_config
