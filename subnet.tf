# Availability zones
data "aws_availability_zones" "zone" {}

resource "aws_subnet" "public" {
    count                     = "${var.public_subnet_count}"
    availability_zone         = "${data.aws_availability_zones.zone.names[count.index]}"
    vpc_id                    = "${aws_vpc.vpc.id}"
    cidr_block                = "${cidrsubnet(aws_vpc.vpc.cidr_block, 3, count.index)}"

    tags {
      owner                   = "${var.tag_owner}"
      Name                    = "${var.tag_environment}_public_${count.index}"
      Description             = "${var.tag_description}"
      email                   = "${var.tag_email}"
      cost_code               = "${var.tag_cost}"
      environment             = "${var.tag_environment}"
    }
}
