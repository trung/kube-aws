# Create one bucket and upload kube components into it with KMS Key

resource "aws_s3_bucket" "kube-artifacts" {
  bucket = "kube-artifacts"
  acl = "private"

  tags  = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd" {
  bucket = "${aws_s3_bucket.kube-artifacts.bucket}"
  key = "etcd"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${file(var.KubeComponents["etcd"])}"
  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "controller" {
  bucket = "${aws_s3_bucket.kube-artifacts.bucket}"
  key = "controller"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${file(var.KubeComponents["controller"])}"
  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "worker" {
  bucket = "${aws_s3_bucket.kube-artifacts.bucket}"
  key = "worker"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${file(var.KubeComponents["worker"])}"
  tags = "${var.CommonTags}"
}