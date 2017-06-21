resource "aws_security_group" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-DefaultSG"))}"

  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["${var.MyIP}"]
  }
}