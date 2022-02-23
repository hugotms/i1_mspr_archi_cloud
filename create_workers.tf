resource "vsphere_virtual_machine" "worker1" {
  name             = "${random_string.new_client_id.result}-${random_string.random1.result}-worker"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  num_cores_per_socket = 2
  memory   = 4096
  guest_id = "debian10_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "worker-label"
    datastore_id = data.vsphere_datastore.datastore.id
    size  = 20
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${random_string.new_client_id.result}-${random_string.random1.result}-worker"
        domain    = "geronimo.com"
      }

      network_interface {}

    /*
    Commented block as VMs will be in DHCP for testing purposes

      network_interface {
        ipv4_address = var.worker1_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway_ip

    */
    }
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = "root"
      password    = var.root_password
    }
  }
}

resource "vsphere_virtual_machine" "worker2" {
  name             = "${random_string.new_client_id.result}-${random_string.random2.result}-worker"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  num_cores_per_socket = 2
  memory   = 4096
  guest_id = "debian10_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "worker-system"
    datastore_id = data.vsphere_datastore.datastore.id
    size  = 20
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${random_string.new_client_id.result}-${random_string.random2.result}-worker"
        domain    = "geronimo.com"
      }

      network_interface {}

    /*
    Commented block as VMs will be in DHCP for testing purposes

      network_interface {
        ipv4_address = var.worker2_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway_ip

    */
    }
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = "root"
      password    = var.root_password
    }
  }
}