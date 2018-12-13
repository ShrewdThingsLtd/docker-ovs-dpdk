
ARG IMG_BASE
ARG IMG_TGT_IP
ARG IMG_TGT_USER
ARG IMG_TGT_PASS
RUN echo "IMG_TGT_IP:$IMG_TGT_IP"

ENV TGT_IP=$IMG_TGT_IP
ENV TGT_USER=$IMG_TGT_USER
ENV TGT_PASS=$IMG_TGT_PASS

FROM $IMG_BASE
RUN echo "IMG_BASE:$IMG_BASE"

ARG IMG_OVS_REPO
ARG IMG_OVS_VERSION

ENV OVS_REPO="${IMG_OVS_REPO}"
ENV OVS_VERSION=$IMG_OVS_VERSION
ENV OVS_DIR=${SRC_DIR}/ovs

COPY utils/*.sh ${SRC_DIR}/utils/

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/ovs_utils.sh; \
	exec_apt_install "$(ovs_prerequisites)"
#RUN exec_apt_clean

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/git_utils.sh; \
	. ${SRC_DIR}/utils/ovs_utils.sh; \
	ovs_clone

WORKDIR ${OVS_DIR}
