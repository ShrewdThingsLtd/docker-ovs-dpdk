ARG BASE_IMG=shrewdthingsltd/docker-dpdk:dpdk-17.11.4
FROM $BASE_IMG
RUN echo "$BASE_IMG"

RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf automake \
  libtool \
  openssl libssl-dev \
  python \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && apt-get install -y libcap-ng-dev && apt-get install -y python-six

ARG IMG_OVS_VERSION=v2.10.1
ARG IMG_SRC_DIR=/usr/src
ENV OVS_DIR=${IMG_SRC_DIR}/ovs

WORKDIR ${IMG_SRC_DIR}
RUN git clone https://github.com/openvswitch/ovs.git -b ${IMG_OVS_VERSION}

