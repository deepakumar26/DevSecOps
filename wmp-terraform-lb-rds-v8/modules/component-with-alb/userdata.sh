#!/bin/bash

sudo labauto ansible
ansible-pull -i localhost, -U https://github.com/deepakumar26/wmp-ansible-rds-v5.git main.yml -e env=${ENV} -e COMPONENT=${COMPONENT} -e postgres_rds_address=${postgres_rds_address}