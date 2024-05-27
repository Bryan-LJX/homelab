vsphere_server     = "lab-vcsa01a.bryan.local"
vsphere_user       = "administrator@vsphere.local"
vsphere_password   = "****"
datacenter         = "HomeLab"
datastore          = "iSCSI_Datastore"
cluster            = "HomeLab"
network_name       = "Terraform-PG"

# VM Details
vm_template_name   = "Ubuntu22-04-1_Template"
vm_guest_id        = "ubuntu64Guest"
vm_vcpu            = "2"
vm_memory          = "4096"
vm_ipv4_netmask    = "24"
vm_ipv4_gateway    = "192.168.1.254"
vm_dns_servers     = ["192.168.1.250", "8.8.8.8"]
vm_disk_label      = "disk0"
vm_disk_size       = "50"
vm_disk_thin       = "true"
vm_domain          = "bryan.local"
vm_firmware        = "bios"

vms = {
  tier-app01 = {
    name                = "app01"
    vm_ip               = "192.168.1.181"
  },
  tier-db01 = {
    name                = "db01"
    vm_ip               = "192.168.1.182"
  },
  tier-web01 = {
    name                = "web01"
    vm_ip               = "192.168.1.183"
  }
}
