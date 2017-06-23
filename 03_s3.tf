resource "aws_s3_bucket" "kube-artifacts-repository" {
  bucket = "${var.KubeArtifactsRepositoryBucketName}"
  acl = "private"
  policy = "${data.aws_iam_policy_document.kube-artifacts-repository.json}"

  tags  = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "etcd"

  # FIXME not able to find out a way to get the object with SSE
  # kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"

  source = "${var.ArtifactConfiguration["etcd.outputFile"]}"
  content_type = "application/octet-stream"
  depends_on = ["data.external.DownloadEtcd"]

  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "kube" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "kube"

  # kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"

  source = "${var.ArtifactConfiguration["kube.outputFile"]}"
  content_type = "application/octet-stream"
  depends_on = ["data.external.DownloadKube"]

  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "docker" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "docker"

  # kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"

  source = "${var.ArtifactConfiguration["docker.outputFile"]}"
  content_type = "application/octet-stream"
  depends_on = ["data.external.DownloadDocker"]

  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd_instance" {
  count = "${var.EtcdInstanceCount}"
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "etcd-${count.index}"
  content = "${element(aws_instance.etcd.*.private_ip, count.index)}"

  tags = "${var.CommonTags}"
}