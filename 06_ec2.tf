# FIXME each AZ should have 3 instances

resource "aws_instance" "etcd" {
  count =  "${var.EtcdInstanceCount}"
  ami = "${var.EtcdAMI}"
  instance_type = "${var.EtcdInstanceType}"
  vpc_security_group_ids = ["${aws_security_group.common.id}", "${aws_security_group.ssh.id}", "${aws_security_group.etcd.id}"]
  subnet_id = "${aws_subnet.kubernetes.0.id}"
  key_name = "${var.KeyPairName}"
  associate_public_ip_address = true

  # this allows EC2 to CURL the S3 bucket
  iam_instance_profile = "s3_read_only"

  user_data = "${element(data.template_file.install_etcd.*.rendered, count.index)}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-etcd-%d", count.index)))}"
}

resource "aws_instance" "kube-master" {
  count = "${var.KubeMasterInstanceCount}"
  ami = "${var.KubeAMI}"
  instance_type = "${var.KubeMasterInstanceType}"

  vpc_security_group_ids = ["${aws_security_group.common.id}", "${aws_security_group.ssh.id}", "${aws_security_group.kube-master.id}"]
  subnet_id = "${aws_subnet.kubernetes.0.id}"
  key_name = "${var.KeyPairName}"
  associate_public_ip_address = true

  # this allows EC2 to CURL the S3 bucket
  iam_instance_profile = "s3_read_only"

  user_data = "${element(data.template_file.install_kube_master.*.rendered, count.index)}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-master-%d", count.index)))}"
}

resource "aws_instance" "kube-node" {
  count = "${var.KubeNodeInstanceCount}"
  ami = "${var.KubeAMI}"
  instance_type = "${var.KubeNodeInstanceType}"
  vpc_security_group_ids = ["${aws_security_group.common.id}", "${aws_security_group.ssh.id}", "${aws_security_group.kube-node.id}"]
  subnet_id = "${aws_subnet.kubernetes.0.id}"
  key_name = "${var.KeyPairName}"
  associate_public_ip_address = true

  # this allows EC2 to CURL the S3 bucket
  iam_instance_profile = "s3_read_only"

  user_data = "${element(data.template_file.install_kube_node.*.rendered, count.index)}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-node-%d", count.index)))}"
}