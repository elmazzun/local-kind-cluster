#!/usr/bin/env bash

check_required_sw() {
    if ! kind version &> /dev/null; then
        echo "kind not installed, installing it..."
        pushd /tmp

        curl -Lo \
            kind \
            https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64

        sudo install \
            -o "$USER" \
            -g "$USER" \
            -m 0755 \
            kind /usr/local/bin/kind

        popd
    fi

    if ! docker version &> /dev/null; then
        echo "Docker not installed, installing it..."
        readonly DOCKER_URL="https://download.docker.com/linux/debian/dists"
        readonly DOCKER_PATH="bookworm/pool/stable/amd64"
        pushd /tmp

        curl -Lo containerd.io_1.6.16-1_amd64.deb \
            $DOCKER_URL/$DOCKER_PATH/containerd.io_1.6.16-1_amd64.deb

        curl -Lo docker-ce_24.0.5-1~debian.12~bookworm_amd64.deb \
            $DOCKER_URL/$DOCKER_PATH/docker-ce_24.0.5-1~debian.12~bookworm_amd64.deb

        curl -Lo docker-ce-cli_24.0.5-1~debian.12~bookworm_amd64.deb  \
            $DOCKER_URL/$DOCKER_PATH/docker-ce-cli_24.0.5-1~debian.12~bookworm_amd64.deb
        
        curl -Lo docker-buildx-plugin_0.11.2-1~debian.12~bookworm_amd64.deb \
            $DOCKER_URL/$DOCKER_PATH/docker-buildx-plugin_0.11.2-1~debian.12~bookworm_amd64.deb

        sudo dpkg -i containerd.io_1.6.16-1_amd64.deb \
            docker-ce_24.0.5-1~debian.12~bookworm_amd64.deb \
            docker-ce-cli_24.0.5-1~debian.12~bookworm_amd64.deb  \
            docker-buildx-plugin_0.11.2-1~debian.12~bookworm_amd64.deb

        # rootless Docker
        sudo groupadd docker
        sudo usermod -aG docker "$USER"
        newgrp docker

        popd
    fi

    if ! kubectl &> /dev/null; then
        echo "kubectl not installed, installing it..."
        pushd /tmp

        curl -Lo \
            kubectl \
            "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"

        sudo install \
            -o "$USER" \
            -g "$USER" \
            -m 0755 \
            kubectl /usr/local/bin/kubectl

        popd
    fi

    if ! helm &> /dev/null; then
        echo "helm not installed, installing it..."
        pushd /tmp

        curl -Lo \
            helm-v3.12.3-linux-amd64.tar.gz \
            https://get.helm.sh/helm-v3.12.3-linux-amd64.tar.gz

        tar -xf \
            helm-v3.12.3-linux-amd64.tar.gz \
            linux-amd64/helm

        sudo install \
            -o "$USER" \
            -g "$USER" \
            -m 0755 \
            linux-amd64/helm /usr/local/bin/helm

        popd
    fi
}
