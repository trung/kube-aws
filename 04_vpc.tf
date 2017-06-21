resource "aws_vpc" "kubernetes" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-VPC"))}"
}

resource "aws_internet_gateway" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-GW"))}"
}

resource "aws_subnet" "kubernetes" {
  count = "${data.aws_availability_zones.available.count}"
  cidr_block = "10.10.${count.index + 1}.0/24"
  vpc_id = "${aws_vpc.kubernetes.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-%s", data.aws_availability_zones.available.names[count.index])))}"
}

resource "aws_default_route_table" "kubernetes" {
  default_route_table_id = "${aws_vpc.kubernetes.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kubernetes.id}"
  }
  
  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-DefaultRoute"))}"

}

resource "aws_route_table_association" "kubernetes" {
  count = "${aws_subnet.kubernetes.count}"
  route_table_id = "${aws_default_route_table.kubernetes.id}"
  subnet_id = "${element(aws_subnet.kubernetes.*.id, count.index)}"
}