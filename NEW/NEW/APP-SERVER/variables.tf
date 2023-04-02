variable "region" {
  type    = string
  default = "us-west-1"
}

variable "access_key" {
  type    = string
  default = "AKIAW5TLSF2V7LQZE5G2"
}

variable "secret_key" {
  type    = string
  default = "JrDld6V4SV5ukNrjbFQP/au7s0iXU5PWL17OpPUc"
}

variable "vpc_cidr_block" {
  type    = string
  default = "50.20.0.0/16"
}

variable "ig_id" {
  type = string
  default = ""
}

variable "cidr_blocks_pool" {
  type = list(string)
  default = [""]
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "us-west-1a"
}

variable "private_ips" {
  type    = list(any)
  default = ["10.0.1.8"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "device_index" {
  type    = number
  default = "0"
}

variable "ami" {
  type    = string
  default = "ami-00756a2b7a21e2bd3"
}

variable "is_public" {
  type = bool
  default = false
}

variable "vpc_accostage" {
    type = string
    default = ""
}