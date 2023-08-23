#!/usr/bin/env bash

./scripts/create-cluster.sh && \
    sleep 5 && \
    ./scripts/setup-cluster.sh
