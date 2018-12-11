FROM shrewdthingsltd/docker-ovs-dpdk:ovs-2.10.1-prebuild

RUN apt-get -y install iproute2 kmod sudo

WORKDIR ${OVS_DIR}
RUN . ${DPDK_DIR}/dpdk_env.sh && ./boot.sh
#  && sed -i s/DPDK_EXTRA_LIB="-lfuse"/#DPDK_EXTRA_LIB="-lfuse"/ ./configure \
RUN . ${DPDK_DIR}/dpdk_env.sh && ./configure --with-dpdk=${DPDK_DIR}/${DPDK_TARGET}
RUN . ${DPDK_DIR}/dpdk_env.sh && make install CFLAGS='-O3 -march=native'
#RUN . ${DPDK_DIR}/dpdk_env.sh && make clean

ARG IMG_SRC_DIR=/usr/src
WORKDIR ${IMG_SRC_DIR}
COPY run_ovs.sh run_ovs.sh

CMD ["./run_ovs.sh"]

