variable "region" {
  default = "us-west-1"
}

variable "CommonTags" {
  type = "map"
  default = {
    builtBy = "trung"
    builtWith = "terraform"
    builtReason = "Provisioning Kubernetes in AWS"
  }
}

variable "VpcCidr" {
  default = "10.10.0.0/16"
}

variable "KubeArtifactsRepositoryBucketName" {
  default = "kube-artifacts-repository"
}

variable "KubeAMI" {
  default = "ami-9fe6c7ff"  # us-west-1
}

variable "KubeMasterInstanceType" {
  default = "t2.micro"
}

variable "KubeMasterInstanceCount" {
  default = 1
}

variable "KubeNodeInstanceType" {
  default = "t2.micro"
}

variable "KubeNodeInstanceCount" {
  default = 1
}

variable "EtcdInstanceType" {
  default = "t2.micro"
}


variable "EtcdInstanceCount" {
  default = 3
}

variable "EtcdAMI" {
  default = "ami-9fe6c7ff"  # us-west-1
}

variable "KubernetesAMI" {
  default = "ami-9fe6c7ff"  # us-west-1
}

variable "KmsKeyAlias" {
  default = "trung-key"
}

variable "MyIP" {
  description = "CIDR block to limit only to my IP"
}

variable "KeyPairName" {
  default = "trung-ec2-key"
}

variable "ArtifactConfiguration" {
  type = "map"
  default = {
    kube.url = "https://github.com/kubernetes/kubernetes/releases/download/v1.6.5/kubernetes.tar.gz"
    kube.outputFile = "./bin/kubernetes.tar.gz"
    etcd.url = "https://github.com/coreos/etcd/releases/download/v3.0.1/etcd-v3.0.1-linux-amd64.tar.gz"
    etcd.outputFile = "./bin/etcd.tar.gz"
    docker.url = "https://get.docker.com/builds/Linux/x86_64/docker-17.05.0-ce.tgz"
    docker.outputFile = "./bin/docker.tar.gz"
  }
}