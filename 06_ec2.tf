# FIXME each AZ should have 3 instances
resource "aws_instance" "etcd" {
  count =  "${var.EtcdInstanceCount}"
  ami = "${var.EtcdAMI}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
  subnet_id = "${aws_subnet.kubernetes.0.id}"
  key_name = "${var.KeyPairName}"
  associate_public_ip_address = true

  # this allows EC2 to CURL the S3 bucket
  iam_instance_profile = "s3_read_only"

  user_data = "${element(data.template_file.install_etcd.*.rendered, count.index)}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-etcd-%d", count.index)))}"
}
