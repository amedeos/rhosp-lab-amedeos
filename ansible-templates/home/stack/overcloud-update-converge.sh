#!/bin/bash
OSP_VERS={{ osp_version }}
LOG_DATE=$(date +%Y%m%d-%H%M)
LOG_DIR=/home/stack/log-deploy
mkdir -p ${LOG_DIR}

source /home/stack/stackrc
time openstack overcloud update converge \
	--timeout 360 \
        --templates /usr/share/openstack-tripleo-heat-templates \
        --verbose \
        -n /home/stack/templates/environments/network_data.yaml \
        -r /home/stack/templates/osp-${OSP_VERS}/roles_data.yaml \
        -e /home/stack/templates/docker-registry.yaml \
        -e /home/stack/templates/environments/node-count.yaml \
        -e /home/stack/templates/environments/global-config.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/network-environment.yaml \
        -e /home/stack/templates/osp-${OSP_VERS}/network-environment.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-ip.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/octavia.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-rgw.yaml \
        -e /home/stack/templates/environments/25-hostname-map.yaml \
        -e /home/stack/templates/environments/30-fixed-ip-vips.yaml \
        -e /home/stack/templates/environments/30-ips-from-pool-all.yaml \
        -e /home/stack/templates/environments/40-enable-tls.yaml \
        -e /home/stack/templates/environments/45-inject-trust-anchor.yaml \
        -e /home/stack/templates/environments/35-ceph-config.yaml \
        -e /home/stack/templates/environments/55-rsvd_host_memory.yaml \
        -e /home/stack/templates/fencing.yaml | tee -a ${LOG_DIR}/overcloud-update-converge-${LOG_DATE}.log
