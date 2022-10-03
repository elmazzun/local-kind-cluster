#!/usr/bin/env bash

function check_required_sw {
    if ! go version &> /dev/null; then
        "Go not installed"
        return 1
    fi

    if ! docker version &> /dev/null; then
        "docker not installed"
        return 1
    fi

    return 0
}