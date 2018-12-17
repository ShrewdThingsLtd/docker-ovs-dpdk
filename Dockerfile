
ARG IMG_BASE=shrewdthingsltd/docker-ovs-dpdk:ovs-v2.10.1-prebuild

FROM $IMG_BASE

COPY utils/*.sh ${SRC_DIR}/utils/
COPY env/*.sh ${SRC_DIR}/env/

RUN . ${SRC_DIR}/app-entrypoint.sh; \
	ovs_build

WORKDIR ${OVS_DIR}

#CMD ["./ovs_run.sh"]

COPY runtime/*.sh ${SRC_DIR}/runtime/
