resource "aws_instance" "etcd" {
  count = "${aws_subnet.kubernetes.count}"
  ami = "${var.EtcdAMI}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
  subnet_id = "${aws_subnet.kubernetes.*.id}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-etcd-%s", count.index)))}"

  provisioner "remote-exec" {
    inline = [
      "aws s3 cp ${aws_bu}"
    ]
  }
}
