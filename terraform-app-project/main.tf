provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  for_each              = var.vms

  datastore_id          = data.vsphere_datastore.datastore.id
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id              = var.vm_guest_id

  network_interface {
    network_id          = data.vsphere_network.network.id
  }

  name                      = each.value.name

  num_cpus                  = var.vm_vcpu
  memory                    = var.vm_memory
  firmware                  = var.vm_firmware
  disk {
    label                   = var.vm_disk_label
    size                    = var.vm_disk_size
    thin_provisioned        = var.vm_disk_thin
  }

  clone {
    template_uuid           = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name           = each.value.name
        domain              = var.vm_domain
    }
    network_interface {
      ipv4_address          = each.value.vm_ip
      ipv4_netmask          = var.vm_ipv4_netmask
    }
    ipv4_gateway = var.vm_ipv4_gateway
    dns_server_list = var.vm_dns_servers
   }
  }
 }
