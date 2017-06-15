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

variable "KubeComponents" {
  type = "map"
  default = {
    etcd = "kube-components/"
    controller = "kube-components/"
    worker = "kube-components/"
  }
}