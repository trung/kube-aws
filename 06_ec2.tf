resource "aws_instance" "etcd" {
  count = 3
  ami = "${var.EtcdAMI}"
  instance_type = "t2.micro"

  subnet_id = "${aws_subnet.kubernetes[0].id}"

}