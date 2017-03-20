
resource "aws_route" "default" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet.id}"
}


# Private route table, per AZ
resource "aws_route_table" "public" {
  count                      = "${var.public_subnet_count}"
  vpc_id                     = "${aws_vpc.vpc.id}"

  tags {
    owner                     = "${var.tag_owner}"
    Name                      = "${var.tag_environment}_public_route_table_${count.index}"
    Description               = "Public Routing Table"
    email                     = "${var.tag_email}"
    cost_code                 = "${var.tag_cost}"
    environment               = "${var.tag_environment}"
  }
}
resource "aws_route" "public_default" {
  count                       = "${var.public_subnet_count}"
  route_table_id              = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = "${aws_internet_gateway.internet.id}"
}

# Assigns the private subnet to the private route table, per AZ
resource "aws_route_table_association" "public" {
  count                 = "${var.public_subnet_count}"
  subnet_id             = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id        = "${element(aws_route_table.public.*.id, count.index)}"
}
