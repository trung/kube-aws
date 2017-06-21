resource "aws_instance" "etcd" {
  count = "${aws_subnet.kubernetes.count}"
  ami = "${var.EtcdAMI}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
  subnet_id = "${element(aws_subnet.kubernetes.*.id, count.index)}"
  key_name = "${var.KeyPairName}"
  associate_public_ip_address = true

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-etcd-%d", count.index)))}"
}
