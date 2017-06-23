resource "aws_security_group" "kube-master" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  ingress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-master"))}"
}

resource "aws_security_group" "kube-node" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  egress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-node"))}"
}

resource "aws_security_group" "etcd" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  # etcd metrics
  ingress {
    from_port = 2379
    protocol = "TCP"
    to_port = 2379
    cidr_blocks = ["${var.MyIP}"]
  }

  # etcd cluster
  ingress {
    from_port = 2379
    protocol = "TCP"
    to_port = 2380
    cidr_blocks = ["${var.VpcCidr}"]
  }

  egress {
    from_port = 2379
    protocol = "TCP"
    to_port = 2380
    cidr_blocks = ["${var.VpcCidr}"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-etcd"))}"
}

resource "aws_security_group" "common" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  # S3 access
  egress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-common"))}"
}

resource "aws_security_group" "ssh" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  # ssh
  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["${var.MyIP}"]
  }

  # ping
  ingress {
    from_port = 8
    protocol = "ICMP"
    to_port = -1
    cidr_blocks = ["${var.MyIP}"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-debug"))}"
}