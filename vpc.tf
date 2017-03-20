resource "aws_vpc" "vpc" {
    cidr_block                = "${var.vpc_network}"
    enable_dns_hostnames      = true

    lifecycle {
      prevent_destroy         = false
    }

    tags {
      owner                   = "${var.tag_owner}"
      Name                    = "${var.tag_environment}_vpc"
      Description             = "${var.tag_description}"
      email                   = "${var.tag_email}"
      cost_code               = "${var.tag_cost}"
      environment             = "${var.tag_environment}"
    }
}

# Main Internet gateway.
resource "aws_internet_gateway" "internet" {
  vpc_id                      = "${aws_vpc.vpc.id}"
  tags {
    owner                     = "${var.tag_owner}"
    Name                      = "${var.tag_environment}_internet_gateway"
    Description               = "${var.tag_description}"
    email                     = "${var.tag_email}"
    cost_code                 = "${var.tag_cost}"
    environment               = "${var.tag_environment}"
  }
}
