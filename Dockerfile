
ARG IMG_BASE=shrewdthingsltd/docker-dpdk:dpdk-v17.11-rc4

FROM $IMG_BASE

ARG IMG_OVS_REPO="https://github.com/openvswitch/ovs.git"
ARG IMG_OVS_VERSION="v2.10.1"

ENV OVS_REPO="${IMG_OVS_REPO}"
ENV OVS_VERSION=$IMG_OVS_VERSION
ENV OVS_DIR=${SRC_DIR}/ovs

COPY app/utils/*.sh ${SRC_DIR}/utils/
COPY app/env/*.sh ${SRC_DIR}/env/
COPY app/entrypoint/*.sh ${SRC_DIR}/

RUN ovs_clone

COPY app/runtime/*.sh ${SRC_DIR}/runtime/

WORKDIR ${OVS_DIR}
