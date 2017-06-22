output "AZCount" {
  value = "${var.region}: ${data.aws_availability_zones.available.count}"
}

output "EC2Etcd1" {
  value = "${format("%s - %s", aws_instance.etcd.0.public_dns, aws_instance.etcd.0.public_ip)}"
}

output "EC2Etcd2" {
  value = "${format("%s - %s", aws_instance.etcd.1.public_dns, aws_instance.etcd.1.public_ip)}"
}

output "EC2Etcd3" {
  value = "${format("%s - %s", aws_instance.etcd.2.public_dns, aws_instance.etcd.2.public_ip)}"
}

output "EtcdS3Url" {
  value = "${format("https://s3-%s.amazonaws.com/%s/%s", aws_s3_bucket.kube-artifacts-repository.region, aws_s3_bucket.kube-artifacts-repository.bucket, aws_s3_bucket_object.etcd.key)}"
}

output "KubeS3Url" {
  value = "${format("https://s3-%s.amazonaws.com/%s/%s", aws_s3_bucket.kube-artifacts-repository.region, aws_s3_bucket.kube-artifacts-repository.bucket, aws_s3_bucket_object.kube.key)}"
}