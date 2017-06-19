resource "aws_vpc" "kubernetes" {
  cidr_block = "10.10.0.0/16"

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-VPC"))}"
}

# We create subnets for all AZs but may take only 1 for
resource "aws_subnet" "kubernetes" {
  count = "${data.aws_availability_zones.available.count}"
  cidr_block = "10.10.${count.index + 1}.0/24"
  vpc_id = "${aws_vpc.kubernetes.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = "${merge(var.CommonTags, map("Name", format("Kubernetes-%s", data.aws_availability_zones.available.names[count.index])))}"
}

resource "aws_route_table" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  tags = "${merge(var.CommonTags, map("Name", "Kubernetes-DefaultRoute"))}"
}

resource "aws_route_table_association" "kubernetes" {
  count = "${aws_subnet.kubernetes.count}"
  route_table_id = "${aws_route_table.kubernetes.id}"
  subnet_id = "${aws_subnet.kubernetes.*.id}"
}