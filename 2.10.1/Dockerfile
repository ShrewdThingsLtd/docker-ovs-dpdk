FROM shrewdthingsltd/ovs-dpdk:prebuild

RUN . ${RTE_SDK}/dpdk_env.sh; \
  cd ${OVS_DIR} \
  && ./boot.sh \
#  && sed -i s/DPDK_EXTRA_LIB="-lfuse"/#DPDK_EXTRA_LIB="-lfuse"/ ./configure \
  && ./configure --with-dpdk=${RTE_SDK}/${RTE_TARGET} \
  && make install CFLAGS='-O3 -march=native' \
  && make clean

COPY run_ovs.sh run_ovs.sh

CMD ["./run_ovs.sh"]
