module "testbed" {
  source   = "git::https://github.com/mvitale1989/terraform-libvirt-testbed.git?ref=main"
  prefix   = "example-"
  networks = {
    "priv0" = { is_public = false, cidr = "10.90.1.0/24" },
    "priv1" = { is_public = false, cidr = "10.90.2.0/24" },
    "pub0"  = { is_public = true,  cidr = "10.91.1.0/24" },
    "pub1"  = { is_public = true,  cidr = "10.91.2.0/24" },
    "pub2"  = { is_public = true,  cidr = "10.91.3.0/24" },
  }
  domains = {
    "node0" = { networks = ["pub0", "priv0"]          },
    "node1" = { networks = ["pub1", "priv0", "priv1"] },
    "node2" = { networks = ["pub2", "priv1"]          },
  }
  ssh_authorized_keys = var.ssh_authorized_keys
}

# TODO currently broken, see README
#
#output "all_domain_ips" {
#  value = module.testbed.all_domain_ips
#}
