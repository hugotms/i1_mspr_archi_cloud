resource "vsphere_virtual_machine" "master" {
  name             = "${local.client_id}-master"
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
    label = "${local.client_id}-master-system"
    size  = 50
  }

  disk {
    label = "${local.client_id}-master-data"
    size  = 256
    thin_provisioned = true
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
