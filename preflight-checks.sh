#!/usr/bin/env bash

function check_required_sw {
    if ! go version &> /dev/null; then
        echo "Go not installed"
        return 1
    fi

    if ! kind version &> /dev/null; then
        echo "kind not installed"
        return 1
    fi

    if ! docker version &> /dev/null; then
        echo "docker not installed"
        return 1
    fi

    if ! kubectl &> /dev/null; then
        echo "kubectl not installed"
        return 1
    fi

    if ! helm version &> /dev/null; then
        echo "helm not installed"
        return 1
    fi

    return 0
}