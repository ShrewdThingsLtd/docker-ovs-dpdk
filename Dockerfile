
ARG IMG_BASE=shrewdthingsltd/docker-dpdk:dpdk-v17.11-rc4

FROM $IMG_BASE
RUN echo "IMG_BASE:$IMG_BASE"

ARG IMG_OVS_REPO="https://github.com/openvswitch/ovs.git"
ARG IMG_OVS_VERSION="v2.10.1"

ENV OVS_REPO="${IMG_OVS_REPO}"
ENV OVS_VERSION=$IMG_OVS_VERSION
ENV OVS_DIR=${SRC_DIR}/ovs

RUN echo "IMG_TGT_IP:$IMG_TGT_IP"

COPY utils/*.sh ${SRC_DIR}/utils/

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/ovs_utils.sh; \
	ovs_clone

WORKDIR ${OVS_DIR}
