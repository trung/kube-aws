#!/bin/bash

# metainf
mkdir -p /etc/kubernetes/logs
cat >/etc/kubernetes/metainf <<EOF
Master Intance Private IP: ${master_ip}
EOF

# Download docker tar ball distribution from S3
pushd /tmp
mkdir docker
pushd docker
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${docker_object} --output docker.tar.gz
tar xfvz docker.tar.gz
cp docker/docker* /usr/local/bin/
popd
rm -rf docker

# Run docker daemon
/usr/local/bin/dockerd &

# Download Kubernetes binary from s3
pushd /tmp
mkdir kubernetes
pushd kubernetes
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${kube_object} --output kubernetes.tar.gz
tar xfvz kubernetes.tar.gz
cp kubernetes/server/bin/* /usr/local/bin/
popd
rm -rf kubernetes

# Run kubelet
/usr/local/bin/kubelet \
   --api-servers=http://${master_ip}:8080 &

# Run kube-proxy
/usr/local/bin/kube-proxy \
   --master=http://${master_ip}:8080 \
   --cluster-cidr=${vpc_cidr} &