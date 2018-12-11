#!/bin/bash

export TGT_IP=172.17.0.1
export TGT_USER=root
export TGT_PASS=devops123
echo "Setting DPDK environment variables..."
export DPDK_DIR=/usr/src/dpdk
export DPDK_TARGET=x86_64-native-linuxapp-gcc
export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET
#export EXTRA_CFLAGS+=-mno-f16c
echo "$EXTRA_CFLAGS"
