output "EtcdS3Url" {
  value = "${format("https://%s.amazonaws.com/%s/%s", aws_s3_bucket.kube-artifacts-repository.region, aws_s3_bucket.kube-artifacts-repository.bucket, aws_s3_bucket_object.etcd.key)}"
}

output "KubeS3Url" {
  value = "${format("https://%s.amazonaws.com/%s/%s", aws_s3_bucket.kube-artifacts-repository.region, aws_s3_bucket.kube-artifacts-repository.bucket, aws_s3_bucket_object.kube.key)}"
}