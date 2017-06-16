data "aws_kms_alias" "KmsKey" {
  name = "alias/${var.KmsKeyAlias}"
}

/*
data "external" "DownloadKube" {
  program = ["sh", "./scripts/download.sh"]

  query = {
    url = "${var.ArtifactConfiguration["kube.url"]}"
    outputFile = "${var.ArtifactConfiguration["kube.outputFile"]}"
  }
}

data "external" "DownloadEtcd" {
  program = ["sh", "./scripts/download.sh"]

  query = {
    url = "${var.ArtifactConfiguration["etcd.url"]}"
    outputDir = "${var.ArtifactConfiguration["etcd.outputFile"]}"
  }
}
*/