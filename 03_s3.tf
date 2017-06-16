# Create one bucket and upload kube components into it with KMS Key

resource "aws_s3_bucket" "kube-artifacts-repository" {
  bucket = "kube-artifacts-repository"
  acl = "private"
  provisioner "local-exec" {
    command = "curl -k -L ${var.ArtifactConfiguration["etcd.url"]} --output ${var.ArtifactConfiguration["etcd.outputFile"]}"
  }

  tags  = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "etcd"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${file(var.ArtifactConfiguration["etcd.outputFile"])}"
  content_type = "application/octet-stream"

  tags = "${var.CommonTags}"
}

/*
resource "aws_s3_bucket_object" "kube" {
  bucket = "${aws_s3_bucket.kube-artifacts.bucket}"
  key = "kube"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  content = "${data.http.DownloadKube}"
  tags = "${var.CommonTags}"
}
*/