
ARG IMG_BASE=shrewdthingsltd/docker-ovs-dpdk:ovs-v2.10.1-prebuild

FROM $IMG_BASE

COPY utils/*.sh ${SRC_DIR}/utils/

RUN \
	. ${SRC_DIR}/utils/exec_utils.sh; \
	. ${SRC_DIR}/utils/ovs_utils.sh; \
	. ${SRC_DIR}/app_env.sh; \
	ovs_build

COPY ovs_run.sh ${SRC_DIR}/

WORKDIR ${SRC_DIR}

CMD ["./ovs_run.sh"]
