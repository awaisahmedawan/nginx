resource "aws_key_pair" "keypair" {
  key_name                    = "${var.tag_project}"
  public_key                  = "${file("${path.root}/keys/${var.tag_project}.pub")}"
}
