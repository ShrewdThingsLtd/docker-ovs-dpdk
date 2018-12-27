
ARG IMG_BASE=shrewdthingsltd/docker-ovs-dpdk:ovs-v2.10.1-prebuild

FROM $IMG_BASE

COPY app/utils/*.sh ${SRC_DIR}/utils/
COPY app/env/*.sh ${SRC_DIR}/env/
COPY app/entrypoint/*.sh ${SRC_DIR}/

RUN ovs_build

COPY app/runtime/*.sh ${SRC_DIR}/runtime/

WORKDIR ${OVS_DIR}

#CMD ["./ovs_run.sh"]
