resource "aws_s3_bucket" "kube-artifacts-repository" {
  bucket = "${var.KubeArtifactsRepositoryBucketName}"
  acl = "private"
  policy = "${data.aws_iam_policy_document.kube-artifacts-repository.json}"

  tags  = "${var.CommonTags}"
}

resource "aws_s3_bucket" "kube-docker-repository" {
  bucket = "${var.KubeDockerRepositoryBucketName}"
  acl = "private"
  policy = "${data.aws_iam_policy_document.kube-docker-repository.json}"

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

resource "aws_s3_bucket_object" "kubernetes" {
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "kubernetes"

  # kms_key_id = "${data.aws_kms_alias.KmsKey.arn}"

  source = "${var.ArtifactConfiguration["kube.outputFile"]}"
  content_type = "application/octet-stream"
  depends_on = ["data.external.DownloadKube"]

  # due to this artifact is HUGE so we don't want to destroy it
  /*
  lifecycle {
    prevent_destroy = true
    ignore_changes = []
  }*/

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

# TODO do we really need this?
resource "aws_s3_bucket_object" "kube-master-instance" {
  count = "${var.KubeMasterInstanceCount}"
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "kube-master-instance-${count.index}"
  content = "${element(aws_instance.kube-master.*.private_ip, count.index)}"

  tags = "${var.CommonTags}"
}

resource "aws_s3_bucket_object" "etcd_instance" {
  count = "${var.EtcdInstanceCount}"
  bucket = "${aws_s3_bucket.kube-artifacts-repository.bucket}"
  key = "etcd-${count.index}"
  content = "${element(aws_instance.etcd.*.private_ip, count.index)}"

  tags = "${var.CommonTags}"
}