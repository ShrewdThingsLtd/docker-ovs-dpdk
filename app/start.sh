#!/bin/bash

DPDK_VERSION=${1:-v17.11-rc4}
OVS_IMG=${2:-local}
OVS_VERSION=${3:-v2.10.1}

docker volume rm $(docker volume ls -qf dangling=true)
#docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')
docker rm $(docker ps -qa --no-trunc --filter "status=exited")

case ${OVS_IMG} in
	"hub")
	OVS_IMG=shrewdthingsltd/docker-ovs-dpdk:ovs-$OVS_VERSION-prebuild
	docker pull $OVS_IMG
	;;
	*)
	DPDK_IMG=local/docker-dpdk:dpdk-$DPDK_VERSION
	OVS_IMG=local/docker-ovs-dpdk:ovs-$OVS_VERSION-prebuild
	OVS_REPO="https://github.com/openvswitch/ovs.git"
	docker build \
		-t $OVS_IMG \
		--build-arg IMG_BASE=$DPDK_IMG \
		--build-arg IMG_OVS_REPO=$OVS_REPO \
		--build-arg IMG_OVS_VERSION=$OVS_VERSION \
		./
	;;
esac

docker run \
	-ti \
	--net=host \
	--privileged \
	-v /mnt/huge:/mnt/huge \
	--device=/dev/uio0:/dev/uio0 \
	$OVS_IMG \
	/bin/bash
