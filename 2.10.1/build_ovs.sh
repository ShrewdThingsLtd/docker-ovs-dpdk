#!/bin/bash

pushd ./2.10.1
docker build -t local/docker-ovs-dpdk:ovs-2.10.1-prebuild ./
popd

