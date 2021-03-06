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

data "external" "DownloadDocker" {
  program = ["sh",
    "./scripts/download.sh",
    "${var.ArtifactConfiguration["docker.url"]}",
    "${var.ArtifactConfiguration["docker.outputFile"]}"
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

data "aws_iam_policy_document" "kube-docker-repository" {
  statement {
    sid = "Access-to-kube-docker-repository-only"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${var.KubeDockerRepositoryBucketName}",
      "arn:aws:s3:::${var.KubeDockerRepositoryBucketName}/*",
    ]
    condition {
      test = "IpAddress"
      variable = "aws:SourceIp"
      values = [
        "${var.MyIP}",
        "${var.VpcCidr}"
      ]
    }
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
  }
}

data "template_file" "install_etcd" {
  count = "${var.EtcdInstanceCount}"
  template = "${file("./scripts/tpl/install_etcd.tpl.sh")}"
  vars {
    region = "${var.region}"
    bucket = "${aws_s3_bucket.kube-artifacts-repository.id}"
    object = "${aws_s3_bucket_object.etcd.key}"
    instance_number = "${count.index}"
    instance_count = "${var.EtcdInstanceCount}"
  }
}

data "template_file" "install_kube_node" {
  count = "${var.KubeNodeInstanceCount}"
  template = "${file("./scripts/tpl/install_kube_node.tpl.sh")}"
  vars {
    region = "${var.region}"
    bucket = "${aws_s3_bucket.kube-artifacts-repository.id}"
    kube_object = "${aws_s3_bucket_object.kubernetes.key}"
    docker_object = "${aws_s3_bucket_object.docker.key}"
    # FIXME we just need master IP here, ideally it should be a ELB IP
    master_ip = "${element(aws_instance.kube-master.*.private_ip, 0)}"
    vpc_cidr = "${var.VpcCidr}"
  }
}

data "template_file" "install_kube_master" {
  count = "${var.KubeNodeInstanceCount}"
  template = "${file("./scripts/tpl/install_kube_master.tpl.sh")}"
  vars {
    region = "${var.region}"
    bucket = "${aws_s3_bucket.kube-artifacts-repository.id}"
    kube_object = "${aws_s3_bucket_object.kubernetes.key}"
    docker_object = "${aws_s3_bucket_object.docker.key}"
    etcd_ips = "${join(" ", aws_instance.etcd.*.private_ip)}"
    vpc_cidr = "${var.VpcCidr}"
  }
}