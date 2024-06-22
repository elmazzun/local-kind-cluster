#!/usr/bin/env bash

# This file will invoke scripts that will create the cluster; before doing 
# that, YAML files will be edited accorded to components you wish to install;
# such components will be discovered after parsing config file.

# Exporting variables in config files so that they can be seen in 
# setup-cluster.sh
while read -r line; do
    [[ -n "$line" ]] && export "$line"
done < config

./scripts/create-cluster.sh && \
    sleep 5 && \
    ./scripts/setup-cluster.sh
