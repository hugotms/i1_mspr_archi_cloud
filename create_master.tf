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
    name = "${random_string.new_client_id.result}-master-system"
    label = "${random_string.new_client_id.result}-master-system"
    size  = 50
  }

  disk {
    name = "${random_string.new_client_id.result}-master-data"
    label = "${random_string.new_client_id.result}-master-data"
    size  = 256
    thin_provisioned = true
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
