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
}

variable "root_password" {
  type = string
  description = "Template root password"
}

variable "ansible_private_key" {
  type = string
  description = "Path to ansible private key"
}

locals {
  client_id = defaults(variable.client_id, random_string.new_client_id)
}

data "vsphere_datacenter" "dc" {
  name = "ha_datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "default_datastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "default_cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "internet"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "master" {
  name             = "${locals.client_id}-master"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  num_cores_per_socket = 4
  memory   = 16384
  guest_id = "debian11_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${locals.client_id}-master-vmdk"
    size  = 50
    thin_provisioned = true
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = "root"
      password    = variable.root_password
    }
  }
}

resource "vsphere_virtual_machine" "worker1" {
  name             = "${locals.client_id}-${random_string.random1}-worker"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  num_cores_per_socket = 2
  memory   = 8192
  guest_id = "debian11_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${locals.client_id}-${random_string.random1}-worker"
    size  = 20
    thin_provisioned = true
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = "root"
      password    = variable.root_password
    }
  }
}

resource "vsphere_virtual_machine" "worker2" {
  name             = "${locals.client_id}-${random_string.random2}-worker"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  num_cores_per_socket = 2
  memory   = 8192
  guest_id = "debian11_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${locals.client_id}-${random_string.random2}-worker"
    size  = 20
    thin_provisioned = true
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = "root"
      password    = variable.root_password
    }
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/ansible/inventories/cluster.yml"
  content     = <<-EOF
    all:
      hosts:
        ${vsphere_virtual_machine.master.name}:
          ansible_host: ${vsphere_virtual_machine.master.default_ip_address}
          cloud_function: master
        ${vsphere_virtual_machine.worker1.name}:
          ansible_host: ${vsphere_virtual_machine.worker1.default_ip_address}
          cloud_function: worker
        ${vsphere_virtual_machine.worker2.name}:
          ansible_host: ${vsphere_virtual_machine.worker2.default_ip_address}
          cloud_function: worker
  EOF
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u svcansible -e client_id=${locals.client_id} -i ${local_file.inventory.filename} --private-key ${variable.ansible_private_key} ./ansible/play_configure_cluster.yml"
  }
}

output "client_id" {
  depends_on = [null_resource.ansible]
  description = "Client informations"
  value = "Cluster IP for client ${locals.client_id} is ${vsphere_virtual_machine.master.default_ip_address}"
}

