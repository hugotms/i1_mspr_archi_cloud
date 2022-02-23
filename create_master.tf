resource "vsphere_virtual_machine" "master" {
  name             = "${random_string.new_client_id.result}-master"
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
    label = "disk0"
    datastore_id = data.vsphere_datastore.datastore.id
    size  = 50
  }

  disk {
    label = "${random_string.new_client_id.result}-master-data"
    datastore_id = data.vsphere_datastore.datastore.id
    size  = 256
    thin_provisioned = true
    unit_number = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${random_string.new_client_id.result}-master"
        domain    = "geronimo.com"
      }

    /*
    Commented block as VMs will be in DHCP for testing purposes

      network_interface {
        ipv4_address = var.master_ip
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
