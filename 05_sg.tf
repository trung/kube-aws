resource "aws_security_group" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["${var.MyIP}"]
  }

  ingress {
    from_port = 8
    protocol = "ICMP"
    to_port = -1
    cidr_blocks = ["${var.MyIP}"]
  }

  egress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-DefaultSG"))}"
}