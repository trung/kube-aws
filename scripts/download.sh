#!/usr/bin/env bash

url=$1
file=$2

# Don't need to download if url hash not changed and file exists

url_hash_file="${file}.url.md5"
prev_url_hash_value=$(cat ${url_hash_file} 2>/dev/null)
current_url_hash_value=$(echo "$url" | md5)

if [ "${prev_url_hash_value}" == "${current_url_hash_value}" ] && [ -f "${file}" ]
then
    echo "{\"download\" : \"false\"}"
else
    curl -k -s -L -X GET ${url} --output ${file}
    echo "${current_url_hash_value}" > ${url_hash_file}
    echo "{\"download\" : \"true\"}"
fi