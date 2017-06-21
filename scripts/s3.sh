#!/bin/bash

hmacsha256() {
  echo "$1" | openssl dgst -binary -sha256 -hmac "$2"
}

instance_profile=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/`
aws_access_key_id=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`
aws_secret_access_key=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`
token=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | sed -n '/Token/{p;}' | cut -f4 -d'"'`

date="`date -u +'%Y%m%d'T'%H%M%S'Z`"
date_short="`date -u +'%Y%m%d'`"
file="etcd"
bucket="kube-artifacts-repository"
resource="/${bucket}/${file}"
region="us-west-1"
service_name="s3"

headers=(
"content-type:application/octet-stream",
"x-amz-date:${date}",
"x-amz-server-side-encryption:aws:kms",
"x-amz-security-token:${token}"
)

canonical_headers=""
curl_headers=""
header_names=""
idx=0
while [ "x${headers[idx]}" != "x" ]
do
  canonical_headers="${canonical_headers}\n${headers[idx]}"
  curl_headers="${curl_headers} -H ${headers[idx]}"
  header_names="$(echo ${headers[idx]} | cut -d':' -f1);"
  idx=$(( $idx + 1 ))
done

canonical_request="GET\n${resource}${canonical_headers}"
hashed_canonical_request=$(echo "${canonical_request}" | sha256sum | awk '{print $1}')
scope="${date_short}/${region}/${service_name}/aws4_request"

string_to_sign="AWS4-HMAC-SHA256\n${date}\n${scope}\n${hashed_canonical_request}"

kSecret="${aws_secret_access_key}"
kDate=$(hmacsha256  "AWS4${kSecret}" "${date_short}")
kRegion=$(hmacsha256 "${kDate}" "${region}")
kService=$(hmacsha256 "${kRegion}" "${service_name}")
kSigning=$(hmacsha256 "${kService}" "aws4_request" | base64)

signature=$(hmacsha256 "${kSigning}", "${string_to_sign}")
authorization="AWS4-HMAC-SHA256 Credential=${aws_access_key_id}/${scope}, SignedHeaders=${header_names::-1}, Signature=${signature}"

curl -v -s ${curl_headers} -H "Authorization: ${authorization}" "https://s3-us-west-1.amazonaws.com${resource}"  # -o "etcd.tar.gz"