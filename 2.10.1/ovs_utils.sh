#!/bin/bash

set -x

export OVS_RUNTIME_DIR=/usr/local/var/run/openvswitch
export OVS_SHARE_DIR=/usr/local/share/openvswitch
export OVS_ETC_DIR=/usr/local/etc/openvswitch
export OVS_LOG_DIR=/usr/local/var/log/openvswitch
export PATH=$PATH:$OVS_SHARE_DIR/scripts


function ovsdb_reset {

	mkdir -p $OVS_ETC_DIR
	mkdir -p $OVS_LOG_DIR
	mkdir -p $OVS_RUNTIME_DIR
	rm -f $OVS_ETC_DIR/conf.db
	ovsdb-tool create $OVS_ETC_DIR/conf.db $OVS_SHARE_DIR/vswitch.ovsschema
	ovs-vsctl --no-wait init
}

function ovs_cmd {

        local ovs_exec="ovs-vsctl $OVS_MODIFIERS ${@:1}"
	eval "${ovs_exec}"
}

function ovs_clear_br {

        local br_inst=$1

        echo ".........................."
        echo "Deleting OF flows"
        ovs-ofctl del-flows ${br_inst}
        ports_list=$(ovs_cmd list-ports ${br_inst})
        for port_inst in ${ports_list}; do
                echo "............................"
                echo "Removing port from bridge:  [${br_inst}]-X   X/${port_inst}/"
                pci_addr=$(ovs_cmd get Interface ${port_inst} options:dpdk-devargs)
                ovs_cmd del-port ${port_inst}
                if [[ "${pci_addr}" != "" ]]
                then
                        echo "........................................."
                        echo "Detaching PCI (possible benign error):   [${br_inst}]-X   X${pci_addr}"
                        echo ${pci_addr} | xargs ovs-appctl netdev-dpdk/detach
                fi
        done
}

function ovs_delete_br {

        local br_inst=$1

        if [[ -z ${br_inst} ]]
        then
                local br_list=$(ovs_cmd list-br)
                for br_inst in ${br_list}; do
                        ovs_clear_br ${br_inst}
                done
                echo ".........................."
                echo "Deleting QoS"
                ovs_cmd -- --all destroy QoS -- --all destroy Queue
                echo ".........................."
                echo "Deleting bridges:         $(echo ${br_list})"
                for br_inst in ${br_list}; do
			ovs_cmd del-br ${br_inst}
			ip link delete ${br_inst}
                done
                echo "========================================================================="
                echo "DONE CLEARING OVS"
                echo "========================================================================="
                echo "========================================================================="
                echo
                rm -f $(pwd)/.ovs_ulog.log
        else
                ovs_clear_br ${br_inst}
		ovs_cmd del-br ${br_inst}
		ip link delete ${br_inst}
        fi
}

function ovs_wipeout {

	ovs_delete_br
	ovs-ctl stop
	ovsdb_reset
}

function ovsdb_server_start {

	ovsdb-server \
		--remote=punix:$OVS_RUNTIME_DIR/db.sock \
		--remote=db:Open_vSwitch,Open_vSwitch,manager_options \
		--pidfile --detach --log-file
	ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
}

function ovs_restart {

	ovs-ctl --no-ovsdb-server --db-sock="$OVS_RUNTIME_DIR/db.sock" restart
	ovs-vsctl get Open_vSwitch . dpdk_initialized
	ovs-vswitchd --version
	ovs-vsctl get Open_vSwitch . dpdk_version
	ovs-ctl status
}

set +x

