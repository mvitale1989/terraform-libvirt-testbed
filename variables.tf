#
# Prefix to apply to all resources created on the system
#
variable "prefix" {
  type    = string
  default = "testbed-"
}

#
# `networks` options:
# - `is_pubic` (bool): whether this network allows traffic to the internet
# - `cidr` (string): the network CIDR
# Note: the network name will also be used as bridge name, to get around a provider race
#       condition (as of 0.6.3)
#
variable "networks" {
  type = map(any)
  default = {}
}

#
# `domains` options:
# - `networks` (list of strings): name of all networks this node is connected to
#
variable "domains" {
  type = map(any)
  default = {}
}

#
# VM image to use. Must be qcow2 format and support cloudinit
#
variable "image" {
  type = string
  default = "https://cloud.debian.org/images/cloud/OpenStack/current-10/debian-10-openstack-amd64.qcow2"
}

#
# authorized ssh keys for the `admin` user, on the instances
#
variable "ssh_authorized_keys" {
  type = list(string)
  default = []
}

locals {
  all_domain_ips = flatten([ for domain in libvirt_domain.domain : domain.network_interface[*].addresses ])
  # TODO also return map of domain -> public IP; e.g. to feed an ansible inventory
}
