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

# Run it
/usr/local/bin/dockerd &


