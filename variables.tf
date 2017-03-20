variable "ami" {
  default = "ami-a192bad2"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "default_key_pair"
}


variable "tag_owner" {
  default = "Awais Awan"
}
variable "tag_description" {
  default = "NGINX Webserver"
}
variable "tag_email" {
  default = "awaisahmed@gmail.com"
}
variable "tag_cost" {
  default = "tbd"
}
variable "tag_environment" {
  default = "nginx"
}
variable "tag_project" {
  default = "nginx"
}
variable "public_subnet_count" {
  default = 2
}
variable "vpc_network" {
    default = "10.0.0.0/24"
}
variable "webserver_count" {
  default= 2
}
