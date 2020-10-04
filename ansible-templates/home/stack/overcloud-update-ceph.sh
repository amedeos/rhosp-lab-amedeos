#!/bin/bash
OSP_VERS={{ osp_version }}
LOG_DATE=$(date +%Y%m%d-%H%M)
LOG_DIR=/home/stack/log-deploy
mkdir -p ${LOG_DIR}

source /home/stack/stackrc
time openstack overcloud update run --nodes Ceph | tee -a ${LOG_DIR}/overcloud-update-ceph-${LOG_DATE}.log

