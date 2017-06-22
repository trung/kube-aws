#!/bin/bash -v

# Download etcd tar ball distribution from S3
pushd /tmp
mkdir etcd
pushd etcd
curl -s -L https://s3-${region}.amazonaws.com/${bucket}/${object} --output etcd.tar.gz
tar xfvz etcd.tar.gz
cp etcd*/etcd* /usr/local/bin

# Setup etcd cluster
etcd_data_dir=/var/lib/etcd
my_ip=$(hostname -i)
instance_name="etcd-${instance_number}"
log_file="/var/log/etcd-bootstrap.log"

mkdir -p $${etcd_data_dir}
pushd $${etcd_data_dir}
cat >metainf <<EOF
$${my_ip}
$${instance_name}
EOF


cat >bootstrap.sh <<EOF
#!/bin/sh -v

count=0
cluster=""
while [ "$${count}" -eq "${instance_number}" ]
do
    instance_to_check="etcd-$${count}"
    data=$(curl -s -L https://s3-${region}.amazonaws.com/${bucket}/$${instance_to_check})
    if [[ "$$data" =~ .+NoSuchKey.+ ]]; then
        echo "Instance $${instance_to_check} not yet online" >> $$log_file
        sleep 3
    else
        echo "Cluster: $${cluster}" >> $$log_file
        cluster="http://$${data}:2380,$${cluster}"
    fi
done

/usr/local/bin/etcd --name $${instance_name} \
    --data-dir $${etcd_data_dir} \
    --listen-client-urls http://$${my_ip}:2379 \
    --advertise-client-urls http://$${my_ip}:2379 \
    --listen-peer-urls http://$${my_ip}:2380 \
    --initial-advertise-peer-urls http://$${my_ip}:2380 \
    --initial-cluster $$cluster \
    --initial-cluster-token a-very-random-token-foo-bar \
    --initial-cluster-state new &
EOF
chmod +x boostrap.sh
./bootstrap.sh &


