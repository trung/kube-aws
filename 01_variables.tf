variable "CommonTags" {
  type = "map"
  default = {
    builtBy = "trung"
    builtWith = "terraform"
  }
}

variable "KmsKeyAlias" {
  default = "trung-key"
}

variable "ArtifactConfiguration" {
  type = "map"
  default = {
    kube.url = "https://github.com/kubernetes/kubernetes/releases/download/v1.6.5/kubernetes.tar.gz"
    kube.outputFile = "./bin/kubernetes.tar.gz"
    etcd.url = "https://github.com/coreos/etcd/releases/download/v3.0.1/etcd-v3.0.1-linux-amd64.tar.gz"
    etcd.outputFile = "./bin/etcd.tar.gz"
  }
}