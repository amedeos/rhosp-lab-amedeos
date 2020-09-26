source /home/stack/stackrc
#!/bin/bash
OSP_VERS={{ osp_version }}
if [ "${OSP_VERS}" -gt 13 ]; then
	OCTAVIA_FILE="/usr/share/openstack-tripleo-heat-templates/environments/services/octavia.yaml"
else
	OCTAVIA_FILE="/usr/share/openstack-tripleo-heat-templates/environments/services-docker/octavia.yaml"
fi

if [ "${OSP_VERS}" -gt 14 ]; then
	TLS_FILE="/home/stack/templates/environments/40-enable-tls-15.yaml"
else
	TLS_FILE="/home/stack/templates/environments/40-enable-tls.yaml"
fi

exec openstack overcloud deploy \
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
	-e ${OCTAVIA_FILE} \
	-e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-rgw.yaml \
        -e /home/stack/templates/environments/25-hostname-map.yaml \
        -e /home/stack/templates/environments/30-fixed-ip-vips.yaml \
        -e /home/stack/templates/environments/30-ips-from-pool-all.yaml \
	-e ${TLS_FILE} \
        -e /home/stack/templates/environments/45-inject-trust-anchor.yaml \
        -e /home/stack/templates/environments/35-ceph-config.yaml \
        -e /home/stack/templates/environments/55-rsvd_host_memory.yaml \
	-e /home/stack/templates/fencing.yaml \
        --log-file /home/stack/overcloud-deploy.log
