data "aws_kms_alias" "KmsKey" {
  name = "alias/${var.KmsKeyAlias}"
}

data "aws_availability_zones" "available" {

}

data "external" "DownloadEtcd" {
  program = ["sh",
    "./scripts/download.sh",
    "${var.ArtifactConfiguration["etcd.url"]}",
    "${var.ArtifactConfiguration["etcd.outputFile"]}"
  ]
}

data "external" "DownloadKube" {
  program = ["sh",
    "./scripts/download.sh",
    "${var.ArtifactConfiguration["kube.url"]}",
    "${var.ArtifactConfiguration["kube.outputFile"]}"
  ]
}

data "aws_iam_policy_document" "kube-artifacts-repository" {
  statement {
    sid = "Access-to-kube-artifacts-repository-only"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${var.KubeArtifactsRepositoryBucketName}",
      "arn:aws:s3:::${var.KubeArtifactsRepositoryBucketName}/*",
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
  }
}

data "template_file" "install_etcd" {
  count = "${var.EtcdInstanceCount}"
  template = "${file("./scripts/install_etcd.tpl.sh")}"
  vars {
    region = "${var.region}"
    bucket = "${aws_s3_bucket.kube-artifacts-repository.id}"
    object = "${aws_s3_bucket_object.etcd.key}"
    instance_number = "${count.index}"
  }
}