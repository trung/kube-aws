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