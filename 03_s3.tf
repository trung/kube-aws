# Create one bucket and upload kube components into it with KMS Key

resource "aws_s3_bucket" "kube-artifacts-repository" {
  bucket = "kube-artifacts-repository"
  acl = "private"
  depends_on = ["data.external.DownloadEtcd"]
  tags  = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "etcd"
  kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"
  source = "${var.ArtifactConfiguration["etcd.outputFile"]}"
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