resource "random_string" "new_client_id" {
  length           = 8
  special          = false
}

resource "random_string" "random1" {
  length           = 8
  special          = false
}

resource "random_string" "random2" {
  length           = 8
  special          = false
}

variable "client_id" {
  type = string
  description = "New client id (needed if cluster exists and you want to add workers)"
  default = null
}

variable "root_password" {
  type = string
  description = "Template root password"
  default = "changeit"
}

variable "ansible_private_key" {
  type = string
  description = "Path to ansible private key"
  default = "/tmp/dummy/private.key"
}

variable "master_ip" {
  type = string
  description = "Master ip address"
}

variable "worker1_ip" {
  type = string
  description = "Worker 1 ip address"
}

variable "worker2_ip" {
  type = string
  description = "Worker 2 ip address"
}

variable "gateway_ip" {
  type = string
  description = "Worker 2 ip address"
}

locals {
  client_id = defaults(var.client_id, random_string.new_client_id.id)
}

data "vsphere_datacenter" "dc" {
  name = "ha_datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "default_cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "default_template"
  datacenter_id = data.vsphere_datacenter.dc.id
}