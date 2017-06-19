resource "aws_s3_bucket" "kube-artifacts-repository" {
  bucket = "kube-artifacts-repository"
  acl = "private"

  tags  = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "etcd"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${var.ArtifactConfiguration["etcd.outputFile"]}"
  content_type = "application/octet-stream"
  depends_on = ["data.external.DownloadEtcd"]

  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "kube" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "kube"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${var.ArtifactConfiguration["kube.outputFile"]}"
  content_type = "application/octet-stream"
  depends_on = ["data.external.DownloadKube"]

  tags = "${var.CommonTags}"
}
