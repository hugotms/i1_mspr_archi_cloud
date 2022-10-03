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
      children:
        control-plane:
          hosts:
            ${vsphere_virtual_machine.master.name}:
  EOF
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u svcansible -e client_id=${random_string.new_client_id.result} -i ${local_file.inventory.filename} --private-key ${var.ansible_private_key} --skip-tags '${var.skip_tags}' ./ansible/play_configure_cluster.yml"
  }
}

output "wordpress_url" {
  depends_on = [null_resource.ansible]
  description = "Client informations"
  value = "http://${vsphere_virtual_machine.master.default_ip_address}:32001/"
}
