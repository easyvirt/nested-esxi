# Configure embedded ESXi

provider "vsphere" {
   version="~> 1.3"
   vsphere_server="${var.vcsa["address"]}"
   allow_unverified_ssl=true
   user="${var.vcsa["user"]}"
   password="${var.vcsa["password"]}"
 }

 # Data source_ranges

 data "vsphere_datacenter" "dc" {
   name="Datacenter"
 }

 data "vsphere_resource_pool" "pool" {
   name="testpool"
   datacenter_id="${data.vsphere_datacenter.dc.id}"
 }

 data "vsphere_datastore" "datastore" {
   name="vsanDatastore"
   datacenter_id="${data.vsphere_datacenter.dc.id}"
 }

 data "vsphere_network" "network" {
   name="OpenStackIntegrated"
   datacenter_id="${data.vsphere_datacenter.dc.id}"
 }

 data "vsphere_virtual_machine" "template" {
   name="Nested_ESXi6.7u2_Appliance_Template_v1"
   datacenter_id="${data.vsphere_datacenter.dc.id}"
 }

# Nested ESXi

 resource "vsphere_virtual_machine" "vm" {
   name="esxi${count.index+1}"
   count=6
   guest_id="vmkernel65Guest"
   resource_pool_id="${data.vsphere_resource_pool.pool.id}"
   datastore_id="${data.vsphere_datastore.datastore.id}"
   folder="Embedded-ESXi"
   num_cpus=2*8
   #memory=65536
   memory=128*1024
   wait_for_guest_net_timeout=0

   network_interface {
     network_id="${data.vsphere_network.network.id}"
   }

   disk {
     label="sda"
     unit_number=0
     size="${var.disk_sizes["sda"]}"
     eagerly_scrub="${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
     thin_provisioned="${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
   }

   disk {
     label="sdb"
     unit_number=1
     size="${var.disk_sizes["sdb"]}"
     eagerly_scrub="${data.vsphere_virtual_machine.template.disks.1.eagerly_scrub}"
     thin_provisioned="${data.vsphere_virtual_machine.template.disks.1.thin_provisioned}"
   }

   disk {
     label="sdc"
     unit_number=2
     size="${var.disk_sizes["sdc"]}"
     eagerly_scrub="${data.vsphere_virtual_machine.template.disks.2.eagerly_scrub}"
     thin_provisioned="${data.vsphere_virtual_machine.template.disks.2.thin_provisioned}"
   }

   clone {
     template_uuid="${data.vsphere_virtual_machine.template.id}"
   }

   vapp {
     properties = {
       "guestinfo.hostname" = "${var.hostname_prefix}${count.index+1}"
       "guestinfo.ipaddress" = "${var.start_ip_address}${count.index+var.ip_offset}" # Default = DHCP
       "guestinfo.netmask" = "${var.netmask}"
       "guestinfo.gateway" = "${var.gateway}"
#       "guestinfo.vlan" = ""
       "guestinfo.dns" = "${var.dns_nameservers}"
       "guestinfo.domain" = "${var.domain}"
       "guestinfo.ntp" = "${var.ntp_servers}"
#       "guestinfo.syslog" = ""
       "guestinfo.password" = "${var.password}" # Default = VMware1!
       "guestinfo.ssh" = "${var.enable_ssh}" # Case-sensitive string
#       "guestinfo.createvmfs" = "False" # Case-sensitive string
#       "guestinfo.debug" = "False" # Case-sensitive string
     }
   }

   lifecycle {
     ignore_changes = [
       "annotation",
      "vapp[0].properties",
     ]
   }
 }
