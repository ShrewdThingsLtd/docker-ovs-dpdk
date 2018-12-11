#!/bin/bash

OVS_IMG=${1:-local}


case ${OVS_IMG} in
	"hub")
	OVS_IMG=shrewdthingsltd/docker-ovs-dpdk:ovs-2.10.1-prebuild
	docker pull $OVS_IMG
	;;
	*)
	DPDK_IMG=local/docker-dpdk:dpdk-17.11.4
	OVS_IMG=local/docker-ovs-dpdk:ovs-2.10.1-prebuild
	cd ./2.10.1
	docker build \
		-t $OVS_IMG \
		--build-arg BASE_IMG=$DPDK_IMG \
		./
	cd -
	;;
esac

docker run -ti --net=host --privileged -v /mnt/huge:/mnt/huge --device=/dev/uio0:/dev/uio0 $OVS_IMG /bin/bash

