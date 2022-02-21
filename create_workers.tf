resource "vsphere_virtual_machine" "worker1" {
  name             = "${local.client_id}-${random_string.random1}-worker"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  num_cores_per_socket = 2
  memory   = 4096
  guest_id = "debian10_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${local.client_id}-${random_string.random1}-worker"
    size  = 20
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${local.client_id}-${random_string.random1}-worker"
        domain    = "geronimo.com"
      }

      network_interface {
        ipv4_address = var.worker1_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway_ip
    }
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = var.worker1_ip
      type        = "ssh"
      user        = "root"
      password    = var.root_password
    }
  }
}

resource "vsphere_virtual_machine" "worker2" {
  name             = "${local.client_id}-${random_string.random2}-worker"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  num_cores_per_socket = 2
  memory   = 4096
  guest_id = "debian10_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${local.client_id}-${random_string.random2}-worker"
    size  = 20
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${local.client_id}-${random_string.random2}-worker"
        domain    = "geronimo.com"
      }

      network_interface {
        ipv4_address = var.worker2_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway_ip
    }
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = var.worker2_ip
      type        = "ssh"
      user        = "root"
      password    = var.root_password
    }
  }
}