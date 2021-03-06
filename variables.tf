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

variable "skip_tags" {
  type = string
  description = "Tags to skip"
  default = ""
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
  name          = "ZUR-DEB-TEMPLATE"
  datacenter_id = data.vsphere_datacenter.dc.id
}