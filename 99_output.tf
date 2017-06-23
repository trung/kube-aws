output "AZCount" {
  value = "${var.region}: ${data.aws_availability_zones.available.count}"
}
/*
output "EC2Etcd1" {
  value = "${format("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i trung-ec2-key-us-west-1.pem ubuntu@%s", aws_instance.etcd.0.public_ip)}"
}

output "EC2Etcd2" {
  value = "${format("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i trung-ec2-key-us-west-1.pem ubuntu@%s", aws_instance.etcd.1.public_ip)}"
}

output "EC2Etcd3" {
  value = "${format("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i trung-ec2-key-us-west-1.pem ubuntu@%s", aws_instance.etcd.2.public_ip)}"
}
*/

output "KubeMaster1" {
  value = "${format("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i trung-ec2-key-us-west-1.pem ubuntu@%s", aws_instance.kube-master.0.public_ip)}"
}

output "KubeNode1" {
  value = "${format("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i trung-ec2-key-us-west-1.pem ubuntu@%s", aws_instance.kube-node.0.public_ip)}"
}

output "KubeNode2" {
  value = "${format("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i trung-ec2-key-us-west-1.pem ubuntu@%s", aws_instance.kube-node.1.public_ip)}"
}