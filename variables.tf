#
# Prefix to apply to all resources created on the system
#
variable "prefix" {
  type    = string
  default = "test-"
}

#
# `networks` options:
# - `is_pubic` (bool): whether this network allows traffic to the internet
# - `cidr` (string): the network CIDR
# Note: the network name will also be used as bridge name, to get around a provider race
#       condition (as of 0.6.3)
#
variable "networks" {
  type    = map(any)
  default = {}
}

#
# `domains` options:
# - `networks` (list of strings): name of all networks this node is connected to
# - `vcpu` (number): number of CPUs of the VM
# - `memory` (number): memory size of the VM, in MBs
# - `volumes` (list of strings): a list of additional disks for the VM, each element indicating its size in bytes
#
variable "domains" {
  type    = map(any)
  default = {}
}

#
# VM image to use. Must be qcow2 format and support cloudinit
#
variable "image" {
  type    = string
  default = "https://cloud.debian.org/images/cloud/OpenStack/10.7.3-20201230/debian-10.7.2-20201230-openstack-amd64.qcow2"
}

#
# Whether terraform will wait for the VMs to get an IP lease, before marking the domains as created
# NB: disabled by default, see README
#
variable "wait_for_lease" {
  type    = bool
  default = false
}

#
# authorized ssh keys for the `admin` user, on the instances
#
variable "ssh_authorized_keys" {
  type    = list(string)
  default = []
}

locals {
  all_domain_ips = flatten([for domain in libvirt_domain.domain : domain.network_interface[*].addresses])
  # TODO also return map of domain -> public IPs, for ease of use
}
