resource "vsphere_virtual_machine" "worker1" {
  name             = "${local.client_id}-${random_string.random1}-worker"
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
    label = "${local.client_id}-${random_string.random1}-worker"
    size  = 20
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

resource "vsphere_virtual_machine" "worker2" {
  name             = "${local.client_id}-${random_string.random2}-worker"
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
    label = "${local.client_id}-${random_string.random2}-worker"
    size  = 20
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