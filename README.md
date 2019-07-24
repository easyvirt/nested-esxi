# nested-esxi
An example for nested esxi deployment with terraform, as shown in easyvirt youtube channel
Description - work in progress

This are just beginnigs with Terraform, so please be gentle :)

## Embedded esxi
(based on great article: https://troylindsayblog.wordpress.com/2018/04/10/using-terraform-to-deploy-nested-esxi-hosts-in-your-vmware-cloud-on-aws-sddc-or-home-lab/) and embedded esxi images by https://www.virtuallyghetto.com/nested-virtualization.

You need to provide:
- staring addres (with dot in the end)
- offset
- name

IP calculation: ${var.start_ip_address}${count.index+var.ip_offset} => for this example 192.168.8.(x+111), so first host will habe 192.168.8.111 address, second .112, and so on.

---
The views and opinions expressed here are my own and they do not reflect the views and opinions of my employer.
