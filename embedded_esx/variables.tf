# vSphere variables

variable "vcsa" {
  type = "map"
  default = {
    "address" = "IP_ADDRESS"    # fake SSD
    "user" = "YOUR_ACCOUNT_HERE"   # fake SSD
    "password" = "YOUR_PASSWORD_HERE"   # fake HDD
  }
}

# Generic system information

variable "start_ip_address" {
  description = "Staritng ip address"
  type = string
  default = "192.168.8."
}

variable "ip_offset" {
  description = "Offset for first ip address"
  default = 111
}

variable "hostname_prefix" {
  description = "Hostname prefix"
  default = "esx"
}

variable "netmask" {
  default = "255.255.255.0"
}

variable "gateway" {
  default = ""
}

variable "dns_nameservers" {
  default = ""
}

variable "domain" {
  default = ""
}

variable "ntp_servers" {
  default = ""
}

variable "password" {
  default = ""
}

variable "enable_ssh" {
  default = "False"
}

# ESXi disk size_bytes

variable "disk_sizes" {
  type = "map"
  default = {
    "sda" = 32    # fake SSD
    "sdb" = 100   # fake SSD
    "sdc" = 800   # fake HDD
  }
}
