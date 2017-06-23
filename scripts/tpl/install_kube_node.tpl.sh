#!/bin/bash

# Download docker tar ball distribution from S3
pushd /tmp
mkdir docker
pushd docker
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${object} --output docker.tar.gz
tar xfvz docker.tar.gz
cp docker/docker* /usr/local/bin/
popd
rm -rf docker*

# Run docker daemon
/usr/local/bin/dockerd &

# Download Kubernetes binary from s3
pushd /tmp
mkdir kubernetes
pushd kubernetes
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${object} --output kubernetes.tar.gz
tar xfvz kubernetes.tar.gz
cp kubernetes/kubernetes/bin/* /usr/local/bin/
popd
rm -rf kubernetes*

# Run kubelet
#/usr/local/bin/kubelet \
#   --api-servers=https://${master_ip}

# Run kube-proxy

