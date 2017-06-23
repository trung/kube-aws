#!/bin/bash

# Download docker tar ball distribution from S3
pushd /tmp
mkdir kubernetes
pushd kubernetes
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${object} --output kubernetes.tar.gz
tar xfvz kubernetes.tar.gz
cp kubernetes/kubernetes/bin/* /usr/local/bin/
popd
rm -rf kubernetes*

# Run kubelet

# Run kube-proxy

