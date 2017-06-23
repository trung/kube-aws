resource "aws_security_group" "kubernetes" {
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

  # S3 access
  egress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-DefaultSG"))}"
}