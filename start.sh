#!/bin/bash

OVS_IMG=${1:-local}


case ${OVS_IMG} in
	"hub")
	OVS_IMG=shrewdthingsltd/docker-ovs-dpdk:ovs-2.10.1
	docker pull $OVS_IMG
	;;
	*)
	./2.10.1/build_ovs.sh
	OVS_IMG=local/docker-ovs-dpdk:ovs-2.10.1
	;;
esac

docker run -ti --net=host --privileged -v /mnt/huge:/mnt/huge --device=/dev/uio0:/dev/uio0 $OVS_IMG /bin/bash

