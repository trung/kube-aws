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

# this allows EC2 to access S3 privately
resource "aws_vpc_endpoint" "s3-kube-artifacts-repository" {
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_id = "${aws_vpc.kubernetes.id}"
  policy = "${data.aws_iam_policy_document.kube-artifacts-repository.json}"
}

resource "aws_vpc_endpoint_route_table_association" "s3-kube-artifacts-repository" {
  route_table_id = "${aws_default_route_table.kubernetes.id}"
  vpc_endpoint_id = "${aws_vpc_endpoint.s3-kube-artifacts-repository.id}"
}