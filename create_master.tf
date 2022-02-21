resource "vsphere_virtual_machine" "master" {
  name             = "${local.client_id}-master"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  num_cores_per_socket = 4
  memory   = 8192
  guest_id = "debian10_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${local.client_id}-master-system"
    size  = 50
  }

  disk {
    label = "${local.client_id}-master-data"
    size  = 256
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${local.client_id}-master"
        domain    = "geronimo.com"
      }

      network_interface {
        ipv4_address = var.master_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway_ip
    }
  }

  provisioner "remote-exec" {
    script = "./bash/init.sh"

    connection {
      host        = var.master_ip
      type        = "ssh"
      user        = "root"
      password    = var.root_password
    }
  }
}
