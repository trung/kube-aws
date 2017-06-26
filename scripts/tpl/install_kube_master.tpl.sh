#!/bin/bash

# metainf
etcd_servers=""
for ip in ${etcd_ips}
do
    etcd_servers="http://$$ip:2379,$${etcd_servers}"
done
mkdir -p /etc/kubernetes/logs
apiserver_log="/etc/kubernetes/logs/apiserver.log"
controllermanager_log="/etc/kubernetes/logs/controllermanager.log"
scheduler_log="/etc/kubernetes/logs/scheduler.log"
cat >/etc/kubernetes/metainf <<EOF
etcd instances IPs: \$${etcd_servers}
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

# Download Kubernetes binaries from S3
pushd /tmp
mkdir kubernetes
pushd kubernetes
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${kube_object} --output kubernetes.tar.gz
tar xfvz kubernetes.tar.gz
cp kubernetes/server/bin/* /usr/local/bin/
popd
rm -rf kubernetes


# Start apiserver, controller manager and scheduler

/usr/local/bin/kube-apiserver \
  --etcd-servers=$${etcd_servers} \
  --insecure-bind-address=0.0.0.0 \
  --insecure-allow-any-token demo/system \
  --service-cluster-ip-range=${vpc_cidr} > $${apiserver_log} 2>&1 &

/usr/local/bin/kube-controller-manager \
  --master localhost:8080 \
  --cluster-cidr=${vpc_cidr} > $${controllermanager_log} 2>&1 &

/usr/local/bin/kube-scheduler \
  --master localhost:8080  > $${scheduler_log} 2>&1 &

